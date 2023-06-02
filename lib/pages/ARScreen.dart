import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:geolocator/geolocator.dart';
import 'package:localization/localization.dart';

class ARScreen extends StatefulWidget {
  final String userName;  
  const ARScreen({required this.userName});

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  late ArCoreController arCoreController;
  bool showUpArrow = false, showDownArrow = false, showLeftArrow = false, showRightArrow = false;
  int imageIndex = 0;
  late List<String> rightArrows, leftArrows ,downArrows, upArrows;   
  late Timer timer;
  Future<Position> position = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  final int IMAGE_CHANGE_PERIOD_MS = 100;
  late Positioned arrow;

  void _buidArrowPaths(){
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
    timer = Timer.periodic(Duration(milliseconds: IMAGE_CHANGE_PERIOD_MS), (timer) {
      setState(() {
        imageIndex = (imageIndex + 1) % rightArrows.length;
      });
    });  
  }

  @override
  void dispose() {
    timer.cancel();
    arCoreController.dispose();
    super.dispose();
  }

  Positioned _buildArrow() {
    String currentArrowtoShow = showRightArrow ? rightArrows[imageIndex] : showLeftArrow ? leftArrows[imageIndex] : showDownArrow ? downArrows[imageIndex] : upArrows[imageIndex];
    return Positioned(bottom: 0, left: 0,  right: 0,
    child: Transform.scale(
      scale: 0.5,
      child: Image.asset(
        currentArrowtoShow,
        fit: BoxFit.contain,
      ),
      ),);
  }

  @override
  Widget build(BuildContext context) {
    _buidArrowPaths();
    var finding = 'finding'.i18n();
    var findingUserName = "$finding ${widget.userName}";
    return Scaffold(
      appBar: AppBar(
        title: Text(findingUserName),
      ),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
          ),
          _buildArrow(),
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
    print(position);
  }
}
