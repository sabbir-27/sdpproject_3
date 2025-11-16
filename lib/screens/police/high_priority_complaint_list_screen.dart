import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';

class HighPriorityComplaintListScreen extends StatelessWidget {
  const HighPriorityComplaintListScreen({super.key});

  // Dummy data for high-priority complaints
  final List<ComplaintTile> highPriorityComplaints = const [
    ComplaintTile(title: 'Illegal Parking Violation', date: '2024-07-28', status: ComplaintStatus.New, hasVideo: true),
    ComplaintTile(title: 'Loud Noise Complaint', date: '2024-07-27', status: ComplaintStatus.InReview, hasVideo: false),
    ComplaintTile(title: 'Public Disturbance', date: '2024-07-26', status: ComplaintStatus.New, hasVideo: true),
    ComplaintTile(title: 'Suspicious Activity Reported', date: '2024-07-25', status: ComplaintStatus.Assigned, hasVideo: true),
    ComplaintTile(title: 'Street Fight', date: '2024-07-24', status: ComplaintStatus.Resolved, hasVideo: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High-Priority Complaints'),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          itemCount: highPriorityComplaints.length,
          itemBuilder: (context, index) {
            return highPriorityComplaints[index]
                .animate()
                .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                .slideY(begin: 0.2);
          },
        ),
      ),
    );
  }
}
