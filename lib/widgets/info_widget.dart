import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void showInSnackBar(String msg) {
  // key.currentState?.showSnackBar(SnackBar(content: Text(msg)));
  ScaffoldMessenger(
    child: SnackBar(
      content: Text(msg),
    ),
  );
}

void showCameraException(CameraException e) {
  showInSnackBar('Error: ${e.code}\n${e.description}');
}
