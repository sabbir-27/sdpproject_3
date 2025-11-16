import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../theme/app_colors.dart';

enum ComplaintStatus { New, InReview, Resolved, Assigned, Rejected, Pending }

class ComplaintTile extends StatelessWidget {
  final String title;
  final String date;
  final ComplaintStatus status;
  final bool hasVideo; // New property

  const ComplaintTile({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    this.hasVideo = false, // Default to false
  });

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.New:
        return Colors.orange;
      case ComplaintStatus.InReview:
        return Colors.blueAccent;
      case ComplaintStatus.Resolved:
        return Colors.green;
      case ComplaintStatus.Assigned:
        return AppColors.primary;
      case ComplaintStatus.Rejected:
        return AppColors.error;
      case ComplaintStatus.Pending:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(ComplaintStatus status) {
    return status.toString().split('.').last.replaceAll('InReview', 'In Review');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 80,
        borderRadius: 16,
        blur: 15,
        border: 1,
        linearGradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.3)],
        ),
        borderGradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.4), Colors.white.withOpacity(0.4)],
        ),
        child: ListTile(
          leading: hasVideo ? const Icon(Icons.videocam_outlined, color: AppColors.accentPolice) : null,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(date),
          trailing: Chip(
            label: Text(_getStatusText(status)),
            backgroundColor: _getStatusColor(status),
            labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
