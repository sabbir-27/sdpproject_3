import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:http/http.dart' as http;
import '../../theme/app_colors.dart';

enum UserRole { customer, shopOwner, admin } // Added admin role

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.customer;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // API Login Logic
  Future<void> _apiLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final role = _selectedRole.toString().split('.').last; // "customer", "shopOwner", or "admin"

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('All fields are required.');
      return;
    }

    // IMPORTANT: Replace with your actual server URL
    final url = Uri.parse('http://localhost:3000/login');

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

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // On success, navigate to the correct dashboard
        _navigateToDashboard(responseBody['user']['role']);
      } else {
        _showErrorDialog(responseBody['message'] ?? 'An unknown error occurred.');
      }
    } catch (e) {
      _showErrorDialog('Could not connect to the server. Please try again later.');
    }
  }

  void _navigateToDashboard(String role) {
    switch (role) {
      case 'customer':
        Navigator.pushReplacementNamed(context, '/customer_home');
        break;
      case 'shopOwner':
        Navigator.pushReplacementNamed(context, '/owner_dashboard');
        break;
      case 'admin':
        Navigator.pushReplacementNamed(context, '/police_dashboard');
        break;
      default:
        _showErrorDialog('Invalid user role received from server.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: <Widget>[
          TextButton(child: const Text('Okay'), onPressed: () => Navigator.of(ctx).pop()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: Center(
          child: GlassmorphicContainer(
            width: 350,
            height: 600,
            borderRadius: 24,
            blur: 12,
            alignment: Alignment.center,
            border: 2,
            linearGradient: LinearGradient(colors: [Theme.of(context).cardColor.withOpacity(0.2), Theme.of(context).cardColor.withOpacity(0.3)]),
            borderGradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.5), Colors.white.withOpacity(0.5)]),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 32),
                  // Role Selector
                  DropdownButtonFormField<UserRole>(
                    value: _selectedRole,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Login as'),
                    items: const [
                      DropdownMenuItem(value: UserRole.customer, child: Text('Customer')),
                      DropdownMenuItem(value: UserRole.shopOwner, child: Text('Shop Owner')),
                      DropdownMenuItem(value: UserRole.admin, child: Text('Admin')), // Added admin option
                    ],
                    onChanged: (UserRole? newValue) => setState(() => _selectedRole = newValue!),
                  ),
                  const SizedBox(height: 16),
                  TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder())),
                  const SizedBox(height: 16),
                  TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline), border: OutlineInputBorder())),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      child: const Text('Login', style: TextStyle(fontSize: 18)),
                      onPressed: _apiLogin, // Call the API login function
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(child: const Text('Register'), onPressed: () => Navigator.pushNamed(context, '/register')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
