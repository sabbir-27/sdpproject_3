import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/accounting_store.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  String _fmt(double v) => NumberFormat.currency(symbol: '৳').format(v);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountingStore>(context);
    final today = DateTime.now();
    final startOfMonth = DateTime(today.year, today.month, 1);
    final sales = store.totalSales(from: startOfMonth, to: today);
    final expenses = store.totalExpenses(from: startOfMonth, to: today);
    final purchases = store.totalPurchases(from: startOfMonth, to: today);
    final net = store.netProfit(from: startOfMonth, to: today);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(child: ListTile(title: const Text('This Month: Total Sales'), trailing: Text(_fmt(sales)))),
          const SizedBox(height: 8),
          Card(child: ListTile(title: const Text('This Month: Total Expenses'), trailing: Text(_fmt(expenses)))),
          const SizedBox(height: 8),
          Card(child: ListTile(title: const Text('This Month: Purchases'), trailing: Text(_fmt(purchases)))),
          const SizedBox(height: 8),
          Card(
            color: net >= 0 ? Colors.green[50] : Colors.red[50],
            child: ListTile(title: const Text('This Month: Net Profit'), trailing: Text(_fmt(net))),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // In a real app, implement PDF/Excel export here.
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export not implemented in demo')));
            },
            icon: const Icon(Icons.download),
            label: const Text('Download Report'),
          )
        ],
      ),
    );
  }
}
