import 'dart:async';
import 'package:camera_app/domain/camera_state.dart';
import 'package:camera_app/domain/photo_proc_state.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'di.dart';
import 'package:camera_app/screens/fs_tree_view.dart';
import 'package:camera_app/screens/camera_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await isPermissionsGranted()) {
    cameras = await availableCameras();
    await initDependencies();
    runApp(const CameraApp());
  }
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  CameraAppState createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  PageController controller = PageController(initialPage: 0);
  final camera = Get.find<CameraState>();
  final photoProcState = Get.find<PhotoProcState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller.addListener(() {});
  }

  @override
  void dispose() async {
    camera.disposeCamera();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      camera.disposeCamera();
      photoProcState.saveState();
    } else if (state == AppLifecycleState.resumed) {
      camera.initCamera();
      photoProcState.loadState();
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
          const CameraScreen(),
          // FsTreeView(),
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
      iconTheme: const IconThemeData(color: Colors.lightGreenAccent),
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        headline3: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.lightGreenAccent),
        headline6: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        bodyText1: TextStyle(fontSize: 12.0),
      ));
}
