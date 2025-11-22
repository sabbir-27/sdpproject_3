import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/complaint.dart';
import '../../providers/complaint_provider.dart';
import '../../widgets/complaint_tile.dart';
import '../../widgets/shop_owner_drawer.dart';
import 'package:intl/intl.dart';

class OwnerComplaintsScreen extends StatelessWidget {
  const OwnerComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the complaints from the provider
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final List<Complaint> complaints = complaintProvider.complaints;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Complaints'),
      ),
      drawer: const ShopOwnerDrawer(),
      body: ListView.builder(
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          final complaint = complaints[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ComplaintTile(
              // Use description for the title, as the model doesn't have a separate title
              title: complaint.description,
              // Format the DateTime to a more readable string
              date: DateFormat('yyyy-MM-dd').format(complaint.date),
              status: complaint.status,
              hasVideo: complaint.attachments['Video'] != null,
              hasAudio: complaint.attachments['Audio'] != null,
              hasImage: complaint.attachments['Image'] != null,
            ),
          );
        },
      ),
    );
  }
}
