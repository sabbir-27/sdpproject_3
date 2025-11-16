import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';

// Dummy model for a notification
class NotificationItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final DateTime timestamp;

  const NotificationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.timestamp,
  });
}

class PoliceNotificationsScreen extends StatelessWidget {
  const PoliceNotificationsScreen({super.key});

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data for notifications
    final List<NotificationItem> notifications = [
      NotificationItem(
        title: 'New High-Priority Complaint',
        subtitle: 'Complaint #C-12345 filed for \'Illegal Parking\'.',
        icon: Icons.report_problem,
        iconColor: AppColors.error,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      NotificationItem(
        title: 'Shop Verification Request',
        subtitle: '\'The Gadget Hub\' requires verification.',
        icon: Icons.store,
        iconColor: AppColors.warning,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NotificationItem(
        title: 'System Alert: High CPU Usage',
        subtitle: 'Server CPU usage has exceeded 90%.',
        icon: Icons.developer_board,
        iconColor: AppColors.error,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      NotificationItem(
        title: 'Complaint Assigned',
        subtitle: 'Complaint #C-12344 has been assigned to Officer Smith.',
        icon: Icons.assignment_turned_in,
        iconColor: AppColors.success,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: notifications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: notification.iconColor.withOpacity(0.1),
                  child: Icon(notification.icon, color: notification.iconColor),
                ),
                title: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(notification.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: Text(
                  _formatTimestamp(notification.timestamp),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: -0.2);
          },
        ),
      ),
    );
  }
}
