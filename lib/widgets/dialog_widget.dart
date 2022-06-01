import 'package:flutter/material.dart';

class DialogWidget extends StatefulWidget {
  final String topic;
  final Function(String) callback;
  final String text;

  const DialogWidget({
    Key? key,
    BuildContext? context,
    String? initText,
    this.topic = "",
    required this.callback,
  })  : text = initText ?? "",
        super(key: key);

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  TextEditingController txtController = TextEditingController();

  @override
  void initState() {
    txtController.text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              TextField(
                controller: txtController,
                decoration: InputDecoration(
                    labelText: widget.topic,
                    suffixIcon: IconButton(
                        onPressed: () {
                          widget.callback(txtController.text);
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        icon: const Icon(Icons.check))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
