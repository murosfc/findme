import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:localization/localization.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock_plus/wakelock_plus.dart';

import '../model/RealTimeLocation.dart';
import '../constants/app_constants.dart';
import '../utils/app_utils.dart';

class ARScreen extends StatefulWidget {
  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  //ARcore variables
  ArCoreController? arCoreController;
  ArCoreNode? imageNode;
  Uint8List imageBytes = Uint8List(0);
  int countArImage = 0;
  ArCoreImage? avatar;

  //Geolocation variables
  double distanceBetweenUsers = 0;
  double bearingBetweenUsers = 0;
  bool bearingChanged = false;
  bool distanceChanged = false;

  String? roomId = '';
  RealTimeLocation? realTimeLocation;
  String userName = '';

  //arrow variables
  double _arrowAngle = 90;
  double? heading;

  @override
  void initState() {
    super.initState();

    _initializeRealTimeLocation();

    _loadImageFromUrl();

    FlutterCompass.events?.listen((event) {
      setState(() {
        heading = event.heading;
      });
      _updateArrowAngle();
      if (distanceOrBearinChanged() && _isCameraFacingCoordinates()) {
        _addImageNode();
      }
    });
  }

  bool distanceOrBearinChanged() {
    return distanceBetweenUsers > 0 || bearingChanged;
  }

  Future<void> _initializeRealTimeLocation() async {
    await _getRoom();
    realTimeLocation = RealTimeLocation();
    realTimeLocation?.connect();
    realTimeLocation?.joinRoom(roomId);
    realTimeLocation?.getDistanceBetweenUsers(updateDistance);
  }

  Future<void> _getRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    roomId = prefs.getString('room_id') ?? '';
    userName = prefs.getString('name_user') ?? '';
  }

  Future<void> updateDistance(double newDistance, double newBearing,
      double remoteLatitude, double remoteLongitude) async {
    bearingChanged = (newBearing != bearingBetweenUsers);
    distanceChanged = (newDistance != distanceBetweenUsers);    
    distanceBetweenUsers = newDistance;
    bearingBetweenUsers = newBearing;
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    realTimeLocation?.disconnect();
    WakelockPlus.disable();
    super.dispose();
  }

  Visibility _getArrow() {
    final imageName = AppUtils.getArrowImagePath(_arrowAngle);
    
    return Visibility(
      visible: distanceBetweenUsers > 0,
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: AppUtils.degreesToRadians(_arrowAngle),
            child: Image.asset(imageName, width: 150),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    final formattedDistance = AppUtils.formatDistance(distanceBetweenUsers);
    return Scaffold(
      appBar: AppBar(
        title: Text("${'finding'.i18n()} $userName"),
      ),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: false,
            enableUpdateListener: true,
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
    if (heading == null) return;
    
    final arrowAngle = AppUtils.calculateArrowAngle(heading!, bearingBetweenUsers);
    setState(() {
      _arrowAngle = arrowAngle;
    });    
  }

  bool _isCameraFacingCoordinates() {
    return AppUtils.isWithinThreshold(_arrowAngle, AppConstants.cameraFacingThreshold);
  }

  _loadImageFromUrl() async {
    final response = await http.get(Uri.parse(AppConstants.defaultImageUrl));
    imageBytes = response.bodyBytes;
    avatar = ArCoreImage(
      bytes: imageBytes,
      width: AppConstants.imageSize,
      height: AppConstants.imageSize,
    );
  }

  double getMaxImageDistance() {
    return AppUtils.constrainDistance(distanceBetweenUsers, AppConstants.maxImageDistance);
  }

  void _addImageNode() async {
    countArImage++;
    
    if (countArImage > 1) {
      arCoreController?.removeNode(nodeName: AppConstants.userLogoNodeName);
    }
    
    if (avatar != null) {
      imageNode = ArCoreNode(
        image: avatar!,
        position: vector.Vector3(0.0, 0.0, -getMaxImageDistance()),
        rotation: vector.Vector4(0.0, 0, 0.0, 0),
        scale: vector.Vector3(0.7, 0.7, 0.7),
        name: AppConstants.userLogoNodeName,
      );
      arCoreController?.addArCoreNode(imageNode!);
      bearingChanged = false;
      distanceChanged = false;
    }
  }
}
