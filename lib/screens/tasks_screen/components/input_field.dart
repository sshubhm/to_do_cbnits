import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final Function? onAddTask;
  final String? labelText;
  final FocusNode? focusNode;

  const InputField(
      {this.controller, this.onAddTask, this.labelText, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        child: TextField(
          textInputAction: TextInputAction.go,
          focusNode: focusNode,
          onSubmitted: (value) {
            onAddTask!(value);
          },
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: labelText == null ? null : "Add New Task",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
