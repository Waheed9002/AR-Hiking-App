import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
class idelar extends StatelessWidget {
  const idelar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Model Viewer')),
        body: const ModelViewer(
          backgroundColor: Colors.transparent,
          src: 'assets/images/Idle.glb',
          alt: 'A 3D model of an Idle State',
          ar: true,
          cameraControls: true,
          autoRotate: true,
          arPlacement: ArPlacement.floor,


        ),
      ),
    );
  }
}