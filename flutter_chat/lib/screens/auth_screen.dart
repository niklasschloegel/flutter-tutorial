import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/widgets/auth/auth_form.dart';
import 'package:path/path.dart' as p;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    File? image,
    BuildContext ctx,
  ) async {
    String? errorMessage;
    var data = {
      "username": username,
      "email": email,
    };

    try {
      setState(() => _isLoading = true);
      UserCredential authResult;

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        if (image != null) {
          final user = authResult.user;
          if (user == null) return;

          final ref = FirebaseStorage.instance
              .ref()
              .child("user_image")
              .child(user.uid + p.extension(image.path));

          ref.putFile(image);
          final url = await ref.getDownloadURL();
          data["image_url"] = url;
        }

        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user?.uid)
            .set(data);
      }
    } on PlatformException catch (err) {
      print(err);
      errorMessage = "An error occured, please check your credentials";

      var errMessage = err.message;
      if (errMessage != null) errorMessage = errMessage;

      setState(() => _isLoading = false);
    } catch (err) {
      print(err);
      errorMessage = "An error occured, please check your credentials";

      var errMessage = err.toString();
      errorMessage = errMessage;

      setState(() => _isLoading = false);
    }
    if (errorMessage != null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        onSubmit: _submitAuthForm,
        isLoading: _isLoading,
      ),
    );
  }
}
