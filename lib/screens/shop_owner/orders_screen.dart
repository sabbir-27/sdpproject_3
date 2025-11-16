// lib/screens/shop_owner/orders_screen.dart
import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shop_owner_drawer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  // Dummy Data
  final List<Order> orders = const [
    Order(orderNumber: '#390561', customerName: 'Michelle Black', customerAvatarUrl: 'https://picsum.photos/seed/user1/40', status: OrderStatus.Paid, total: 780.00, date: 'Jan 8'),
    Order(orderNumber: '#663334', customerName: 'Janice Chandler', customerAvatarUrl: 'https://picsum.photos/seed/user2/40', status: OrderStatus.Delivered, total: 1250.50, date: 'Jan 6'),
    Order(orderNumber: '#418135', customerName: 'Mildred Hall', customerAvatarUrl: 'https://picsum.photos/seed/user3/40', status: OrderStatus.Paid, total: 540.95, date: 'Jan 5'),
    Order(orderNumber: '#602992', customerName: 'James Miller', customerAvatarUrl: 'https://picsum.photos/seed/user4/40', status: OrderStatus.Paid, total: 1620.00, date: 'Dec 26'),
     Order(orderNumber: '#045321', customerName: 'Gary Gilbert', customerAvatarUrl: 'https://picsum.photos/seed/user5/40', status: OrderStatus.Completed, total: 287.00, date: 'Dec 18'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.gradientStart.withOpacity(0.8),
      ),
      drawer: const ShopOwnerDrawer(),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.gradientStart, AppColors.gradientEnd]),
          ),
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderTile(order: order);
            },
          )),
    );
  }
}

// Helper widget for displaying a single order
class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({super.key, required this.order});

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.Paid:
        return Colors.amber.shade700;
      case OrderStatus.Delivered:
        return Colors.blue.shade700;
      case OrderStatus.Completed:
        return Colors.green.shade700;
      case OrderStatus.Cancelled:
        return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Order Number
            Expanded(flex: 2, child: Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold))),
            // Customer
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(radius: 15, backgroundImage: NetworkImage(order.customerAvatarUrl)),
                  const SizedBox(width: 8),
                  Text(order.customerName),
                ],
              ),
            ),
            // Status
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: Chip(
                  label: Text(order.status.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: _getStatusColor(order.status),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            // Total
            Expanded(flex: 2, child: Text('\$${order.total.toStringAsFixed(2)}', textAlign: TextAlign.center)),
            // Date
            Expanded(flex: 1, child: Text(order.date, textAlign: TextAlign.right)),
          ],
        ),
      ),
    );
  }
}
