import 'package:camera/camera.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class CamPrevWidget extends StatelessWidget {
  const CamPrevWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraState>(builder: (_) {
      if ((_.camCtrl != null) & (!_.camCtrl!.value.isInitialized)) {
        return Container(
          color: Colors.indigo,
          child: SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: Text(
                "Camera not init",
              ),
            ),
          ),
        );
      } else {
        CameraController controller = _.camCtrl!;
        // controller.unlockCaptureOrientation();
        return Transform.scale(
          scale: 1,
          child: AspectRatio(aspectRatio: 1, child: CameraPreview(controller)),
        );
      }
    });
  }
}
