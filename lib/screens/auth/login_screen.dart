import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';

enum UserRole { customer, shopOwner, admin }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.customer;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final role = _selectedRole.toString().split('.').last;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('All fields are required.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await Provider.of<AuthProvider>(context, listen: false)
          .login(username, password, role);

      if (success) {
        if (!mounted) return;
        final userRole = Provider.of<AuthProvider>(context, listen: false).role;
        _navigateToDashboard(userRole ?? role);
      } else {
        _showErrorDialog('Login failed. Please check your credentials.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        _showErrorDialog('Invalid user role received.');
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
                  DropdownButtonFormField<UserRole>(
                    value: _selectedRole,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Login as'),
                    items: const [
                      DropdownMenuItem(value: UserRole.customer, child: Text('Customer')),
                      DropdownMenuItem(value: UserRole.shopOwner, child: Text('Shop Owner')),
                      DropdownMenuItem(value: UserRole.admin, child: Text('Admin')),
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
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Login', style: TextStyle(fontSize: 18)),
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
