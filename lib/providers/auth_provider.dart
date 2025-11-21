import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _username;
  String? _email;
  String? _role;

  bool get isAuthenticated => _token != null;

  String? get token => _token;
  String? get userId => _userId;
  String? get username => _username;
  String? get email => _email;
  String? get role => _role;

  // IMPORTANT: Replace with your actual server URL
  final String _baseUrl = 'http://localhost:3000';

  Future<bool> login(String username, String password, String role) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        final userData = data['user'];
        _userId = userData['id'];
        _username = userData['username'];
        _email = userData['email'];
        _role = userData['role'];
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String username, String email, String password, String role, {String? shopName, String? adminCode}) async {
    final url = Uri.parse('$_baseUrl/register');
    try {
      final body = {
        'username': username,
        'email': email,
        'password': password,
        'role': role,
      };
      
      if (shopName != null) body['shopName'] = shopName;
      if (adminCode != null) body['adminCode'] = adminCode;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
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
