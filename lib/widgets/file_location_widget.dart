import 'package:camera/camera.dart';
import 'package:camera_app/di.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileLocationWidget extends StatelessWidget {
  CameraState state = Get.put(CameraState(cam_controller));

  TextEditingController txtController = TextEditingController();

  FileLocationWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: Column(
        children: [
          GetBuilder<CameraState>(builder: (_) {
            return Text("File path = ${camera.filePath}",
                style: Theme.of(context).textTheme.headline3);
          }),
          // Obx(() => Text("File path = ${camera.filePath}",
          //     style: Theme.of(context).textTheme.headline3)),
          GetBuilder<CameraState>(
              builder: (_) => Text("File name = ${_.fileName}",
                  style: Theme.of(context).textTheme.headline3)),
          TextField(
            controller: txtController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }
}
