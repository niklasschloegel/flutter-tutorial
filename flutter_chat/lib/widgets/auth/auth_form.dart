import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    File? imageFile,
    BuildContext ctx,
  ) onSubmit;
  final bool isLoading;
  const AuthForm({Key? key, required this.onSubmit, required this.isLoading})
      : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLoginMode = true;
  var _userEmail = "";
  var _userName = "";
  var _userPw = "";
  File? _userImageFile;

  void _pickedImage(File image) => this._userImageFile = image;

  void _trySubmit() {
    final currState = _formKey.currentState;
    if (currState == null) return;

    if (_userImageFile == null) {}

    final isValid = currState.validate();
    if (isValid) {
      FocusScope.of(context).unfocus();
      currState.save();
      widget.onSubmit(
        _userEmail.trim(),
        _userPw.trim(),
        _userName.trim(),
        _isLoginMode,
        _userImageFile,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLoginMode)
                    UserImagePicker(
                      onImagePicked: _pickedImage,
                    ),
                  TextFormField(
                    key: ValueKey("email"),
                    validator: (val) {
                      if (val == null || val.isEmpty || !val.contains("@"))
                        return "Please enter a valid email address";
                    },
                    onSaved: (val) => _userEmail = val ?? "",
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      labelText: "Email address",
                    ),
                  ),
                  if (!_isLoginMode)
                    TextFormField(
                      key: ValueKey("username"),
                      validator: (val) {
                        if (val == null || val.isEmpty || val.length < 4)
                          return "Please enter at least 4 characters";
                      },
                      onSaved: (val) => _userName = val ?? "",
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                    ),
                  TextFormField(
                    key: ValueKey("password"),
                    validator: (val) {
                      if (val == null || val.isEmpty || val.length < 7)
                        return "Password must be at least 7 characters long";
                    },
                    onSaved: (val) => _userPw = val ?? "",
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLoginMode ? "Login" : "Signup"),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () => setState(
                        () => _isLoginMode = !_isLoginMode,
                      ),
                      child: Text(_isLoginMode
                          ? "Create new account"
                          : "I already have an account"),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
