import 'package:camera/camera.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:camera_app/widgets/info_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

InfoWidgetState info = Get.put<InfoWidgetState>(InfoWidgetState());
List<CameraDescription> cameras = [];
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
var cam_controller = CameraController(cameras[0], ResolutionPreset.max);
final CameraState camera =
    Get.put<CameraState>(CameraState(cam_controller), permanent: true);
