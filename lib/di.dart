import 'package:camera/camera.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:camera_app/domain/tree_widget_controller.dart';
import 'package:camera_app/widgets/info_widget.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription> cameras = [];

init_dependencies() async {
  Get.put<SharedPreferences>(await SharedPreferences.getInstance());
  Get.put<InfoWidgetState>(InfoWidgetState());
  Get.put<PhotoPreviewState>(PhotoPreviewState(), permanent: true);
  final camera = Get.put<CameraState>(CameraState(), permanent: true);
  Get.put<TreeWidgetController>(TreeWidgetController(
    path: camera.filePath,
    pathSetCallback: camera.setFilePath,
    conditionalLunch: camera.showIfFile,
  ));
}
