import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // Dummy data for notifications
  final List<Map<String, dynamic>> _notifications = const [
    {
      'icon': Icons.local_shipping,
      'title': 'Order Shipped!',
      'body': 'Your order #12345 for a Wireless Mouse has been shipped and is on its way.',
      'time': '15m ago',
      'isRead': false,
    },
    {
      'icon': Icons.campaign,
      'title': 'Flash Sale Alert!',
      'body': 'Don\'t miss out! Get up to 50% off on all electronics for the next 24 hours.',
      'time': '1h ago',
      'isRead': false,
    },
    {
      'icon': Icons.chat,
      'title': 'New Message from Green Grocers',
      'body': '\"We have restocked the organic avocados you asked about!\"',
      'time': '3h ago',
      'isRead': true,
    },
    {
      'icon': Icons.check_circle,
      'title': 'Order Delivered',
      'body': 'Your order #12344 has been successfully delivered. We hope you enjoy it!',
      'time': 'Yesterday',
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];
            return _buildNotificationCard(notification, index);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: !(notification['isRead'] as bool) ? AppColors.primary.withAlpha(100) : Colors.transparent,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withAlpha(50),
          child: Icon(notification['icon'] as IconData, color: AppColors.primary),
        ),
        title: Text(
          notification['title'] as String,
          style: TextStyle(fontWeight: !(notification['isRead'] as bool) ? FontWeight.bold : FontWeight.normal),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(notification['body'] as String, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        trailing: Text(
          notification['time'] as String,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        onTap: () {
          // TODO: Implement navigation to relevant screen
        },
      ),
    ).animate().fadeIn(delay: (100 * index).ms).moveX(begin: -20, end: 0);
  }
}
