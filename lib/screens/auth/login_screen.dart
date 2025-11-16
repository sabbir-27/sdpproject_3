import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../theme/app_colors.dart';

enum UserRole { customer, shopOwner, admin } // Added admin role

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  const TextField(decoration: InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder())),
                  const SizedBox(height: 16),
                  const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline), border: OutlineInputBorder())),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      child: const Text('Login', style: TextStyle(fontSize: 18)),
                      onPressed: () {
                        // Navigate based on the selected role
                        switch (_selectedRole) {
                          case UserRole.customer:
                            Navigator.pushNamed(context, '/customer_home');
                            break;
                          case UserRole.shopOwner:
                            Navigator.pushNamed(context, '/owner_dashboard');
                            break;
                          case UserRole.admin:
                            Navigator.pushNamed(context, '/police_dashboard');
                            break;
                        }
                      },
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
