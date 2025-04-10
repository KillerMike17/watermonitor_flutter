import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _authToken;
  String? _userEmail;
  String? _uuid;

  bool get isAuthenticated => _isAuthenticated;
  String? get authToken => _authToken;
  String? get userEmail => _userEmail;
  String? get uuid => _uuid;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
    _userEmail = prefs.getString('user_email');
    _uuid = prefs.getString('uuid');
    _isAuthenticated = _authToken != null;
    notifyListeners();
  }

  Future<void> login(String token, String email, String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print(email + uuid);
    print('1');
    await prefs.setString('user_email', email);
    await prefs.setString('uuid', uuid);

    _authToken = token;
    _userEmail = email;
    _uuid = uuid;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_email');

    _authToken = null;
    _userEmail = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
