// lib/widgets/customer_drawer.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text("John Doe", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              accountEmail: Text("john.doe@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("J", style: TextStyle(fontSize: 40.0, color: AppColors.primary)),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacementNamed(context, '/customer_home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_comment_outlined),
              title: const Text('File a Complaint'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/file_complaint');
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_problem_outlined),
              title: const Text('My Complaints'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/complaint');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.accentPolice),
              title: const Text('Logout'),
              onTap: () {
                // Pop all routes until we get to the first one (/login)
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
