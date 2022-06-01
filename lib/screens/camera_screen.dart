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
    // Get.find<CameraState>().disposeCamera();
    // Get.find<PhotoPreviewState>().saveState();
    // Get.find<CameraState>().saveState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dispose();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black87,
          body: Center(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                const CamPrevWidget(),
                Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  children: [
                    const FileLocationWidget(),
                    const ControlButtonsWidget(),
                    PhotoPreviewWidget(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
