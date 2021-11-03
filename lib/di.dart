import 'package:camera/camera.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:camera_app/widgets/info_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription> cameras = [];
// var cam_controller = );

final PhotoPreviewState photoPreview =
    Get.put<PhotoPreviewState>(PhotoPreviewState(), permanent: true);
// final CameraState camera =

init_dependencies() async {
  Get.put<SharedPreferences>(await SharedPreferences.getInstance());
  Get.put<InfoWidgetState>(InfoWidgetState());

  Get.put<CameraState>(CameraState(), permanent: true);
}
