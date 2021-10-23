import 'package:camera_app/di.dart';
import 'package:camera_app/widgets/cam_prev_widget.dart';
import 'package:camera_app/widgets/control_buttons_widget.dart';
import 'package:camera_app/widgets/file_location_widget.dart';
import 'package:camera_app/widgets/info_widget.dart';
import 'package:camera_app/widgets/photo_preview_widget.dart';
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
      backgroundColor: Colors.black87,
      body: Center(
        child: Wrap(
          // direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width > 600
                  ? MediaQuery.of(context).size.height
                  : MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width > 600
                  ? MediaQuery.of(context).size.height
                  : MediaQuery.of(context).size.width,
              child: CamPrevWidget(),
            ),
            Container(
              color: Colors.black87,
              child: Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  FileLocationWidget(),
                  const ControlButtonsWidget(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width > 600
                        ? MediaQuery.of(context).size.width * 0.3
                        : MediaQuery.of(context).size.width,
                    child: PhotoPreviewWidget(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
