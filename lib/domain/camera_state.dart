import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_app/di.dart';
import 'package:camera_app/widgets/info_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CameraState extends GetxController {
  CameraController? camCtrl;

  CameraState(this.camCtrl);

  final Directory baseDir = Directory("/storage/emulated/0/DCIM").obs();
  String filePath = "/storage/emulated/0/DCIM".obs();
  String fileName = "".obs();
  String prefix = "".obs();
  FlashMode flashMode = FlashMode.off;

  double _minAvailableExposureOffset = 0;
  double _maxAvailableExposureOffset = 0;
  double _maxAvailableZoom = 0;
  double _minAvailableZoom = 0;

  String generateFileName({String prefix = ""}) {
    return "${prefix}_${DateFormat("yMdjms").format(DateTime.now())}.jpg";
  }

  toggleFlashMode() {
    showInSnackBar(flashMode.index.toString());
    if ((flashMode.index + 1) == FlashMode.values.length) {
      flashMode = FlashMode.values.first;
    } else {
      flashMode = FlashMode.values[flashMode.index + 1];
    }
    camCtrl?.setFlashMode(flashMode);
    update();
  }

  setFilePath(String value) {
    filePath = value;
    update();
  }

  setNamePrefix(String val) {
    prefix = val;
    update();
  }

  takePhoto() async {
    info.showMsg("Take photo\n");
    if (!camCtrl!.value.isInitialized) {
      showInSnackBar("Controller not init\n");
      initCamera();
      return null;
    }
    if (camCtrl!.value.isTakingPicture) {
      showInSnackBar("CameraScreen busy\n");
      initCamera();
      return null;
    }
    try {
      XFile pic = await camCtrl!.takePicture();
      pic.saveTo("$filePath/${prefix}_$fileName");
      fileName = generateFileName();
      showInSnackBar("Photo saved to $filePath/$fileName");
    } on Exception catch (e) {
      showInSnackBar(e.toString());
    }
    update();
  }

  void disposeCamera() async {
    if (camCtrl != null) {
      await camCtrl!.dispose();
      showInSnackBar("controller dispose");
    }
  }

  void initCamera() async {
    camCtrl = CameraController(cameras[0], ResolutionPreset.max);

    camCtrl!.addListener(() {
      if (camCtrl!.value.hasError) {
        showInSnackBar('Camera error ${camCtrl?.value.errorDescription}');
      }
    });

    try {
      await camCtrl!.initialize();
      await Future.wait([
        camCtrl!
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        camCtrl!
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
        camCtrl!.getMaxZoomLevel().then((value) => _maxAvailableZoom = value),
        camCtrl!.getMinZoomLevel().then((value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      showCameraException(e);
    }
    update();
  }

  callOtherApp() {}
}
