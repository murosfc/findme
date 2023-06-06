import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:geolocator/geolocator.dart';
import 'package:localization/localization.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';

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
  late ArCoreNode imageNode;  
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  bool _hasNodeBeenAddedSecondTime = false;

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
  late Map<String, double> localUserCoordinates, remoteUserCoordinates;
  double distanceBetweenUsers = 0;
  final Calculation _calculation = Calculation();
  late List<double> _orientationValues;

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

    _orientationValues = List.filled(3, 0);
    _startAccelerometerListener();

    timer =
        Timer.periodic(Duration(milliseconds: IMAGE_CHANGE_PERIOD_MS), (timer) {
      setState(() {        
        imageIndex = (imageIndex + 1) % rightArrows.length;
      });
    });
  }

  void _startAccelerometerListener() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      _orientationValues = <double>[event.x, event.y, event.z];
      showArrow(_getArrowDirection());
      setState(() {
        _orientationValues = <double>[event.x, event.y, event.z];
        if (_isCameraFacingCoordinates() && !_hasNodeBeenAddedSecondTime) {
          _hasNodeBeenAddedSecondTime = true;
          _addImageNode();          
        }
      });
    });
  }

  String _getArrowDirection() {
    double x = _orientationValues[0];
    double y = _orientationValues[1];

    if (x.abs() > y.abs()) {
      if (x < 0) {
        return 'left';
      } else {
        return 'right';
      }
    } else {
      if (y < 0) {
        return 'up';
      } else {
        return 'down';
      }
    }
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

    setState(() {
      localUserCoordinates['latitude'] = position.latitude;
      localUserCoordinates['longitude'] = position.longitude;

      distanceBetweenUsers = _calculation.calculateDistanceBetweenUsers(
          remoteUserCoordinates, localUserCoordinates);
    });
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
            enableTapRecognizer: false,
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
    _addImageNode();       
  }

  bool _isCameraFacingCoordinates() {
    // Get the direction of the camera.
    final double x = _orientationValues[0];
    final double y = _orientationValues[1];
    final double z = _orientationValues[2];

    // Get the angle between the camera direction and the coordinates.
    final double angle = atan2(y, x);
    final double angleDegrees = angle * (180 / pi);

    // Get the difference between the camera direction and the coordinates.
    final double difference =
        remoteUserCoordinates['longitude']! - angleDegrees;

    // Return true if the difference is less than or equal to 10 degrees.
    return difference <= 10;
  }

    Future<Uint8List> _loadImageFromUrl() async {
    const String imageUrl =
        'https://raw.githubusercontent.com/murosfc/murosfc.github.io/main/user-logo.png';
    final response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  void _addImageNode() async{
    const IMG_SIZE = 512;    
    Uint8List imageBytes = await _loadImageFromUrl();

    final image = ArCoreImage(
      bytes: imageBytes,
      width: IMG_SIZE,
      height: IMG_SIZE,
    );

    imageNode = ArCoreNode(
      image: image,
      position:
          vector.Vector3(0.0, 0.0, -1.0), // Move o objeto para trás da câmera
      rotation:
          vector.Vector4(0.0, 0, 0.0, 0), // Rotação em radianos (45 graus)
      scale: vector.Vector3(0.2, 0.2, 0.2),
    );
    if(_hasNodeBeenAddedSecondTime){
      arCoreController.addArCoreNode(imageNode);      
    }
  }

  void showArrow(String direcao) {
    if (_isCameraFacingCoordinates()) {
      showRightArrow = showLeftArrow = showDownArrow = showUpArrow = false;
    }else{
    setState(() {
      showRightArrow = direcao == 'right';
      showLeftArrow = direcao == 'left';
      showDownArrow = direcao == 'down';
      showUpArrow = direcao == 'up';
    });
    }
  }  

}
