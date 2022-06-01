import 'package:camera/camera.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class CamPrevWidget extends StatelessWidget {
  const CamPrevWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devWidth = MediaQuery.of(context).size.width;
    return GetBuilder<CameraState>(builder: (_) {
      if ((_.camCtrl != null) & (!_.camCtrl!.value.isInitialized)) {
        return Container(
          width: 300,
          height: 300,
          color: Colors.indigo,
          child: const Center(
            child: Text(
              "Camera not init",
            ),
          ),
        );
      } else {
        CameraController controller = _.camCtrl!;
        controller.unlockCaptureOrientation();
        return CameraPreview(controller);
      }
    });
  }
}
