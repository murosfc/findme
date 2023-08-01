import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:geolocator/geolocator.dart';
import 'package:localization/localization.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wakelock/wakelock.dart';

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
  Uint8List imageBytes = Uint8List(0);

  //Geolocation variables
  double distanceBetweenUsers = 0;
  double bearingBetweenUsers = 0;

  //Connection variables
  late String? roomId = '';
  late RealTimeLocation realTimeLocation = RealTimeLocation();
  late String userName = '';

  //arrow variables
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;  
  double _arrowAngle = 90;
  double? heading;

  @override
  void initState() {
    super.initState();

    Wakelock.enable();

    getRoom().then((_) {
      realTimeLocation = RealTimeLocation();
      realTimeLocation.connect();
      realTimeLocation.joinRoom(roomId);
      realTimeLocation.getDistanceBetweenUsers(updateDistance);
    });

    FlutterCompass.events?.listen((event) {
      setState(() {
        heading = event.heading;
      });
      _updateArrowAngle();
      if (_isCameraFacingCoordinates()) {
        setState(() {
          _addImageNode();
        });
      }
    });
  }

  Future<void> getRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    roomId = prefs.getString('room_id') ?? '';
    userName = prefs.getString('name_user') ?? '';
  }

  Future<void> updateDistance(double newDistance, double newBearing,
      double remoteLatitude, double remoteLongitude) async {
    distanceBetweenUsers = newDistance;
    bearingBetweenUsers = newBearing;
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    accelerometerEvents.drain();
    arCoreController.dispose();
    realTimeLocation.disconnect();
    Wakelock.disable();
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
          Visibility(
            visible: distanceBetweenUsers > 0,
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: _arrowAngle * pi / 180,
                  child: Image.asset('assets/images/arrow.png', width: 200),
                ),
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
                "$userName ${'is-distance'.i18n()} $formattedDistance ${'away'.i18n()}. \nHeading: ${heading!.toStringAsFixed(2)} \nBearing between users: ${bearingBetweenUsers.toStringAsFixed(2)} \nArrow angle: ${_arrowAngle.toStringAsFixed(2)}",
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

  void _updateArrowAngle() {
    double arrowAngle = heading! + bearingBetweenUsers;

    if (arrowAngle < 0) {
      arrowAngle = arrowAngle.abs() / 180 * 90;
    } else {
      arrowAngle = arrowAngle / 180 * 90 + 90;
    }

    setState(() {
      _arrowAngle = arrowAngle;
    });
  }

  bool _isCameraFacingCoordinates() {
    return _arrowAngle < 10;
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
          vector.Vector4(0.0, 0, 0.0, 0), 
      scale: vector.Vector3(0.7, 0.7, 0.7),
      name: 'user-logo',
    );
    if (_isCameraFacingCoordinates() && distanceBetweenUsers > 0) {
      setState(() {
        arCoreController.removeNode(nodeName: imageNode.name);
        arCoreController.addArCoreNode(imageNode);
      });
    }
  }
}
