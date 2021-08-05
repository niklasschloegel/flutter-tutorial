import 'package:flutter/material.dart';

class TextControl extends StatelessWidget {
  final String text;
  final VoidCallback onPressHandler;

  TextControl(this.text, this.onPressHandler);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressHandler,
      child: Text(text),
    );
  }
}
