import 'dart:async';
import 'package:camera_app/domain/camera_state.dart';
import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'di.dart';
import 'package:camera_app/screens/fs_tree_view.dart';
import 'package:camera_app/domain/tree_widget_controller.dart';
import 'package:camera_app/screens/camera_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await init_dependencies();
  runApp(const CameraApp());
  final camera = Get.find<CameraState>();
  camera.disposeCamera();
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  PageController controller = PageController(initialPage: 0);
  final camera = Get.find<CameraState>();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      Get.find<PhotoPreviewState>().saveState();
      camera.saveState();
    });
  }

  @override
  void dispose() async {
    camera.disposeCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      camera.disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      camera.initCamera();
    } else if (state == AppLifecycleState.paused) {
      camera.disposeCamera();
    } else if (state == AppLifecycleState.detached) {
      camera.disposeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _theme,
      home: PageView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        children: [
          CameraScreen(),
          FsTreeView(
              treeController: TreeWidgetController(
            path: camera.filePath,
            pathSetCallback: camera.setFilePath,
            conditionalLunch: camera.showIfFile,
          )),
        ],
      ),
    );
  }

  final ThemeData _theme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.grey,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey))),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: "Georgia",
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        headline3: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
        headline6: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        bodyText1: TextStyle(fontSize: 12.0),
      ));
}
