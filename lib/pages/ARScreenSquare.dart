import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'package:localization/localization.dart';

import '../colors/VisualIdColors.dart';

class ARScreenSquare extends StatefulWidget {
  final String userName;

  const ARScreenSquare({required this.userName});

  @override
  _ARScreenSquareState createState() => _ARScreenSquareState();
}

class _ARScreenSquareState extends State<ARScreenSquare> {
  late ArCoreController arCoreController;
  bool isObjectPlaced = false;

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  void _onARViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _addARObject();
  }

  void _addARObject() async {
    final fixedVertex = vector_math.Vector3(0.0, 0.0, -1.0);
    final rotatingNode = ArCoreRotatingNode(
      shape: ArCoreCube(
        materials: [
          ArCoreMaterial(
            color: VisualIdColors.colorBlue(),
            reflectance: 0.5,
          ),
        ],
        size: vector_math.Vector3(0.2, 0.01, 0.2),
      ),
      position: fixedVertex,
      rotation: vector_math.Vector4(0.0, 1.0, 0.0, 0.0),
    );
    arCoreController.addArCoreNodeWithAnchor(rotatingNode);
    setState(() {
      isObjectPlaced = true;
    });
  }

  void _removeARObject() {
    arCoreController.removeNode(nodeName: 'rotating_cube');
    setState(() {
      isObjectPlaced = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var finding = 'finding'.i18n();
    var name = "$finding ${widget.userName}";

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onARViewCreated,
        enableTapRecognizer: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isObjectPlaced ? _removeARObject : _addARObject,
        child: Icon(isObjectPlaced ? Icons.remove : Icons.add),
      ),
    );
  }
}
