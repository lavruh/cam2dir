import 'package:camera_app/domain/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogWidget extends StatelessWidget {
  TextEditingController txtController = TextEditingController();
  String topic;
  Function? callback;

  DialogWidget({
    Key? key,
    BuildContext? context,
    String? initText,
    this.topic = "",
    this.callback,
  }) : super(key: key) {
    txtController.text = initText ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraState>(
        builder: (_) => Dialog(
              shape: const RoundedRectangleBorder(),
              backgroundColor: Colors.transparent,
              child: Card(
                elevation: 5,
                child: Wrap(
                  children: [
                    Text(
                      topic,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    TextField(
                      controller: txtController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                // _.setNamePrefix(txtController.text);
                                callback!(txtController.text);
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              icon: const Icon(Icons.check))),
                    ),
                  ],
                ),
              ),
            ));
  }
}
