import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARObject extends StatefulWidget {
  @override
  _ARObjectState createState() => _ARObjectState();
}

class _ARObjectState extends State<ARObject> {
  late ArCoreController arCoreController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _addExternalObject();
  }

  void _addExternalObject() {
    final node = ArCoreReferenceNode(
        objectUrl:
            "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/AnimatedTriangle/glTF/AnimatedTriangle.gltf",
        position: vector.Vector3(0, 0, -1));

    arCoreController.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
