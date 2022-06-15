import 'package:camera/camera.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class CamPrevWidget extends StatelessWidget {
  const CamPrevWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraState>(builder: (_) {
      if ((_.camCtrl != null) && (_.camCtrl!.value.isInitialized)) {
        CameraController controller = _.camCtrl!;
        controller.unlockCaptureOrientation();
        return CameraPreview(controller);
      } else {
        return Container(
          color: Colors.black,
          child: const Center(
            child: Text(
              "Camera not init",
            ),
          ),
        );
      }
    });
  }
}
