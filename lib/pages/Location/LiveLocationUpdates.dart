import 'package:findme/model/RealTimeLocation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LiveLocationUpdates extends StatefulWidget {
  @override
  _LiveLocationUpdatesState createState() => _LiveLocationUpdatesState();
}

class _LiveLocationUpdatesState extends State<LiveLocationUpdates> {
  late double showDistance = 0.0;
  late String? roomId = '';
  late RealTimeLocation realTimeLocation = RealTimeLocation();
  @override
  void initState() {
    super.initState();
    getRoom().then((_) {
      realTimeLocation = new RealTimeLocation();
      realTimeLocation.connect();
      realTimeLocation.joinRoom(roomId);
      // realTimeLocation.getDistanceBetweenUsers(updateDistance);
    });
  }

  Future<void> getRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    roomId = prefs.getString('room_id') ??
        ''; // Assign an empty string if roomId is null
  }

  void updateDistance(double newDistance) {
    setState(() {
      showDistance = newDistance;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Location Updates'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Distance1: ${showDistance?.toString() ?? ''}',
              style: TextStyle(
                color: Colors.white, // Set the text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
