import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';

class InReviewComplaintListScreen extends StatelessWidget {
  const InReviewComplaintListScreen({super.key});

  // Dummy data for in-review complaints
  final List<ComplaintTile> inReviewComplaints = const [
    ComplaintTile(title: 'Loud Noise Complaint', date: '2024-07-27', status: ComplaintStatus.InReview, hasVideo: false),
    ComplaintTile(title: 'Product Quality Issue', date: '2024-07-25', status: ComplaintStatus.InReview, hasVideo: true),
    ComplaintTile(title: 'Misleading Advertisement', date: '2024-07-24', status: ComplaintStatus.InReview, hasVideo: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In Review Complaints'),
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
          itemCount: inReviewComplaints.length,
          itemBuilder: (context, index) {
            return inReviewComplaints[index]
                .animate()
                .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                .slideY(begin: 0.2);
          },
        ),
      ),
    );
  }
}
