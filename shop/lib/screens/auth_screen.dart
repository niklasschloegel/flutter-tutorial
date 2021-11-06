import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/widgets/colored_textfield.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordConfirmationFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationFocusNode.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("An Error Occured"),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(), child: Text("Ok")),
          ],
        ),
      );

  Future<void> _submit() async {
    var currState = _formKey.currentState;
    if (currState != null) {
      if (!currState.validate()) return;
      currState.save();
    }
    setState(() => _isLoading = true);
    final auth = Provider.of<Auth>(context, listen: false);
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        auth.login(_authData["email"]!, _authData["password"]!);
      } else {
        // Sign user up
        auth.signUp(_authData["email"]!, _authData["password"]!);
      }
    } on HttpException catch (error) {
      var errorMessage = "Authentication failed";
      if (error.message.contains("EMAIL_EXISTS")) {
        errorMessage = "This email address is already in use.";
      } else if (error.message.contains("INVALID_EMAIL")) {
        errorMessage = "This is not a valid email address";
      } else if (error.message.contains("WEAK_PASSWORD")) {
        errorMessage = "This password is too weak";
      } else if (error.message.contains("EMAIL_NOT_FOUND")) {
        errorMessage =
            "Could not find a user with the email: ${_authData['email']}";
      } else if (error.message.contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid password";
      }
      _showErrorDialog(errorMessage);
    } catch (err) {
      var errorMessage = "Could not authenticate. Please try again later.";
      _showErrorDialog(errorMessage);
    }

    setState(() => _isLoading = false);
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() => _authMode = AuthMode.Signup);
    } else {
      setState(() => _authMode = AuthMode.Login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ColoredTextField(
                  primaryColor: Theme.of(context).primaryColor,
                  focusNode: _emailFocusNode,
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null &&
                        (value.isEmpty || !value.contains('@'))) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value ?? "";
                  },
                ),
                ColoredTextField(
                  primaryColor: Theme.of(context).primaryColor,
                  focusNode: _passwordFocusNode,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value != null && (value.isEmpty || value.length < 5)) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value ?? "";
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  ColoredTextField(
                    primaryColor: Theme.of(context).primaryColor,
                    focusNode: _passwordConfirmationFocusNode,
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(
                      _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                    ),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                TextButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    primary: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
