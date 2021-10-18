import 'dart:async';
import 'package:camera_app/screens/fs_tree_view.dart';
import 'package:camera_app/domain/tree_widget_controller.dart';
import 'package:camera_app/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  PageController controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // does not work
    final CameraController? cameraController = camera.camCtrl;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      cameraController.initialize();
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
          )),
        ],
      ),
    );
  }

  final ThemeData _theme = ThemeData(
      primarySwatch: Colors.green,
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
