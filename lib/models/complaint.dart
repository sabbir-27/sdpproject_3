
import '../widgets/complaint_tile.dart';

class Complaint {
  final String id;
  final String customerName;
  final String title;
  final String description;
  final ComplaintStatus status;
  final String date;

  const Complaint({
    required this.id,
    required this.customerName,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
  });
}
