import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PoliceDrawer extends StatelessWidget {
  const PoliceDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("Sabbir Ahmed", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            accountEmail: Text("sabbir.ahmed@police.gov.bd", style: TextStyle(color: Colors.white70)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("S", style: TextStyle(fontSize: 40.0, color: AppColors.primary)),
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
          ),
          _buildDrawerItem(context, icon: Icons.dashboard_outlined, text: 'Dashboard', route: '/police_dashboard'),
          _buildDrawerItem(context, icon: Icons.map_outlined, text: 'Map View', route: '/police_map'),
          _buildDrawerItem(context, icon: Icons.receipt_long_outlined, text: 'Reports', route: '/police_report'),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Management', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          _buildDrawerItem(context, icon: Icons.group_outlined, text: 'User Management', route: '/police_users'),
          _buildDrawerItem(context, icon: Icons.store_outlined, text: 'Shop Management', route: '/police_shops'),
          _buildDrawerItem(context, icon: Icons.flag_outlined, text: 'All Complaints', route: '/police_complaints'),
          _buildDrawerItem(context, icon: Icons.monitor_heart_outlined, text: 'System Health', route: '/police_system_health'),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String text, required String route}) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : Colors.black),
      title: Text(text, style: TextStyle(
        color: isSelected ? AppColors.primary : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      )),
      tileColor: isSelected ? AppColors.primary.withOpacity(0.1) : null,
      onTap: () {
        Navigator.pop(context);
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
