import 'dart:async';

import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

class ARScreenSquare extends StatefulWidget {
  final String userName;

  const ARScreenSquare({required this.userName});

  @override
  _ARScreenSquareState createState() => _ARScreenSquareState();
}

class _ARScreenSquareState extends State<ARScreenSquare> {
  late ArCoreController arCoreController;

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _onARViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _addARObject();
  }

  void _addARObject() async {
    final square = ArCoreCube(
      materials: [ArCoreMaterial(color: Colors.red)],
      size: vector_math.Vector3(0.2, 0.2, 0.2),
    );

    final squareNode = ArCoreNode(
      shape: square,
      position: vector_math.Vector3(0, 0, -1), // Set the position of the square
      name: 'square',
    );

    arCoreController.addArCoreNodeWithAnchor(squareNode);
  }

  void _updateARObjectPosition() {
    // TODO: Implement code to update the AR object's position
    // based on your specific requirements.
  }

  @override
  Widget build(BuildContext context) {
    var finding = 'finding'.i18n();
    var nome = "$finding ${widget.userName}";

    return Scaffold(
      appBar: AppBar(
        title: Text(nome),
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onARViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }
}
