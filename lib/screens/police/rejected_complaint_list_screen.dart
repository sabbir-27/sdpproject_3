import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';

class RejectedComplaintListScreen extends StatelessWidget {
  const RejectedComplaintListScreen({super.key});

  // Dummy data for rejected complaints
  final List<ComplaintTile> rejectedComplaints = const [
    ComplaintTile(title: 'Rejected: False Report', date: '2024-07-24', status: ComplaintStatus.Rejected, hasVideo: false),
    ComplaintTile(title: 'Rejected: Spam', date: '2024-07-20', status: ComplaintStatus.Rejected, hasVideo: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejected Complaints'),
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
          itemCount: rejectedComplaints.length,
          itemBuilder: (context, index) {
            return rejectedComplaints[index]
                .animate()
                .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                .slideY(begin: 0.2);
          },
        ),
      ),
    );
  }
}
