// lib/widgets/dark_sidebar.dart
import 'package:flutter/material.dart';

class DarkSidebar extends StatelessWidget {
  final String currentRoute;

  const DarkSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF1A1D21),
      child: Column(
        children: [
          const SizedBox(
            height: 80,
            child: Center(
              child: Text('ProfitPulse', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          _buildNavItem(context, 'Dashboard', Icons.dashboard_outlined, '/owner_dashboard'),
          _buildNavItem(context, 'Orders', Icons.shopping_bag_outlined, '/orders'),
          _buildNavItem(context, 'Products', Icons.inventory_2_outlined, '/products'),
          _buildNavItem(context, 'Customers', Icons.people_outline, '/customers'), // Placeholder
          const Spacer(),
          const Divider(color: Colors.white24, indent: 16, endIndent: 16),
          _buildNavItem(context, 'Logout', Icons.logout, '/login', isLogout: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, String route, {bool isLogout = false}) {
    final isSelected = currentRoute == route;
    return Material(
      color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isLogout) {
            Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
          } else if (!isSelected) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.grey[400]),
              const SizedBox(width: 16),
              Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : Colors.grey[400])),
            ],
          ),
        ),
      ),
    );
  }
}
