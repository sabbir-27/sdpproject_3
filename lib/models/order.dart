// lib/models/order.dart

import 'package:flutter/material.dart';

enum OrderStatus { Paid, Delivered, Completed, Cancelled }

class Order {
  final String orderNumber;
  final String customerName;
  final String customerAvatarUrl;
  final OrderStatus status;
  final double total;
  final String date;

  const Order({
    required this.orderNumber,
    required this.customerName,
    required this.customerAvatarUrl,
    required this.status,
    required this.total,
    required this.date,
  });
}
