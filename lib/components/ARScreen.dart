import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class ARScreen extends StatefulWidget {
  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  ArCoreController arCoreController;

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  void _onARViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _addARObject();
  }

  void _addARObject() {
    final node = ArCoreNode(
      shape: ArCoreSphere(
        radius: 0.1,
        materials: [ArCoreMaterial(color: Colors.red)],
      ),
    );
    arCoreController.addArCoreNode(node);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ARCore Example'),
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onARViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }
}
