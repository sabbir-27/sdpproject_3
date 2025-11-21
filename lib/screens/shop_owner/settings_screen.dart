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
      backgroundColor: const Color(0xFFF8F9FC), // Premium light grey background
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const ShopOwnerDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        children: <Widget>[
          _buildSectionHeader('ACCOUNT'),
          _buildProfileCard(),
          const SizedBox(height: 24),
          _buildSectionHeader('PREFERENCES'),
          _buildNotificationsCard(),
          const SizedBox(height: 24),
          _buildSectionHeader('APPEARANCE'),
          _buildAppearanceCard(),
          const SizedBox(height: 40),
          _buildLogoutButton(),
        ].animate(interval: 50.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOut),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, color: AppColors.primary, size: 32),
        ),
        title: const Text(
          'Sabbir Ahmed',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        subtitle: const Text(
          'owner@sabbirselectronics.com',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            'Push Notifications',
            _pushNotifications,
            (val) => setState(() => _pushNotifications = val),
            Icons.notifications_none_rounded,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: Colors.grey[100]),
          ),
          _buildSwitchTile(
            'Email Notifications',
            _emailNotifications,
            (val) => setState(() => _emailNotifications = val),
            Icons.email_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: _buildSwitchTile(
        'Dark Mode',
        _darkMode,
        (val) {
          setState(() => _darkMode = val);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Theme switching not implemented yet.')),
          );
        },
        Icons.dark_mode_outlined,
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged, IconData icon) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textDark)),
      value: value,
      onChanged: onChanged,
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      activeColor: AppColors.primary,
      activeTrackColor: AppColors.primary.withOpacity(0.3),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.error.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout_rounded, color: Colors.white),
        label: const Text('Log Out', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}
