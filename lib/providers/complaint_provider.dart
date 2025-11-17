import 'package:flutter/material.dart';
import '../models/complaint.dart';

class ComplaintProvider with ChangeNotifier {
  final List<Complaint> _complaints = [];

  List<Complaint> get complaints => _complaints;

  void addComplaint(Complaint complaint) {
    _complaints.add(complaint);
    notifyListeners();
  }
}
