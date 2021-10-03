import 'package:camera_app/di.dart';
import 'package:camera_app/widgets/cam_prev_widget.dart';
import 'package:camera_app/widgets/file_location_widget.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:get/get.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            CamPrevWidget(camera.camCtrl!),
            FileLocationWidget(),
            Wrap(
              children: [
                ElevatedButton(
                    onPressed: () {
                      camera.initCamera();
                      if (mounted) setState(() {});
                    },
                    child: const Text("init")),
                ElevatedButton(
                    onPressed: () {
                      camera.takePhoto();
                      if (mounted) setState(() {});
                    },
                    child: const Icon(Icons.camera)),
                ElevatedButton(
                    onPressed: () {
                      camera.callOtherApp();
                      if (mounted) setState(() {});
                    },
                    child: const Icon(Icons.call)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
