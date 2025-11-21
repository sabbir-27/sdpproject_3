import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';

enum UserRole { customer, shopOwner, admin }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  UserRole _selectedRole = UserRole.customer;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _adminCodeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final role = _selectedRole.toString().split('.').last;
    final shopName = _selectedRole == UserRole.shopOwner ? _shopNameController.text : null;
    final adminCode = _selectedRole == UserRole.admin ? _adminCodeController.text : null;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorDialog('Username, email, and password are required.');
      return;
    }
    
    if (_selectedRole == UserRole.shopOwner && (shopName == null || shopName.isEmpty)) {
      _showErrorDialog('Shop Name is required for shop owners.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await Provider.of<AuthProvider>(context, listen: false).register(
        username,
        email,
        password,
        role,
        shopName: shopName,
        adminCode: adminCode,
      );

      if (success) {
        if (!mounted) return;
        _showSuccessDialog();
      } else {
        _showErrorDialog('Registration failed. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please try again later.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registration Successful'),
        content: const Text('You can now log in with your new account.'),
        actions: <Widget>[
          TextButton(child: const Text('Okay'), onPressed: () {
            Navigator.of(ctx).pop(); // Close the dialog
            Navigator.of(context).pop(); // Go back to login screen
          }),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registration Failed'),
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
    _emailController.dispose();
    _passwordController.dispose();
    _shopNameController.dispose();
    _adminCodeController.dispose();
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: GlassmorphicContainer(
                width: 350,
                height: _selectedRole == UserRole.customer ? 600 : 700,
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
                      Text('Create Account', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 32),
                      DropdownButtonFormField<UserRole>(
                        value: _selectedRole,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Register as'),
                        items: const [
                          DropdownMenuItem(value: UserRole.customer, child: Text('Customer')),
                          DropdownMenuItem(value: UserRole.shopOwner, child: Text('Shop Owner')),
                          DropdownMenuItem(value: UserRole.admin, child: Text('Admin')), 
                        ],
                        onChanged: (UserRole? newValue) => setState(() => _selectedRole = newValue!),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedRole == UserRole.shopOwner)
                        TextField(controller: _shopNameController, decoration: const InputDecoration(labelText: 'Shop Name', prefixIcon: Icon(Icons.storefront_outlined), border: OutlineInputBorder())),
                      if (_selectedRole == UserRole.admin)
                        TextField(controller: _adminCodeController, decoration: const InputDecoration(labelText: 'Admin Code', prefixIcon: Icon(Icons.security_outlined), border: OutlineInputBorder())),
                      if (_selectedRole != UserRole.customer) const SizedBox(height: 16),
                      TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder())),
                      const SizedBox(height: 16),
                      TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder())),
                      const SizedBox(height: 16),
                      TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline), border: OutlineInputBorder())),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                          onPressed: _isLoading ? null : _register,
                          child: _isLoading 
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                              : const Text('Register', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(child: const Text('Login'), onPressed: () => Navigator.pop(context)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
