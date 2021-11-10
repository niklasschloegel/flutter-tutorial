import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/widgets/auth/auth_form.dart';

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
    BuildContext ctx,
  ) async {
    String? message;

    try {
      setState(() => _isLoading = true);
      var authResult = isLogin
          ? await _auth.signInWithEmailAndPassword(
              email: email, password: password)
          : await _auth.createUserWithEmailAndPassword(
              email: email, password: password);

      if (!isLogin) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user?.uid)
            .set({
          "username": username,
          "email": email,
        });
      }
    } on PlatformException catch (err) {
      print(err);
      message = "An error occured, please check your credentials";

      var errMessage = err.message;
      if (errMessage != null) message = errMessage;

      setState(() => _isLoading = false);
    } catch (err) {
      print(err);
      message = "An error occured, please check your credentials";

      var errMessage = err.toString();
      message = errMessage;

      setState(() => _isLoading = false);
    }
    if (message != null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
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
