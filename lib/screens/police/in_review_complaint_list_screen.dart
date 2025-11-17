import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/complaint.dart';
import '../../providers/complaint_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';

class InReviewComplaintListScreen extends StatelessWidget {
  const InReviewComplaintListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final List<Complaint> inReviewComplaints = complaintProvider.complaints
        .where((c) => c.status == ComplaintStatus.InReview)
        .toList();

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
        child: inReviewComplaints.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No complaints in review.',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                itemCount: inReviewComplaints.length,
                itemBuilder: (context, index) {
                  final complaint = inReviewComplaints[index];
                  return ComplaintTile(
                    title: complaint.description,
                    date: DateFormat('d MMM yyyy').format(complaint.date),
                    status: complaint.status,
                    hasVideo: complaint.attachments['Video'] != null,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                      .slideY(begin: 0.2);
                },
              ),
      ),
    );
  }
}
