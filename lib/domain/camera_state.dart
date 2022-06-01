import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_app/di.dart';
import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:camera_app/services/user_info_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';

class CameraState extends GetxController {
  CameraController? camCtrl =
      CameraController(cameras[0], ResolutionPreset.max);

  final photoPreview = Get.find<PhotoPreviewState>();
  final _selectedCamera = cameras[0].obs;
  final _flashMode = FlashMode.off.obs;
  FlashMode get flashMode => _flashMode.value;

  toggleFlashMode() {
    if ((flashMode.index + 1) == FlashMode.values.length) {
      _flashMode.value = FlashMode.values.first;
    } else {
      _flashMode.value = FlashMode.values[flashMode.index + 1];
    }
    camCtrl?.setFlashMode(flashMode);
  }

  bool showIfFile(String value) {
    final editor = Get.find<DesignationOnImageState>();
    if (File(value).existsSync()) {
      editor.loadImage(File(value));
      return true;
    }
    return false;
  }

  toggleCamera() async {
    final index = cameras.indexOf(_selectedCamera.value);
    if (index == cameras.length - 1) {
      _selectedCamera.value = cameras.first;
    } else {
      _selectedCamera.value = cameras[index + 1];
      await disposeCamera();
      try {
        await initCamera();
      } on CameraException catch (e) {
        _selectedCamera.value = cameras.first;
        await disposeCamera();
        await initCamera();
      }
    }
  }

  Future<XFile> takePhoto() async {
    if (!camCtrl!.value.isInitialized) {
      initCamera();
      throw Exception("Camera is not ready");
    }
    if (camCtrl!.value.isTakingPicture) {
      initCamera();
      throw Exception("Camera is busy");
    }
    return await camCtrl!.takePicture();
  }

  disposeCamera() async {
    final CameraController? oldController = camCtrl;
    if (oldController != null) {
      camCtrl = null;
      await oldController.dispose();
    }
  }

  initCamera() async {
    if (cameras.isEmpty) {
      return;
    }
    camCtrl = CameraController(_selectedCamera.value, ResolutionPreset.max);

    camCtrl!.addListener(() {
      if (camCtrl!.value.hasError) {
        showInSnackBar('Camera error ${camCtrl?.value.errorDescription}');
      }
    });

    try {
      await camCtrl!.initialize();
      await Future.wait([
        camCtrl!.setFlashMode(flashMode),
      ]);
    } on CameraException catch (e) {
      showCameraException(e);
      _selectedCamera.value = cameras.first;
      await initCamera();
    }

    update();
  }
}
