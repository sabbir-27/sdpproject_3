import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/shop.dart';
import '../../theme/app_colors.dart';

// Dummy Shop Model
class ShopVerification {
  final String id;
  final String name;
  final String ownerName;
  final String status; // "Verified", "Pending", "Suspended"

  const ShopVerification({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.status,
  });
}

class ShopManagementScreen extends StatelessWidget {
  const ShopManagementScreen({super.key});

  final List<ShopVerification> shops = const [
    ShopVerification(id: '1', name: 'Sabbir\'s Electronics', ownerName: 'Sabbir Ahmed', status: 'Verified'),
    ShopVerification(id: '2', name: 'Green Grocers', ownerName: 'Ayesha Khan', status: 'Verified'),
    ShopVerification(id: '3', name: 'Bookworm Corner', ownerName: 'Imran Chowdhury', status: 'Pending'),
    ShopVerification(id: '4', name: 'The Gadget Hub', ownerName: 'Farah Islam', status: 'Suspended'),
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Verified': return AppColors.success;
      case 'Pending': return AppColors.warning;
      case 'Suspended': return AppColors.error;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Management'),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: shops.length,
          itemBuilder: (context, index) {
            final shop = shops[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(shop.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Owner: ${shop.ownerName}'),
                trailing: Chip(
                  label: Text(shop.status, style: const TextStyle(color: Colors.white, fontSize: 10)),
                  backgroundColor: _getStatusColor(shop.status),
                ),
                onTap: () {
                  // TODO: Navigate to a detailed shop view for police
                },
              ),
            ).animate().fadeIn(delay: (100*index).ms).slideX(begin: -0.2);
          },
        ),
      ),
    );
  }
}
