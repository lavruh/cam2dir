import 'dart:io';

import 'package:camera_app/domain/tree_widget_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:camera/camera.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:camera_app/domain/photo_proc_state.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

List<CameraDescription> cameras = [];

initDependencies() async {
  Get.put<SharedPreferences>(await SharedPreferences.getInstance());
  Get.put<PhotoPreviewState>(PhotoPreviewState());
  Get.put<CameraState>(CameraState());
  final photoProc = Get.put(PhotoProcState());
  Get.put<TreeWidgetController>(TreeWidgetController(
    path: photoProc.filePath.value,
    pathSetCallback: photoProc.setFilePath,
    conditionalLunch: photoProc.showIfFile,
  ));
}

Future<bool> isPermissionsGranted() async {
  bool fl = true;
  int v = await getAndroidVersion() ?? 5;
  if (v >= 12) {
    // Request of this permission on old devices leads to crash
    if (fl && await Permission.manageExternalStorage.status.isDenied) {
      fl = await Permission.manageExternalStorage.request().isGranted;
    }
  } else {
    if (fl && await Permission.storage.status.isDenied) {
      fl = await Permission.storage.request().isGranted;
    }
  }
  if (fl && await Permission.camera.status.isDenied) {
    fl = await Permission.camera.request().isGranted;
  }
  if (fl && await Permission.microphone.status.isDenied) {
    fl = await Permission.microphone.request().isGranted;
  }
  return fl;
}

Future<int?> getAndroidVersion() async {
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final androidVersion = androidInfo.version.release ?? '5';
    return int.parse(androidVersion.split('.')[0]);
  }
  return null;
}
