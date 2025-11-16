import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shop_owner_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
      ),
      drawer: const ShopOwnerDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            _buildSectionHeader('Profile Settings'),
            _buildProfileCard(),
            const SizedBox(height: 24),
            _buildSectionHeader('Notification Preferences'),
            _buildNotificationsCard(),
            const SizedBox(height: 24),
            _buildSectionHeader('Appearance'),
            _buildAppearanceCard(),
            const SizedBox(height: 32),
            _buildLogoutButton(),
          ].animate(interval: 100.ms).fadeIn(duration: 400.ms).slideX(begin: -0.1),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const ListTile(
        leading: Icon(Icons.person, color: AppColors.primary, size: 32),
        title: Text('Sabbir Ahmed'),
        subtitle: Text('owner@sabbirselectronics.com'),
        trailing: Icon(Icons.edit, color: Colors.grey),
        // onTap: () { /* Navigate to profile edit screen */ },
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
            secondary: const Icon(Icons.notifications_active, color: AppColors.primary),
            activeColor: AppColors.primary,
          ),
          const Divider(height: 0, indent: 16, endIndent: 16),
          SwitchListTile(
            title: const Text('Email Notifications'),
            value: _emailNotifications,
            onChanged: (val) => setState(() => _emailNotifications = val),
            secondary: const Icon(Icons.email, color: AppColors.primary),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: const Text('Dark Mode'),
        value: _darkMode,
        onChanged: (val) {
          setState(() => _darkMode = val);
          // In a real app, you would use a theme provider to change the theme.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Theme switching not implemented yet.')),
          );
        },
        secondary: const Icon(Icons.dark_mode, color: AppColors.primary),
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 16)),
      onPressed: () {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}
