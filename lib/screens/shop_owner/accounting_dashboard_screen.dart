import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/accounting_store.dart';

class AccountingDashboardScreen extends StatelessWidget {
  const AccountingDashboardScreen({super.key});

  String _fmt(double v) => NumberFormat.currency(symbol: '৳').format(v);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountingStore>(context);
    final today = DateTime.now();
    final startOfMonth = DateTime(today.year, today.month, 1);

    final totalToday = store.totalSales(from: DateTime(today.year, today.month, today.day), to: DateTime(today.year, today.month, today.day, 23, 59, 59));
    final totalMonth = store.totalSales(from: startOfMonth, to: today);
    final expensesMonth = store.totalExpenses(from: startOfMonth, to: today);
    final net = store.netProfit(from: startOfMonth, to: today);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: ListTile(
              title: const Text('Total Sales (Today)'),
              trailing: Text(_fmt(totalToday)),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Total Sales (This Month)'),
              trailing: Text(_fmt(totalMonth)),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Total Expenses (This Month)'),
              trailing: Text(_fmt(expensesMonth)),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: net >= 0 ? Colors.green[50] : Colors.red[50],
            child: ListTile(
              title: const Text('Net Profit (This Month)'),
              trailing: Text(_fmt(net)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Recent Sales', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: store.sales.length,
              itemBuilder: (c, i) {
                final s = store.sales.reversed.toList()[i];
                return ListTile(
                  title: Text('${s.customer} — ${NumberFormat.currency(symbol: '৳').format(s.amount)}'),
                  subtitle: Text(DateFormat.yMMMd().add_jm().format(s.date)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
