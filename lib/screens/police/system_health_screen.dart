import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/police_drawer.dart';

class SystemHealthScreen extends StatelessWidget {
  const SystemHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live System Health'),
        backgroundColor: AppColors.primary,
      ),
      drawer: const PoliceDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildHealthCard(title: 'Server Status', status: 'Online', color: AppColors.success, icon: Icons.cloud_queue),
            _buildHealthCard(title: 'Database', status: 'Connected', color: AppColors.success, icon: Icons.storage),
            _buildHealthCard(title: 'API Response Time', status: '85 ms', color: AppColors.success, icon: Icons.timer),
            _buildHealthCard(title: 'Error Logs', status: '3 new', color: AppColors.warning, icon: Icons.error_outline),
          ].animate(interval: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.5),
        ),
      ),
    );
  }

  Widget _buildHealthCard({required String title, required String status, required Color color, required IconData icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(status, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
