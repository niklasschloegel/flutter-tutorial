import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (ctx, i) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Text("Test"),
        );
      },
    );
  }
}
