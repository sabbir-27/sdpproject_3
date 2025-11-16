import 'package:flutter/foundation.dart';

class Message {
  final String text;
  final String senderId;
  final DateTime timestamp;

  const Message({
    required this.text,
    required this.senderId,
    required this.timestamp,
  });
}
