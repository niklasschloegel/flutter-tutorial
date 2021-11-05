import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/config.dart';
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expirationDate;
  String? _userId;

  String? get token {
    var expDate = _expirationDate;
    if (_token != null && expDate != null && expDate.isAfter(DateTime.now())) {
      return _token;
    }
  }

  bool get isAuthenticated => token != null;

  Future<void> signUp(String email, String password) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${Config.apiKey}";
    await _authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${Config.apiKey}";
    await _authenticate(email, password, url);
  }

  Future<void> _authenticate(String email, String password, String url) async {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    final body = json.decode(response.body);
    final err = body["error"];
    if (err != null) throw HttpException(err["message"]);
    _token = body["idToken"];
    _userId = body["localId"];
    _expirationDate = DateTime.now().add(
      Duration(
        seconds: int.parse(
          body["expiresIn"],
        ),
      ),
    );
    notifyListeners();
  }
}
