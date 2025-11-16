import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';
import '../../widgets/customer_drawer.dart'; // Import the new drawer

class ComplaintScreen extends StatelessWidget {
  const ComplaintScreen({super.key});

  // Dummy data for complaints
  final List<Map<String, dynamic>> complaintData = const [
    {
      'title': 'Defective Product Received',
      'date': '2024-07-28',
      'status': ComplaintStatus.Resolved,
    },
    {
      'title': 'Late Delivery',
      'date': '2024-07-27',
      'status': ComplaintStatus.InReview,
    },
    {
      'title': 'Incorrect Item Shipped',
      'date': '2024-07-26',
      'status': ComplaintStatus.New,
    },
    {
      'title': 'Poor Customer Service',
      'date': '2024-07-25',
      'status': ComplaintStatus.Resolved,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Complaints', style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      drawer: const CustomerDrawer(), // Add the drawer here
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // In a real app, this would open a form to file a new complaint.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Navigate to a shop page to file a complaint.')),
          );
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
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
          padding: const EdgeInsets.all(16.0),
          itemCount: complaintData.length,
          itemBuilder: (context, index) {
            final complaint = complaintData[index];
            return ComplaintTile(
              title: complaint['title'],
              date: complaint['date'],
              status: complaint['status'],
            ).animate().fadeIn(duration: 500.ms, delay: (100 * index).ms).slideX(begin: -0.2);
          },
        ),
      ),
    );
  }
}
