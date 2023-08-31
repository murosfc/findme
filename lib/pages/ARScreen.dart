import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:geolocator/geolocator.dart';
import 'package:localization/localization.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock/wakelock.dart';

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
  int countArImage = 0;

  //Geolocation variables
  double distanceBetweenUsers = 0;
  double bearingBetweenUsers = 0;
  bool bearingChanged = false;

  //Connection variables
  late String? roomId = '';
  late RealTimeLocation realTimeLocation = RealTimeLocation();
  late String userName = '';

  //arrow variables
  double _arrowAngle = 90;
  double? heading;
  String _arrowImagePath = "";

  @override
  void initState() {
    super.initState();

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
      _addImageNode();
    });
  }

  Future<void> getRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    roomId = prefs.getString('room_id') ?? '';
    userName = prefs.getString('name_user') ?? '';
  }

  Future<void> updateDistance(double newDistance, double newBearing,
      double remoteLatitude, double remoteLongitude) async {
    if (newBearing != bearingBetweenUsers) {
      bearingChanged = true;
    }
    distanceBetweenUsers = newDistance;
    bearingBetweenUsers = newBearing;
  }

  @override
  void dispose() {
    FlutterCompass.events?.listen((event) {}).cancel();
    arCoreController.dispose();
    realTimeLocation.disconnect();
    Wakelock.disable();
    super.dispose();
  }

  Visibility _getArrow() {
    String imageName = 'assets/images/';
    if (_arrowAngle.abs() > 20) {
      imageName += 'arrow-red.png';
    } else if (_arrowAngle.abs() > 5) {
      imageName += 'arrow-yellow.png';
    } else {
      imageName += 'arrow-green.png';
    }
    return Visibility(
      visible: distanceBetweenUsers > 0,
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: _arrowAngle * pi / 180,
            child: Image.asset(imageName, width: 150),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
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
          _getArrow(),
          Visibility(
            visible: distanceBetweenUsers > 0,
            child: Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Text(
                "$userName ${'is-distance'.i18n()} $formattedDistance ${'away'.i18n()}",
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
  }

  void _updateArrowAngle() {
    double arrowAngle = heading! - bearingBetweenUsers;

    if (arrowAngle < 0) {
      arrowAngle = arrowAngle.abs() / 180 * 90;
    } else {
      arrowAngle = -arrowAngle / 180 * 90;
    }
    setState(() {
      _arrowAngle = arrowAngle;
    });
  }

  bool _isCameraFacingCoordinates() {
    return _arrowAngle.abs() <= 10;
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
    if (bearingChanged && _isCameraFacingCoordinates()) {
      var NODE_NAME = 'user-logo-$countArImage';
      countArImage++;
      const IMG_SIZE = 512;
      if (imageBytes.isEmpty) {
        imageBytes = await _loadImageFromUrl();
      }
      final image = ArCoreImage(
        bytes: imageBytes,
        width: IMG_SIZE,
        height: IMG_SIZE,
      );  
      var previousNodeName = 'user-logo-${countArImage - 1}';    
      arCoreController.removeNode(nodeName: previousNodeName);     
      imageNode = ArCoreNode(
        image: image,
        position: vector.Vector3(0.0, 0.0,
            -getMaxImageDistance()), // Move o objeto para trás da câmera à distância máxima ou a do amigo
        rotation: vector.Vector4(0.0, 0, 0.0, 0),
        scale: vector.Vector3(0.7, 0.7, 0.7),
        name: NODE_NAME,
      );
      arCoreController.addArCoreNode(imageNode);
      bearingChanged = false;
    }
  }
}
