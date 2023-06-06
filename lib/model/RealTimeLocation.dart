import 'dart:async';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RealTimeLocation {
  late IO.Socket socket;
  late Timer shareLocationTimer;
  late double distanceBetween = 0.0;
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
        'https://findnme-location-real-time.up.railway.app/', <String, dynamic>{
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

  void shareLocation(roomId) {
    shareLocationTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      Position position = await _getCurrentLocation();
      _sendLocation(position, roomId);
    });
  }

  void stopSharingLocation() {
    if (shareLocationTimer != null) {
      shareLocationTimer.cancel();
      print('Stopped sharing location');
    }
  }

  Future<Position> _getCurrentLocation() async {
    // Use the Geolocator package to get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<void> _sendLocation(Position position, String roomId) async {
    // Prepare the location update data
    Map<String, dynamic> locationUpdate = {
      'room_id': roomId,
      'location_data': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
    };
    socket.emit('shareLocation', locationUpdate);
  }

  Future<void> getDistanceBetweenUsers(String? roomId) async {
    Position myPosition = await _getCurrentLocation();
    print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
    socket.on('getFriendPosition', (location_data) async {
      print("Received friend position data: $location_data");

      Position currentPosition = await _getCurrentLocation();
      Position friendPosition = location_data;

      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        friendPosition.latitude,
        friendPosition.longitude,
      );
      distanceBetween = distance;
    });
  }
}
