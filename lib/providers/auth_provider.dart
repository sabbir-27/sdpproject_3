import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _username;
  String? _email; // Added email field
  String? _role;

  bool get isAuthenticated => _token != null;

  String? get token => _token;
  String? get userId => _userId;
  String? get username => _username;
  String? get email => _email; // Added email getter
  String? get role => _role;

  void login(String token, Map<String, dynamic> userData) {
    _token = token;
    _userId = userData['id'];
    _username = userData['username'];
    _email = userData['email']; // Store email
    _role = userData['role'];
    notifyListeners();
  }

  void logout() {
    _token = null;
    _userId = null;
    _username = null;
    _email = null;
    _role = null;
    notifyListeners();
  }
}
