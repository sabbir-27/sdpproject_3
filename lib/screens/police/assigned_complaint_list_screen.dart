import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';

class AssignedComplaintListScreen extends StatelessWidget {
  const AssignedComplaintListScreen({super.key});

  // Dummy data for assigned complaints
  final List<ComplaintTile> assignedComplaints = const [
    ComplaintTile(title: 'Assigned: Theft Report', date: '2024-07-23', status: ComplaintStatus.Assigned, hasVideo: true),
    ComplaintTile(title: 'Assigned: Vandalism Case', date: '2024-07-22', status: ComplaintStatus.Assigned, hasVideo: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Complaints'),
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
          itemCount: assignedComplaints.length,
          itemBuilder: (context, index) {
            return assignedComplaints[index]
                .animate()
                .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                .slideY(begin: 0.2);
          },
        ),
      ),
    );
  }
}
