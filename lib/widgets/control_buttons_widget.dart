import 'package:camera/camera.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:camera_app/di.dart';
import 'package:get/state_manager.dart';

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
          Wrap(
            direction: Axis.vertical,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size.square(100))),
                  onPressed: () {
                    camera.toggleFlashMode();
                  },
                  child: getFlashIcon()),
            ],
          ),
          ElevatedButton(
              style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size.square(100))),
              onPressed: () {
                camera.takePhoto();
                // if (mounted) setState(() {});
              },
              child: const Icon(Icons.camera)),
        ],
      );
    });
  }

  Widget getFlashIcon() {
    if (camera.flashMode == FlashMode.auto) {
      return const Icon(Icons.flash_auto);
    } else if (camera.flashMode == FlashMode.always) {
      return const Icon(Icons.flash_on);
    } else if (camera.flashMode == FlashMode.torch) {
      return const Icon(Icons.flashlight_on);
    }
    return const Icon(Icons.flash_off);
  }
}
