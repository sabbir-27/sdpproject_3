// lib/widgets/shop_owner_sidebar.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ShopOwnerSidebar extends StatelessWidget {
  const ShopOwnerSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine current route to highlight selected item
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Branding / Logo
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.store_mall_directory, color: AppColors.primary, size: 32),
              SizedBox(width: 8),
              Text('SmartShop', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 32),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildNavItem(context, 'Dashboard', Icons.dashboard_outlined, '/owner_dashboard', currentRoute),
                _buildNavItem(context, 'Products', Icons.inventory_2_outlined, '/products', currentRoute),
                _buildNavItem(context, 'Orders', Icons.shopping_cart_outlined, '/orders', currentRoute), 
                _buildNavItem(context, 'Chat', Icons.chat_bubble_outline, '/owner_chat_list', currentRoute), 
                const Divider(height: 32),
                _buildSectionTitle('Analytics'),
                _buildNavItem(context, 'Charts', Icons.bar_chart_outlined, '/owner_charts', currentRoute),
                _buildNavItem(context, 'Trends', Icons.trending_up, '/owner_trends', currentRoute),
                const Divider(height: 32),
                _buildSectionTitle('Management'),
                _buildNavItem(context, 'QR Code', Icons.qr_code_2, '/owner_qr_code', currentRoute),
                _buildNavItem(context, 'Complaints', Icons.report_problem_outlined, '/owner_complaints', currentRoute),
                _buildNavItem(context, 'Accounting', Icons.account_balance_wallet_outlined, '/owner_accounting', currentRoute),
                const Divider(height: 32),
                _buildSectionTitle('Settings'),
                _buildNavItem(context, 'Profile', Icons.person_outline, '/profile', currentRoute),
                _buildNavItem(context, 'Settings', Icons.settings_outlined, '/owner_settings', currentRoute),
              ],
            ),
          ),
          
          // Logout
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildNavItem(context, 'Logout', Icons.logout, '/login', currentRoute, isLogout: true),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, String route, String? currentRoute, {bool isLogout = false}) {
    final bool isSelected = currentRoute == route && !isLogout;
    
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (isLogout) {
            Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
          } else {
            if (!isSelected) {
               Navigator.pushReplacementNamed(context, route);
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? AppColors.primary : Colors.grey[600], size: 22),
              const SizedBox(width: 14),
              Text(
                title, 
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, 
                  color: isSelected ? AppColors.primary : AppColors.textDark.withOpacity(0.8)
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
