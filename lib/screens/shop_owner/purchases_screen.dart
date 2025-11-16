import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/accounting_store.dart';

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountingStore>(context);

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: store.purchases.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (c, i) {
        final p = store.purchases.reversed.toList()[i];
        return ListTile(
          leading: const Icon(Icons.store),
          title: Text(p.supplier),
          subtitle: Text(DateFormat.yMMMd().format(p.date)),
          trailing: Text(NumberFormat.currency(symbol: '৳').format(p.amount)),
        );
      },
    );
  }
}
