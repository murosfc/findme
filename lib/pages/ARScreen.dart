import 'dart:async';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

class ARScreen extends StatefulWidget {
  final String userName;

  const ARScreen({required this.userName});

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
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
    const objectPath = 'assets/models/scene.gltf';
    final node = ArCoreReferenceNode(
      name: 'arrow',
      objectUrl: objectPath,
      position: vector_math.Vector3(
          0, 0, -1), // Set the position of the model as needed
      scale:
          vector_math.Vector3(1, 1, 1), // Set the scale of the model as needed
    );

    arCoreController.addArCoreNodeWithAnchor(node);
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
