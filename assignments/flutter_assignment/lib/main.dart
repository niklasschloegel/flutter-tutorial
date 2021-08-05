import 'package:flutter/material.dart';
import 'package:flutter_assignment/text.dart';
import 'package:flutter_assignment/text_control.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static const _textA = 'This is a test';
  static const _textB = 'This is another test';
  var _text = _textA;

  void _changeText() {
    setState(() {
      _text = _text == _textA ? _textB : _textA;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            TextDisplay(_text),
            TextControl("Change text", _changeText),
          ],
        ),
      ),
    ));
  }
}
