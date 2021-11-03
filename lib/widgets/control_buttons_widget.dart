import 'package:camera/camera.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControlButtonsWidget extends StatelessWidget {
  const ControlButtonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraState>(builder: (_) {
      return Wrap(
        spacing: 10,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          _customButton(
              child: getFlashIcon(_.flashMode),
              onPressed: () {
                _.toggleFlashMode();
              }),
          _customButton(
              onPressed: () {
                _.takePhoto();
              },
              child: const Icon(Icons.camera)),
        ],
      );
    });
  }

  Widget _customButton({
    required Widget child,
    required void Function() onPressed,
  }) {
    return ElevatedButton(
        style: ButtonStyle(
            minimumSize:
                MaterialStateProperty.all<Size>(const Size.square(50))),
        onPressed: onPressed,
        child: child);
  }

  Widget getFlashIcon(FlashMode flashMode) {
    if (flashMode == FlashMode.auto) {
      return const Icon(Icons.flash_auto);
    } else if (flashMode == FlashMode.always) {
      return const Icon(Icons.flash_on);
    } else if (flashMode == FlashMode.torch) {
      return const Icon(Icons.flashlight_on);
    }
    return const Icon(Icons.flash_off);
  }
}
