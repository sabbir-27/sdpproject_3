import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/complaint.dart'; // Import the centralized model
import '../theme/app_colors.dart';

// The ComplaintStatus enum is now imported from the complaint.dart model.

class ComplaintTile extends StatelessWidget {
  final String title;
  final String date;
  final ComplaintStatus status;
  final bool hasVideo;
  final bool hasAudio;
  final bool hasImage;

  const ComplaintTile({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    this.hasVideo = false,
    this.hasAudio = false,
    this.hasImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(status);
    final IconData statusIcon = _getStatusIcon(data: status);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withOpacity(0.5), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            'Reported on: $date',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
        trailing: _buildAttachmentIcons(),
        onTap: () {
          // TODO: Implement complaint detail view navigation
        },
      ),
    );
  }

  // Helper to build the row of attachment icons
  Widget? _buildAttachmentIcons() {
    if (!hasVideo && !hasAudio && !hasImage) {
      return null;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasImage) Icon(Icons.image, color: Colors.grey[600]),
        if (hasAudio) Icon(Icons.mic, color: Colors.grey[600]),
        if (hasVideo) Icon(Icons.videocam, color: Colors.grey[600]),
      ],
    );
  }

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.New:
        return AppColors.primary;
      case ComplaintStatus.InReview:
        return AppColors.warning;
      case ComplaintStatus.Assigned:
        return Colors.blueAccent;
      case ComplaintStatus.Resolved:
        return AppColors.success;
      case ComplaintStatus.Rejected:
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon({required ComplaintStatus data}) {
    switch (data) {
      case ComplaintStatus.New:
        return Icons.new_releases_outlined;
      case ComplaintStatus.InReview:
        return Icons.hourglass_top_outlined;
      case ComplaintStatus.Assigned:
        return Icons.assignment_ind_outlined;
      case ComplaintStatus.Resolved:
        return Icons.check_circle_outline;
      case ComplaintStatus.Rejected:
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }
}
