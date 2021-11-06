import 'package:camera_app/domain/camera_state.dart';
import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:camera_app/widgets/cam_prev_widget.dart';
import 'package:camera_app/widgets/control_buttons_widget.dart';
import 'package:camera_app/widgets/file_location_widget.dart';
import 'package:camera_app/widgets/photo_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    Get.find<CameraState>().initCamera();
    super.initState();
  }

  @override
  void dispose() {
    Get.find<CameraState>().disposeCamera();
    Get.find<PhotoPreviewState>().saveState();
    Get.find<CameraState>().saveState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dispose();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Wrap(
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
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
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
      ),
    );
  }
}
