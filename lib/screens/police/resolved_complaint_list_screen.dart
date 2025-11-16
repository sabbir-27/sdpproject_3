import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';

class ResolvedComplaintListScreen extends StatelessWidget {
  const ResolvedComplaintListScreen({super.key});

  // Dummy data for resolved complaints
  final List<ComplaintTile> resolvedComplaints = const [
    ComplaintTile(title: 'Resolved: Vandalism', date: '2024-07-25', status: ComplaintStatus.Resolved, hasVideo: false),
    ComplaintTile(title: 'Resolved: Overpricing Issue', date: '2024-07-20', status: ComplaintStatus.Resolved, hasVideo: true),
    ComplaintTile(title: 'Resolved: Faulty Equipment', date: '2024-07-18', status: ComplaintStatus.Resolved, hasVideo: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resolved Complaints'),
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
          itemCount: resolvedComplaints.length,
          itemBuilder: (context, index) {
            return resolvedComplaints[index]
                .animate()
                .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                .slideY(begin: 0.2);
          },
        ),
      ),
    );
  }
}
