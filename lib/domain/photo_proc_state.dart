import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:camera_app/services/user_info_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoProcState extends GetxController {
  final settings = Get.find<SharedPreferences>();
  final camera = Get.find<CameraState>();
  final basePath = "/storage/emulated/0/DCIM".obs;
  final filePath = "/storage/emulated/0/DCIM".obs;
  final fileName = "file_name.jpg".obs;
  final prefix = "prefix".obs;

  saveState() async {
    await settings.setString("basePath", basePath.value);
    await settings.setString("filePath", filePath.value);
    await settings.setString("prefix", prefix.value);
  }

  loadState() {
    const standartPath = "/storage/emulated/0/DCIM";
    basePath.value = settings.getString("basePath") ?? standartPath;
    filePath.value = settings.getString("filePath") ?? standartPath;
    prefix.value = settings.getString("prefix") ?? "";
  }

  setBasePath(String val) {
    if (Directory(val).existsSync()) {
      basePath.value = val;
      setFilePath(val);
    } else {
      showInSnackBar("Directory does not exist");
    }
  }

  setFilePath(String value) {
    if (Directory(value).existsSync()) {
      filePath.value = value;
    } else {
      showInSnackBar("File path does not exist");
    }
  }

  setNamePrefix(String val) {
    prefix.value = val;
  }

  String generateFileName({String prefix = ""}) {
    return "${prefix}_${DateFormat("y-MM-dd_HH_mm_ms").format(DateTime.now())}.jpg";
  }

  takePhotoAndProcess() async {
    try {
      XFile pic = await camera.takePhoto();
      fileName.value = generateFileName();
      final fileLocation = "$filePath/$prefix$fileName";
      pic.saveTo(fileLocation);
      Get.find<PhotoPreviewState>().addPhoto(fileLocation);
      showInSnackBar("Photo saved to $fileLocation");
    } on Exception catch (e) {
      showInSnackBar(e.toString());
    }
  }
}
