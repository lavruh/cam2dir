import 'package:camera_app/di.dart';
import 'package:camera_app/widgets/cam_prev_widget.dart';
import 'package:camera_app/widgets/control_buttons_widget.dart';
import 'package:camera_app/widgets/file_location_widget.dart';
import 'package:camera_app/widgets/info_widget.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:get/get.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    camera.initCamera();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Center(
        child: Wrap(
          children: [
            CamPrevWidget(),
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: [
                  FileLocationWidget(),
                  ControlButtonsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
