import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/complaint.dart';
import '../../providers/complaint_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';

class AssignedComplaintListScreen extends StatelessWidget {
  const AssignedComplaintListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final List<Complaint> assignedComplaints = complaintProvider.complaints
        .where((c) => c.status == ComplaintStatus.Assigned)
        .toList();

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
        child: assignedComplaints.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No complaints assigned.',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                itemCount: assignedComplaints.length,
                itemBuilder: (context, index) {
                  final complaint = assignedComplaints[index];
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
