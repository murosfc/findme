import 'package:flutter/material.dart';

class LiveLocationUpdates extends StatefulWidget {
  @override
  _LiveLocationUpdatesState createState() => _LiveLocationUpdatesState();
}

class _LiveLocationUpdatesState extends State<LiveLocationUpdates> {
  late String variable1;
  late String variable2;

  @override
  void initState() {
    super.initState();
    // Call the variables here or fetch their values from an external source
    variable1 = 'Value 1';
    variable2 = 'Value 2';
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
            Text('Variable 1: $variable1'),
            Text('Variable 2: $variable2'),
          ],
        ),
      ),
    );
  }
}
