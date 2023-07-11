import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:geolocator/geolocator.dart';
import 'package:localization/localization.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';

//import 'package:findme/model/Calculation.dart';

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

  //Geolocation variables
  late Map<String, double> localUserCoordinates, remoteUserCoordinates;
  double distanceBetweenUsers = 0; 
  late List<double> _orientationValues;

  //Connection variables
  late String? roomId = '';
  late RealTimeLocation realTimeLocation = RealTimeLocation();
  late String userName = '';

  //controlador da seta
  double _heading = 0.0;

  //imagem renderizar AR
  late Uint8List imageBytes;
 
  @override
  void initState() {
    super.initState();
    
    getRoom().then((_) {
      realTimeLocation = RealTimeLocation();
      realTimeLocation.connect();
      realTimeLocation.joinRoom(roomId);
      realTimeLocation.getDistanceBetweenUsers(updateDistance);
    });

    _loadImageFromUrl();

  _orientationValues = List.filled(2, 0);
  _startAccelerometerListener();     
  }

 double _calculateHeading() {
  double destLat = remoteUserCoordinates['latitude'] ?? 0.0;
  double destLong = remoteUserCoordinates['longitude'] ?? 0.0;

  // Calcular a direção da bússola em relação à coordenada desejada
  double currentLat = localUserCoordinates['latitude'] ?? 0.0;
  double currentLong = localUserCoordinates['longitude'] ?? 0.0;

  double deltaY = destLong - currentLong;
  double deltaX = destLat - currentLat;
  
  double angle = atan2(deltaY, deltaX) * (180 / pi);
  double heading = angle - 90.0;
  
  // Limitar a rotação entre 0 e 180 graus
  if (heading < 0.0) {
    heading += 360.0;
  }
  if (heading > 180.0) {
    heading -= 180.0;
  }
  
  return heading;
}

  Future<void> getRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    roomId = prefs.getString('room_id') ?? '';
    userName = prefs.getString('name_user') ?? '';
  }

  void _startAccelerometerListener() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {         
      setState(() {
        _heading = _calculateHeading();
        _orientationValues = <double>[event.x, event.y];
        if (_isCameraFacingCoordinates()) {          
          _addImageNode();          
        } 
      });
    });
  } 

  Future<void> updateDistance(double newDistance, Map<String, double> localUserCoordinates, Map<String, double> remoteUserCoordinates) async {
      this.localUserCoordinates = localUserCoordinates;
      this.remoteUserCoordinates = remoteUserCoordinates; 
      setState(() {
        distanceBetweenUsers = newDistance;           
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
                angle: ((_heading ?? 0) * 3.14159) / 180,
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

  bool _isCameraFacingCoordinates() {
    // Get the direction of the camera.
    final double x = _orientationValues[0];
    final double y = _orientationValues[1];    

    // Get the angle between the camera direction and the coordinates.
    final double angle = atan2(y, x);
    final double angleDegrees = angle * (180 / pi);

    double remoteUserLongitude = remoteUserCoordinates['longitude'] ?? 0.0;

    // Get the difference between the camera direction and the coordinates.
    final double difference = remoteUserLongitude - angleDegrees; //Em remoteUserLongitude preciso pegar a longitude do usuário remoto

    // Return true if the difference is less than or equal to 30 degrees.
    return difference <= 30;
  }
  

  _loadImageFromUrl() async {
    const String imageUrl =
        'https://raw.githubusercontent.com/murosfc/murosfc.github.io/main/user-logo.png';
    final response = await http.get(Uri.parse(imageUrl));
    imageBytes = response.bodyBytes;
  }

  void _addImageNode() async{
    const IMG_SIZE = 512;     

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
    if(_isCameraFacingCoordinates()){
      arCoreController.addArCoreNode(imageNode);      
    }
  } 

}
