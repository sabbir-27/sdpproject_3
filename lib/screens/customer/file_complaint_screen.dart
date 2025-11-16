// lib/screens/customer/file_complaint_screen.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class FileComplaintScreen extends StatefulWidget {
  const FileComplaintScreen({super.key});

  @override
  State<FileComplaintScreen> createState() => _FileComplaintScreenState();
}

class _FileComplaintScreenState extends State<FileComplaintScreen> {
  bool _sendToPolice = false;
  bool _videoAttached = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File a Complaint', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.gradientStart.withOpacity(0.8),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Please provide details about your issue. Your complaint will be reviewed by the shop owner and may be escalated if unresolved.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(hintText: 'Describe your complaint here...', border: OutlineInputBorder(), fillColor: Colors.white54, filled: true),
            ),
            const SizedBox(height: 16),
            // Attach video button
            OutlinedButton.icon(
              icon: Icon(_videoAttached ? Icons.check_circle : Icons.video_call_outlined, color: _videoAttached ? Colors.green : null),
              label: Text(_videoAttached ? 'Video Attached' : 'Attach Video'),
              onPressed: () {
                setState(() => _videoAttached = true);
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video attached (simulated).')));
              },
            ),
            const SizedBox(height: 16),
            // Send to police checkbox
            CheckboxListTile(
              title: const Text('Send copy directly to Police'),
              subtitle: const Text('Use for serious issues only'),
              value: _sendToPolice,
              onChanged: (bool? value) {
                setState(() {
                  _sendToPolice = value!;
                });
              },
              activeColor: AppColors.accentPolice,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: AppColors.accentPolice, foregroundColor: Colors.white),
                child: const Text('Submit Complaint', style: TextStyle(fontSize: 18)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complaint submitted successfully!')));
                  Navigator.pushNamedAndRemoveUntil(context, '/complaint', (route) => route.isFirst);
                },
              ),
            ),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
