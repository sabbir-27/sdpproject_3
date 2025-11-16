import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class PoliceReportScreen extends StatefulWidget {
  const PoliceReportScreen({super.key});

  @override
  State<PoliceReportScreen> createState() => _PoliceReportScreenState();
}

class _PoliceReportScreenState extends State<PoliceReportScreen> {
  bool _videoAttached = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File a Police Report', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.accentPolice.withAlpha(150),
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
              'For serious issues like fraud or theft, please provide a detailed report. This will be sent directly to the relevant authorities.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textDark),
            ),
            const SizedBox(height: 24),
            const TextField(
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Describe the incident in detail here...',
                border: OutlineInputBorder(),
                fillColor: Colors.white70,
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            // Attach video button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: _videoAttached ? Colors.green : AppColors.textDark,
                side: BorderSide(color: _videoAttached ? Colors.green : AppColors.primary, width: 1),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: Icon(_videoAttached ? Icons.check_circle : Icons.video_library_outlined),
              label: Text(_videoAttached ? 'Video Attached' : 'Attach Video Evidence'),
              onPressed: () {
                setState(() => _videoAttached = true);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video evidence attached (simulated).')));
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.accentPolice,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.local_police_outlined),
                label: const Text('Submit Report to Police', style: TextStyle(fontSize: 18)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted directly to authorities.')));
                  Navigator.pop(context);
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
