import 'package:FireChat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(FireChatApp());

class FireChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FireChat",
      home: ChatScreen(),
    );
  }
}
