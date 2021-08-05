import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final VoidCallback selectHandler;
  final String title;

  Answer(this.selectHandler, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.deepOrange,
        ),
        child: Text(title),
        onPressed: selectHandler,
      ),
    );
  }
}
