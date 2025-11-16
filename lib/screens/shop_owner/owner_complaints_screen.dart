import 'package:flutter/material.dart';
import '../../models/complaint.dart';
import '../../widgets/complaint_tile.dart';
import '../../widgets/shop_owner_drawer.dart';

class OwnerComplaintsScreen extends StatelessWidget {
  const OwnerComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for complaints
    final List<Complaint> complaints = [
      const Complaint(id: '1', customerName: 'John Doe', title: 'Late Delivery', description: 'The package was 3 days late.', status: ComplaintStatus.InReview, date: '2024-07-28'),
      const Complaint(id: '2', customerName: 'Jane Smith', title: 'Damaged Item', description: 'The product arrived with a cracked screen.', status: ComplaintStatus.Resolved, date: '2024-07-25'),
      const Complaint(id: '3', customerName: 'Peter Jones', title: 'Wrong Product Received', description: 'I received a different color than what I ordered.', status: ComplaintStatus.InReview, date: '2024-07-29'),
    ];

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
              title: complaint.title,
              date: complaint.date,
              status: complaint.status,
            ),
          );
        },
      ),
    );
  }
}
