import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ShopOwnerDrawer extends StatelessWidget {
  const ShopOwnerDrawer({super.key});

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
            UserAccountsDrawerHeader(
              accountName: const Text("Sabbir's Electronics", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              accountEmail: const Text("owner@sabbirselectronics.com", style: TextStyle(color: Colors.white70)),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text("S", style: TextStyle(fontSize: 40.0, color: AppColors.primary)),
                ),
              ),
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
            ),
            _buildDrawerItem(context, icon: Icons.dashboard_outlined, text: 'Dashboard', route: '/owner_dashboard'),
            _buildDrawerItem(context, icon: Icons.chat_bubble_outline, text: 'Chat', route: '/owner_chat_list'),
            _buildDrawerItem(context, icon: Icons.qr_code_scanner, text: 'My QR Code', route: '/owner_qr_code'),
            const Divider(),
            _buildDrawerItem(context, icon: Icons.insert_chart_outlined, text: 'Charts', route: '/owner_charts'),
            _buildDrawerItem(context, icon: Icons.trending_up_outlined, text: 'Trends', route: '/owner_trends'),
            _buildDrawerItem(context, icon: Icons.report_problem_outlined, text: 'Complaints', route: '/owner_complaints'),
            const Divider(),
            _buildDrawerItem(context, icon: Icons.account_balance_wallet_outlined, text: 'Accounting', route: '/owner_accounting'),
            _buildDrawerItem(context, icon: Icons.settings_outlined, text: 'Settings', route: '/owner_settings'), 
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
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
