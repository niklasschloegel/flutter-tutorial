import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FireChatApp());
}

class FireChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          if (snapshot.connectionState == ConnectionState.done)
            return MaterialApp(
              title: "FireChat",
              home: ChatScreen(),
            );

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
