import 'package:flutter/material.dart';

class ColoredTextField extends StatefulWidget {
  final Color primaryColor;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final void Function(String?)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool obscureText;
  final bool enabled;
  final TextEditingController? controller;
  final int maxLines;

  const ColoredTextField({
    Key? key,
    required this.primaryColor,
    required this.focusNode,
    required this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.obscureText = false,
    this.enabled = true,
    this.controller,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  _ColoredTextFieldState createState() => _ColoredTextFieldState();
}

class _ColoredTextFieldState extends State<ColoredTextField> {
  @override
  void initState() {
    widget.focusNode.addListener(_triggerUpdate);
    super.initState();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_triggerUpdate);
    super.dispose();
  }

  void _triggerUpdate() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      decoration: widget.decoration.copyWith(
        labelStyle: TextStyle(
          color: widget.focusNode.hasFocus
              ? widget.primaryColor
              : Colors.grey.shade700,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.primaryColor),
        ),
      ),
      cursorColor: widget.primaryColor,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      validator: widget.validator,
      initialValue: widget.initialValue,
      obscureText: widget.obscureText,
      controller: widget.controller,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
    );
  }
}
