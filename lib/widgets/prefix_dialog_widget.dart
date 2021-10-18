import 'package:camera_app/domain/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrefixDialogWidget extends StatelessWidget {
  TextEditingController txtController = TextEditingController();

  PrefixDialogWidget({
    Key? key,
    BuildContext? context,
    String? initText,
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
                      "Prefix :",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    TextField(
                      controller: txtController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                _.setNamePrefix(txtController.text);
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
