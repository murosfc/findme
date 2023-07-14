import 'dart:async';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RealTimeLocation {
  late IO.Socket socket;
  late StreamSubscription<Position> positionStreamSubscription;
  late double distance = 0.0;
  late double bearing = 0.0;
  final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, distanceFilter: 1);

  final _API_URL = 'https://findme-real-time-location.onrender.com/';

  String generateRoomId() {
    // Generate a random room ID
    String characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    String roomId = '';
    for (int i = 0; i < 8; i++) {
      roomId += characters[Random().nextInt(characters.length)];
    }
    return roomId;
  }

  void connect() {
    socket = IO.io(
      _API_URL,
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );
    socket.connect();
  }

  void disconnect() {
    if (socket != null && socket.connected) {
      socket.disconnect();
      print('Disconnected from the server');
    }
  }

  void joinRoom(roomId) {
    socket.emit('joinRoom', roomId);
  }

  void leaveRoom(roomId) {
    socket.emit('leaveRoom', roomId);
  }

  void close() {
    socket.emit('close');
  }

  void shareLocation(roomId) async {
    _getCurrentLocation().then((position) {
      _sendLocation(roomId, position);
    });

    positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      position != null
          ? _sendLocation(roomId, position)
          : print('Localização nula');
    });
  }

  void stopSharingLocation() {
    positionStreamSubscription.cancel();
    print('Stopped sharing location');
  }

  Future<Position> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permission denied forever. Please enable it in the app settings.';
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    }

    throw 'Location permission denied.';
  }

  void _sendLocation(String roomId, Position position) {
    Map<String, dynamic> locationUpdate = {
      'room_id': roomId,
      'location_data': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
    };
    socket.emit('shareLocation', locationUpdate);
  }

  Future<void> getDistanceBetweenUsers(
      Function(double, double, double) callback) async {
    socket.on('getFriendPosition', (locationData) async {
      Map<String, double> thisDevicePosition = {};
      Map<String, double> friendPosition = {};
      double friendLatitude = locationData['latitude'].toDouble();
      double friendLongitude = locationData['longitude'].toDouble();
      Position myPosition = await _getCurrentLocation();
      distance = Geolocator.distanceBetween(
        myPosition.latitude,
        myPosition.longitude,
        friendLatitude,
        friendLongitude,
      );

      bearing = Geolocator.bearingBetween(
        myPosition.latitude,
        myPosition.longitude,
        friendLatitude,
        friendLongitude,
      );
      thisDevicePosition['latitude'] = myPosition.latitude;
      thisDevicePosition['longitude'] = myPosition.longitude;
      friendPosition['latitude'] = friendLatitude;
      friendPosition['longitude'] = friendLongitude;
      print("Distance: $distance meters");
      print("Angulacao: $bearing graus");

      callback(distance.round().toDouble(), bearing, friendLongitude);
    });
  }
}
