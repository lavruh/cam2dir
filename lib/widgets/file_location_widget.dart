import 'package:camera_app/di.dart';
import 'package:camera_app/domain/camera_state.dart';
import 'package:camera_app/widgets/prefix_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileLocationWidget extends StatelessWidget {
  CameraState state = Get.find();

  TextEditingController txtController = TextEditingController();

  FileLocationWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GetBuilder<CameraState>(builder: (_) {
          return ElevatedButton(
            onPressed: () {},
            child: Text(camera.filePath,
                style: Theme.of(context).textTheme.headline3),
          );
        }),
        GetBuilder<CameraState>(
            builder: (_) => ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return PrefixDialogWidget(
                            context: context,
                            initText: _.prefix,
                          );
                        });
                  },
                  child: Text(
                      "/${_.prefix}_${_.fileName != '' ? _.fileName : '...jpeg'}",
                      style: Theme.of(context).textTheme.headline3),
                )),
      ],
    );
  }
}
