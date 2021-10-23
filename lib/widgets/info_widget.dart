import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera_app/di.dart';

void showInSnackBar(String msg) {
  Get.snackbar("Msg", msg, colorText: Colors.green);
}

void showCameraException(CameraException e) {
  showInSnackBar('Error: ${e.code}\n${e.description}');
}

class InfoWidgetState extends GetxController {
  final msg = ''.obs;

  showMsg(String m) {
    msg.value = m;
    update();
  }
}
