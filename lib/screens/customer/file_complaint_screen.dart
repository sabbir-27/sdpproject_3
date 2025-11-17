import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../models/complaint.dart';
import '../../providers/complaint_provider.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class FileComplaintScreen extends StatefulWidget {
  const FileComplaintScreen({super.key});

  @override
  State<FileComplaintScreen> createState() => _FileComplaintScreenState();
}

class _FileComplaintScreenState extends State<FileComplaintScreen> {
  final _descriptionController = TextEditingController();
  bool _sendToPolice = false;
  
  final Map<String, String?> _attachments = {
    'Picture': null,
    'Audio': null,
    'Video': null,
  };

  Future<void> _pickFile(String type) async {
    FileType fileType;
    switch (type) {
      case 'Picture':
        fileType = FileType.image;
        break;
      case 'Audio':
        fileType = FileType.audio;
        break;
      case 'Video':
        fileType = FileType.video;
        break;
      default:
        fileType = FileType.any;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: fileType);

      if (result != null) {
        setState(() {
          _attachments[type] = result.files.single.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$type attached: ${result.files.single.name}'),
          backgroundColor: AppColors.success,
        ));
      } 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error picking file: $e'),
        backgroundColor: AppColors.error,
      ));
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('File a Complaint', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            children: [
              Text(
                'We are sorry to hear you had an issue. Please provide the details below.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText,
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 32),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Describe your complaint here...',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ).animate().slideY(begin: 0.5, duration: 600.ms, curve: Curves.easeOutCubic),

              const SizedBox(height: 24),

              Text('Add Attachments', style: AppTextStyles.heading2)
                  .animate()
                  .fadeIn(delay: 400.ms),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AttachmentButton(
                    icon: Icons.add_a_photo_outlined,
                    label: 'Picture',
                    isSelected: _attachments['Picture'] != null,
                    onTap: () => _pickFile('Picture'),
                  ),
                  _AttachmentButton(
                    icon: Icons.mic_none_outlined,
                    label: 'Audio',
                    isSelected: _attachments['Audio'] != null,
                    onTap: () => _pickFile('Audio'),
                  ),
                  _AttachmentButton(
                    icon: Icons.videocam_outlined,
                    label: 'Video',
                    isSelected: _attachments['Video'] != null,
                    onTap: () => _pickFile('Video'),
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5),

              const SizedBox(height: 32),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _sendToPolice ? AppColors.error.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                ),
                child: CheckboxListTile(
                  title: const Text('Escalate to Police', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Use for serious issues like theft or fraud.'),
                  value: _sendToPolice,
                  onChanged: (bool? value) {
                    setState(() {
                      _sendToPolice = value ?? false;
                    });
                  },
                  activeColor: AppColors.error,
                  secondary: const Icon(Icons.local_police_outlined),
                ),
              ).animate().fadeIn(delay: 800.ms),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Submit Complaint', style: AppTextStyles.button),
                  onPressed: () {
                    if (_descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a description.'), backgroundColor: AppColors.error),
                      );
                      return;
                    }
                    
                    final complaint = Complaint(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      description: _descriptionController.text,
                      date: DateTime.now(),
                      attachments: _attachments,
                      escalatedToPolice: _sendToPolice,
                    );
                    Provider.of<ComplaintProvider>(context, listen: false).addComplaint(complaint);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Complaint submitted successfully!')),
                    );
                    Navigator.pop(context);
                  },
                ),
              ).animate().scale(delay: 1000.ms),
            ],
          ),
        ),
      ),
    );
  }
}


class _AttachmentButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AttachmentButton({
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.textGrey,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
