import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:geolocator/geolocator.dart';
import 'package:localization/localization.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';

//import 'package:findme/model/Calculation.dart';

import '../colors/VisualIdColors.dart';
import '../model/RealTimeLocation.dart';

class ARScreen extends StatefulWidget {
  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  //ARcore variables
  late ArCoreController arCoreController;
  late ArCoreNode imageNode;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  Uint8List imageBytes = Uint8List(0);

  //Geolocation variables
  double friendLatitude = 0;
  double friendLongitude = 0;
  double distanceBetweenUsers = 0;
  double bearingBetweenUsers = 0;

  late List<double> _orientationValues;

  //Connection variables
  late String? roomId = '';
  late RealTimeLocation realTimeLocation = RealTimeLocation();
  late String userName = '';

  //arrow variables
  double _heading = 0;

  @override
  void initState() {
    super.initState();

    getRoom().then((_) {
      realTimeLocation = RealTimeLocation();
      realTimeLocation.connect();
      realTimeLocation.joinRoom(roomId);
      realTimeLocation.getDistanceBetweenUsers(updateDistance);
    });

    _orientationValues = List.filled(2, 0);
    _startAccelerometerListener();
  }

  Future<void> getRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    roomId = prefs.getString('room_id') ?? '';
    userName = prefs.getString('name_user') ?? '';
  }

  void _startAccelerometerListener() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      _orientationValues = <double>[event.x, event.y];
      // _heading = _calculateHeading();
      // if (_isCameraFacingCoordinates()) {
      //   setState(() {
      //     _addImageNode();
      //   });
      // }
    });
  }

  Future<void> updateDistance(double newDistance, double newBearing,
      double remoteLatitude, double remoteLongitude) async {
    setState(() {
      distanceBetweenUsers = newDistance;
      bearingBetweenUsers = newBearing;

      if (remoteLatitude != 0 && remoteLongitude != 0) {
        friendLatitude = remoteLatitude;
        friendLongitude = remoteLongitude;

        _heading = _calculateHeading();

        if (_isCameraFacingCoordinates()) {
          setState(() {
            _addImageNode();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    arCoreController.dispose();
    realTimeLocation.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDistance;
    if (distanceBetweenUsers > 1000) {
      double distanceInKm = distanceBetweenUsers / 1000;
      formattedDistance = '${distanceInKm.toStringAsFixed(2)} Km';
    } else {
      formattedDistance = '${distanceBetweenUsers.toStringAsFixed(2)} m';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${'finding'.i18n()} $userName"),
      ),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: false,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: _heading,
                child: Image.asset('assets/images/arrow.png', width: 200),
              ),
            ),
          ),
          Visibility(
            visible: distanceBetweenUsers > 0,
            child: Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Text(
                '$userName ${'is-distance'.i18n()} $formattedDistance ${'away'.i18n()}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _addImageNode();
  }

  double _calculateHeading() {
    print("friendLongitude: $friendLongitude");
    print("friendLatitude: $friendLatitude");

    print(_orientationValues[1]);
    print(_orientationValues[0]);

    double deltaY = _orientationValues[1] - friendLongitude;
    double deltaX = _orientationValues[0] - friendLatitude;

    double heading = atan2(deltaY, deltaX) * (180 / pi); // angle in degrees
    print("fdsfsdfds");

    print(heading);
    // mantém a seta apontada sempre buscando o giro da câmera
    if (heading >= 0) {
      return heading;
    }
    if (heading < 0 && heading >= -90) {
      return 0;
    }
    return 180;
  }

  bool _isCameraFacingCoordinates() {
    if (friendLatitude == 0 && friendLongitude == 0) {
      return false; // Not enough data to determine facing direction
    }

    // Get the direction of the camera.
    final double x = _orientationValues[0];
    final double y = _orientationValues[1];

    // Get the angle between the camera direction and the coordinates.
    final double angle = atan2(y, x); //angle in radians
    final double angleDegrees = angle * (180 / pi); //angle in degrees

    final double difference = friendLongitude - angleDegrees;

    // Return true if the difference is less than or equal to 10 degrees.
    return difference <= 10;
  }

  Future<Uint8List> _loadImageFromUrl() async {
    const String imageUrl =
        'https://raw.githubusercontent.com/murosfc/murosfc.github.io/main/user-logo.png';
    final response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  double getMaxImageDistance() {
    return distanceBetweenUsers > 10 ? 10 : distanceBetweenUsers;
  }

  void _addImageNode() async {
    const IMG_SIZE = 512;
    if (imageBytes.isEmpty) {
      imageBytes = await _loadImageFromUrl();
    }

    final image = ArCoreImage(
      bytes: imageBytes,
      width: IMG_SIZE,
      height: IMG_SIZE,
    );

    imageNode = ArCoreNode(
      image: image,
      position: vector.Vector3(0.0, 0.0,
          -getMaxImageDistance()), // Move o objeto para trás da câmera à distância máxima ou a do amigo
      rotation:
          vector.Vector4(0.0, 0, 0.0, 0), // Rotação em radianos (45 graus)
      scale: vector.Vector3(0.7, 0.7, 0.7),
      name: 'user-logo',
    );
    if (_isCameraFacingCoordinates()) {
      arCoreController.removeNode(nodeName: imageNode.name);
      arCoreController.addArCoreNode(imageNode);
    }
  }
}
