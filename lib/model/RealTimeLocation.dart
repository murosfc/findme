import 'dart:async';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RealTimeLocation {
  late IO.Socket socket;
  late Timer shareLocationTimer;
  late double distance = 0.0;
  late double bearing = 0.0;

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
        'https://findme-real-time-location.onrender.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
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

  void shareLocation(roomId) {
    // Fetch the initial position immediately
    _sendLocation(roomId);

    // Start a timer to fetch the position at regular intervals
    shareLocationTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      _sendLocation(roomId);
    });
  }

  void stopSharingLocation() {
    if (shareLocationTimer != null) {
      shareLocationTimer.cancel();
      print('Stopped sharing location');
    }
  }

  Future<Position> _getCurrentLocation() async {
    LocationAccuracyStatus accuracyStatus =
        await Geolocator.getLocationAccuracy();
    LocationAccuracy desiredAccuracy;
    if (accuracyStatus == LocationAccuracyStatus.reduced) {
      desiredAccuracy = LocationAccuracy.lowest;
    } else {
      desiredAccuracy = LocationAccuracy.high;
    }
    Position position =
        await Geolocator.getCurrentPosition(desiredAccuracy: desiredAccuracy);
    return position;
  }

  void _sendLocation(String roomId) async {
    Position position = await _getCurrentLocation();
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
      Function(double, double) callback) async {
    socket.on('getFriendPosition', (locationData) async {
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
      print("Distance: $distance meters");
      print("Angulacao: $bearing graus");

      callback(distance.round().toDouble(), friendLongitude);
    });
  }
}
