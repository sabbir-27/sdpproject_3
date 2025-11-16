// lib/screens/shop_owner/shop_owner_panel_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/dark_sidebar.dart';
import 'dashboard_screen.dart';
import 'orders_screen.dart';
import 'products_screen.dart';

class ShopOwnerPanelScreen extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const ShopOwnerPanelScreen({super.key, required this.child, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background for the main content
      body: Row(
        children: [
          DarkSidebar(currentRoute: currentRoute),
          Expanded(child: child),
        ],
      ),
    );
  }
}
