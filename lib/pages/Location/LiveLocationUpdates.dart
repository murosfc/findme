import 'package:findme/model/RealTimeLocation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveLocationUpdates extends StatefulWidget {
  @override
  _LiveLocationUpdatesState createState() => _LiveLocationUpdatesState();
}

class _LiveLocationUpdatesState extends State<LiveLocationUpdates> {
  late double showDistance = 0.0;
  late RealTimeLocation realTimeLocation;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roomId = prefs.getString('room_id');
    print("HHHHHHHHHHHHHHHHHHHHHHHHHHHH");
    print(roomId);

    realTimeLocation = RealTimeLocation();
    realTimeLocation.connect();
    realTimeLocation.joinRoom(roomId);

    realTimeLocation.getDistanceBetweenUsers(roomId);

    setState(() {
      showDistance = realTimeLocation.distanceBetween;
    });
  }

  @override
  void dispose() {
    realTimeLocation.disconnect();
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
            Text('Distance1: $showDistance'),
          ],
        ),
      ),
    );
  }
}
