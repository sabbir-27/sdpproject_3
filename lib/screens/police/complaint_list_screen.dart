import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/complaint_provider.dart';
import '../../models/complaint.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';
import '../../widgets/police_drawer.dart';

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
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: const PoliceDrawer(),
      appBar: AppBar(
        title: const Text('Complaint Management', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSummaryHeader(allComplaints),
          const SizedBox(height: 16),
          _buildFilterChips(),
          Expanded(
            child: filteredComplaints.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: filteredComplaints.length,
                    itemBuilder: (context, index) {
                      final complaint = filteredComplaints[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ComplaintTile(
                          title: complaint.description,
                          date: complaint.date.toString().split(' ')[0], // Simplified date
                          status: complaint.status,
                          hasVideo: complaint.attachments['Video'] != null,
                          hasAudio: complaint.attachments['Audio'] != null,
                          hasImage: complaint.attachments['Image'] != null,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: (50 * index).ms).slideX(begin: 0.1);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(List<Complaint> complaints) {
    int total = complaints.length;
    // Fix: Use correct enum values (PascalCase)
    // Grouping New, InReview, and Assigned as "Pending" for the summary
    int pending = complaints.where((c) => 
      c.status == ComplaintStatus.New || 
      c.status == ComplaintStatus.InReview || 
      c.status == ComplaintStatus.Assigned
    ).length;
    int resolved = complaints.where((c) => c.status == ComplaintStatus.Resolved).length;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem('Total', total.toString(), Icons.folder_open),
          _buildSummaryItem('Pending', pending.toString(), Icons.pending_actions),
          _buildSummaryItem('Resolved', resolved.toString(), Icons.check_circle_outline),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildFilterChip(null, 'All'),
          ...ComplaintStatus.values.map((status) => _buildFilterChip(status, status.name.toUpperCase())),
        ],
      ),
    );
  }

  Widget _buildFilterChip(ComplaintStatus? status, String label) {
    final isSelected = _selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedStatus = status;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        checkmarkColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.assignment_turned_in_outlined, size: 60, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          Text(
            'No complaints found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing the filter status',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
