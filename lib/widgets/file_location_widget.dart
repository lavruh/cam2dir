import 'package:camera_app/domain/photo_proc_state.dart';
import 'package:camera_app/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileLocationWidget extends StatelessWidget {
  // TextEditingController txtController = TextEditingController();

  const FileLocationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        child: Wrap(
          children: [
            GetX<PhotoProcState>(builder: (_) {
              return TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogWidget(
                          context: context,
                          topic: "Base path :",
                          initText: _.basePath.value,
                          callback: _.setBasePath,
                        );
                      });
                },
                child: Text(_.filePath.value,
                    style: Theme.of(context).textTheme.headline3),
              );
            }),
            GetX<PhotoProcState>(
                builder: (_) => TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DialogWidget(
                                context: context,
                                topic: "Prefix :",
                                initText: _.prefix.value,
                                callback: _.setNamePrefix,
                              );
                            });
                      },
                      child: Text("/${_.prefix}_${_.fileName}",
                          style: Theme.of(context).textTheme.headline3),
                    )),
          ],
        ));
  }
}
