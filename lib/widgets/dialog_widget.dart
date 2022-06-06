import 'package:flutter/material.dart';

class DialogWidget extends StatefulWidget {
  final String topic;
  final Function(String) callback;
  final String? Function(String? val)? validator;
  final String text;

  const DialogWidget({
    Key? key,
    BuildContext? context,
    String? initText,
    this.topic = "",
    required this.callback,
    this.validator,
  })  : text = initText ?? "",
        super(key: key);

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  TextEditingController txtController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
            child: Wrap(
              children: [
                TextFormField(
                  controller: txtController,
                  validator: widget.validator,
                  decoration: InputDecoration(
                      labelText: widget.topic,
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.callback(txtController.text);
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          },
                          icon: const Icon(Icons.check))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
