import 'package:camera/camera.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:camera_app/domain/photo_proc_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControlButtonsWidget extends StatelessWidget {
  const ControlButtonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GetX<CameraState>(builder: (state) {
          return IconButton(
              onPressed: () => state.toggleFlashMode(),
              icon: Icon(getFlashIcon(state.flashMode), size: 24));
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42.0),
          child: IconButton(
              onPressed: () => Get.find<PhotoProcState>().takePhotoAndProcess(),
              icon: const Icon(Icons.camera, size: 42)),
        ),
        IconButton(
            onPressed: () => Get.find<CameraState>().toggleCamera(),
            icon: const Icon(Icons.cameraswitch, size: 24)),
      ],
    );
  }

  IconData getFlashIcon(FlashMode flashMode) {
    if (flashMode == FlashMode.auto) {
      return Icons.flash_auto;
    } else if (flashMode == FlashMode.always) {
      return Icons.flash_on;
    } else if (flashMode == FlashMode.torch) {
      return Icons.flashlight_on;
    }
    return Icons.flash_off;
  }
}
