import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:http/http.dart' as http;
import 'package:shop/config.dart';
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expirationDate;
  String? _userId;
  Timer? _authTimer;

  String? get token {
    var expDate = _expirationDate;
    if (_token != null &&
        _userId != null &&
        expDate != null &&
        expDate.isAfter(DateTime.now())) {
      return _token;
    }
  }

  String? get userId => _userId;

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

  Future<bool> tryAutoLogin() async {
    _token = await FlutterKeychain.get(key: "token");
    _userId = await FlutterKeychain.get(key: "userId");
    final expDateString = await FlutterKeychain.get(key: "expirationDate");
    if (expDateString != null) _expirationDate = DateTime.parse(expDateString);

    if (isAuthenticated) {
      _autoLogout();
      notifyListeners();
      return true;
    }
    return false;
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
    _autoLogout();
    _saveAuthData();
    notifyListeners();
  }

  Future<void> _saveAuthData() async {
    final tok = _token;
    if (tok != null) FlutterKeychain.put(key: "token", value: tok);

    final uid = _userId;
    if (uid != null) FlutterKeychain.put(key: "userId", value: uid);

    final expDate = _expirationDate;
    if (expDate != null)
      FlutterKeychain.put(
          key: "expirationDate", value: expDate.toIso8601String());
  }

  void logout() {
    _token = null;
    _userId = null;
    _expirationDate = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    FlutterKeychain.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer?.cancel();
    final timeToLogout = _expirationDate?.difference(DateTime.now()).inSeconds;
    if (timeToLogout == null) return;
    Timer(Duration(seconds: timeToLogout), logout);
  }
}
