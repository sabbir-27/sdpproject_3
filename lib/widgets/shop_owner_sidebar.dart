// lib/widgets/shop_owner_sidebar.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ShopOwnerSidebar extends StatelessWidget {
  const ShopOwnerSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Fixed width for the sidebar
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 80,
            child: Center(
              child: Text('SmartShop', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ),
          ),
          _buildNavItem(context, 'Dashboard', Icons.dashboard_outlined, '/owner_dashboard', isSelected: true),
          _buildNavItem(context, 'Products', Icons.inventory_2_outlined, '/products'),
          _buildNavItem(context, 'Chat', Icons.chat_bubble_outline, '/owner_chat'),
          const Spacer(),
          const Divider(),
          _buildNavItem(context, 'Logout', Icons.logout, '/login', isLogout: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, String route, {bool isSelected = false, bool isLogout = false}) {
    return Material(
      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isLogout) {
            Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
          } else {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? AppColors.primary : Colors.grey[700]),
              const SizedBox(width: 16),
              Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primary : Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}
