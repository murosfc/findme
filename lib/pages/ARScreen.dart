import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:geolocator/geolocator.dart';
import 'package:localization/localization.dart';

import 'package:findme/model/Calculation.dart';

class ARScreen extends StatefulWidget {
  final String userName;
  final Map<String, double> remoteUserCoordinates;
  const ARScreen({required this.userName, required this.remoteUserCoordinates});

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  //ARcore variables
  late ArCoreController arCoreController;

  //Arrow drawing variables
  bool showUpArrow = false,
      showDownArrow = false,
      showLeftArrow = false,
      showRightArrow = false;
  int imageIndex = 0;
  late List<String> rightArrows, leftArrows, downArrows, upArrows;
  final int IMAGE_CHANGE_PERIOD_MS = 100;
  late Positioned arrow;
  late Timer timer;

  //Geolocation variables
  late Matrix4 remoteUserCoordinatesToMatrix;
  late Map<String, double> localUserCoordinates, remoteUserCoordinates;
  double distanceBetweenUsers = 0;
  final Calculation _calculation = Calculation();

  void _buidArrowPaths() {
    final int QUANTITY_OF_ARROWS = 4;
    rightArrows = List<String>.filled(QUANTITY_OF_ARROWS, '');
    leftArrows = List<String>.filled(QUANTITY_OF_ARROWS, '');
    downArrows = List<String>.filled(QUANTITY_OF_ARROWS, '');
    upArrows = List<String>.filled(QUANTITY_OF_ARROWS, '');
    for (var i = 0; i < QUANTITY_OF_ARROWS; i++) {
      rightArrows[i] = 'assets/images/right$i.png';
      leftArrows[i] = 'assets/images/left$i.png';
      downArrows[i] = 'assets/images/down$i.png';
      upArrows[i] = 'assets/images/up$i.png';
    }
  }

  @override
  void initState() {
    super.initState();

    localUserCoordinates = {};
    _updateLocalUserCoordinates();
    remoteUserCoordinates = widget.remoteUserCoordinates;

    timer =
        Timer.periodic(Duration(milliseconds: IMAGE_CHANGE_PERIOD_MS), (timer) {
      setState(() {
        imageIndex = (imageIndex + 1) % rightArrows.length;
      });
    });
  }

  Future<void> _updateLocalUserCoordinates() async {
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

    localUserCoordinates['latitude'] = position.latitude;
    localUserCoordinates['longitude'] = position.longitude;

    distanceBetweenUsers = _calculation.calculateDistanceBetweenUsers(
        remoteUserCoordinates, localUserCoordinates);
  }

  static void updateRemoteUserLocation(
      Map<String, double> remoteUserCoordinates) {
    remoteUserCoordinates = remoteUserCoordinates;
  }

  @override
  void dispose() {
    timer.cancel();
    arCoreController.dispose();
    super.dispose();
  }

  Positioned _buildArrow() {
    String currentArrowtoShow = showRightArrow
        ? rightArrows[imageIndex]
        : showLeftArrow
            ? leftArrows[imageIndex]
            : showDownArrow
                ? downArrows[imageIndex]
                : upArrows[imageIndex];
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Transform.scale(
        scale: 0.5,
        child: Image.asset(
          currentArrowtoShow,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _buidArrowPaths();

    String formattedDistance;
    if (distanceBetweenUsers > 1000) {
      double distanceInKm = distanceBetweenUsers / 1000;
      formattedDistance = '${distanceInKm.toStringAsFixed(2)} Km';
    } else {
      formattedDistance = '${distanceBetweenUsers.toStringAsFixed(2)} m';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${'finding'.i18n()} ${widget.userName}"),
      ),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
          ),
          _buildArrow(),
          Visibility(
            visible: distanceBetweenUsers > 0,
            child: Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Text(
                '${widget.userName} ${'is-distance'.i18n()} $formattedDistance ${'away'.i18n()}',
                textAlign: TextAlign.center,
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

  void showArrow(String direcao) {
    setState(() {
      showRightArrow = direcao == 'right';
      showLeftArrow = direcao == 'left';
      showDownArrow = direcao == 'down';
      showUpArrow = direcao == 'up';
    });
  }
}
