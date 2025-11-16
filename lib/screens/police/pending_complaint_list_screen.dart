import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';

class PendingComplaintListScreen extends StatelessWidget {
  const PendingComplaintListScreen({super.key});

  // Dummy data for pending complaints
  final List<ComplaintTile> pendingComplaints = const [
    ComplaintTile(title: 'Illegal Parking Violation', date: '2024-07-28', status: ComplaintStatus.Pending, hasVideo: true),
    ComplaintTile(title: 'Loud Noise Complaint', date: '2024-07-27', status: ComplaintStatus.Pending, hasVideo: false),
    ComplaintTile(title: 'Public Disturbance', date: '2024-07-26', status: ComplaintStatus.Pending, hasVideo: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Complaints'),
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
          itemCount: pendingComplaints.length,
          itemBuilder: (context, index) {
            return pendingComplaints[index]
                .animate()
                .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                .slideY(begin: 0.2);
          },
        ),
      ),
    );
  }
}
