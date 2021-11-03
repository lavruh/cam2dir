import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_app/di.dart';
import 'package:camera_app/widgets/info_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraState extends GetxController {
  CameraController? camCtrl;

  CameraState(this.camCtrl);

  SharedPreferences settings = Get.find();
  final info = Get.find<InfoWidgetState>();

  String basePath = "/storage/emulated/0/DCIM".obs();
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
    if ((flashMode.index + 1) == FlashMode.values.length) {
      flashMode = FlashMode.values.first;
    } else {
      flashMode = FlashMode.values[flashMode.index + 1];
    }
    camCtrl?.setFlashMode(flashMode);
    update();
  }

  setBasePath(String val) {
    basePath = val;
    setFilePath(val);
  }

  bool showIfFile(String value) {
    final editor = Get.find<DesignationOnImageState>();
    print(value);
    if (File(value).existsSync()) {
      editor.loadImage(File(value));
      return true;
    }
    return false;
  }

  setFilePath(String value) {
    if (Directory(value).existsSync()) {
      filePath = value;
    }
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
      fileName = generateFileName();
      pic.saveTo("$filePath/$fileName");
      photoPreview.addPhoto("$filePath/$fileName");
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
        camCtrl!.setFlashMode(flashMode),
      ]);
    } on CameraException catch (e) {
      showCameraException(e);
    }
    update();
  }

  saveState() async {
    await settings.setString("basePath", basePath);
    await settings.setString("filePath", filePath);
    await settings.setString("prefix", prefix);
  }

  loadState() {
    basePath = settings.getString("basePath") ?? "/storage/emulated/0/DCIM";
    filePath = settings.getString("filePath") ?? "/storage/emulated/0/DCIM";
    prefix = settings.getString("prefix") ?? "";
    update();
  }

  @override
  void onInit() {
    loadState();
    super.onInit();
  }

  callOtherApp() {}
}
