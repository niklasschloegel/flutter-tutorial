import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat/screens/auth_screen.dart';
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
              themeMode: ThemeMode.dark,
              debugShowCheckedModeBanner: false,
              theme: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark().copyWith(
                  primary: Colors.lime,
                  secondary: Colors.purple.shade200,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, snapshot) =>
                    snapshot.hasData ? ChatScreen() : AuthScreen(),
              ),
            );

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
