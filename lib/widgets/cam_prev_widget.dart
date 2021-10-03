import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CamPrevWidget extends StatefulWidget {
  final CameraController controller;

  const CamPrevWidget(this.controller, {Key? key}) : super(key: key);

  @override
  State<CamPrevWidget> createState() => _CamPrevWidgetState();
}

class _CamPrevWidgetState extends State<CamPrevWidget> {
  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) {
      return SizedBox(
        height: 350,
        width: 350,
        child: Container(
          child: const Text("Camera not init"),
          color: Colors.black,
        ),
      );
    }
    widget.controller.unlockCaptureOrientation();
    return Transform.scale(
      scale: 1,
      child:
          AspectRatio(aspectRatio: 1, child: CameraPreview(widget.controller)),
    );
  }
}
