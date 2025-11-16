import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../theme/app_colors.dart';
import 'login_screen.dart'; // Import to use UserRole enum

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  UserRole _selectedRole = UserRole.customer;

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
                          DropdownMenuItem(value: UserRole.admin, child: Text('Admin')), // Added Admin option
                        ],
                        onChanged: (UserRole? newValue) => setState(() => _selectedRole = newValue!),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedRole == UserRole.shopOwner)
                        const TextField(decoration: InputDecoration(labelText: 'Shop Name', prefixIcon: Icon(Icons.storefront_outlined), border: OutlineInputBorder())),
                      if (_selectedRole == UserRole.admin)
                        const TextField(decoration: InputDecoration(labelText: 'Admin Code', prefixIcon: Icon(Icons.security_outlined), border: OutlineInputBorder())),
                      if (_selectedRole != UserRole.customer) const SizedBox(height: 16),
                      const TextField(decoration: InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder())),
                      const SizedBox(height: 16),
                      const TextField(decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder())),
                      const SizedBox(height: 16),
                      const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline), border: OutlineInputBorder())),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                          child: const Text('Register', style: TextStyle(fontSize: 18)),
                          onPressed: () => Navigator.pop(context), // Go back to login
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
