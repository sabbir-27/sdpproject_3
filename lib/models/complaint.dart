import 'package:flutter/material.dart';

// Enum for the status of the complaint
enum ComplaintStatus { New, InReview, Assigned, Resolved, Rejected }

class Complaint {
  final String id;
  final String description;
  final DateTime date;
  final ComplaintStatus status;
  final Map<String, String?> attachments;
  final bool escalatedToPolice;

  Complaint({
    required this.id,
    required this.description,
    required this.date,
    this.status = ComplaintStatus.New,
    this.attachments = const {},
    this.escalatedToPolice = false,
  });
}
