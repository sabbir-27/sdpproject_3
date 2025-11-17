import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/complaint_provider.dart';
import '../../models/complaint.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';

class ComplaintListScreen extends StatefulWidget {
  const ComplaintListScreen({super.key});

  @override
  State<ComplaintListScreen> createState() => _ComplaintListScreenState();
}

class _ComplaintListScreenState extends State<ComplaintListScreen> {
  ComplaintStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final allComplaints = complaintProvider.complaints;

    final filteredComplaints = _selectedStatus == null
        ? allComplaints
        : allComplaints.where((c) => c.status == _selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Complaints'),
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
        child: Column(
          children: [
            _buildFilterChips(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: filteredComplaints.length,
                itemBuilder: (context, index) {
                  final complaint = filteredComplaints[index];
                  return ComplaintTile(
                    title: complaint.description,
                    date: complaint.date.toString(),
                    status: complaint.status,
                    hasVideo: complaint.attachments['Video'] != null,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                      .slideY(begin: 0.2);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            _buildFilterChip(null, 'All'),
            ...ComplaintStatus.values.map((status) => _buildFilterChip(status, status.name)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(ComplaintStatus? status, String label) {
    final isSelected = _selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedStatus = status;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.primary),
        shape: StadiumBorder(side: BorderSide(color: AppColors.primary.withOpacity(0.5))),
      ),
    );
  }
}
