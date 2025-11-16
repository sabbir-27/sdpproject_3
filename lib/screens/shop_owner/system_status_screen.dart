import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shop_owner_drawer.dart';

class SystemStatusScreen extends StatelessWidget {
  const SystemStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for system statuses
    final statuses = [
      {'name': 'Main API', 'status': 'Operational', 'color': Colors.green, 'icon': Icons.check_circle},
      {'name': 'Database', 'status': 'Operational', 'color': Colors.green, 'icon': Icons.storage},
      {'name': 'Payment Gateway', 'status': 'Experiencing Delays', 'color': Colors.orange, 'icon': Icons.warning},
      {'name': 'Image Processing Service', 'status': 'Operational', 'color': Colors.green, 'icon': Icons.image},
      {'name': 'Notification Service', 'status': 'Offline', 'color': Colors.red, 'icon': Icons.error},
      {'name': 'Real-time Analytics', 'status': 'Operational', 'color': Colors.green, 'icon': Icons.bar_chart},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Status'),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: statuses.length,
          itemBuilder: (context, index) {
            final item = statuses[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                leading: Icon(
                  item['icon'] as IconData,
                  color: item['color'] as Color,
                  size: 40,
                ),
                title: Text(
                  item['name'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(
                  item['status'] as String,
                  style: TextStyle(
                    color: item['color'] as Color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  // In a real app, this could navigate to a detailed status page for each service.
                },
              ),
            ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: -0.2);
          },
        ),
      ),
    );
  }
}
