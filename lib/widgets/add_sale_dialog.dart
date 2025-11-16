import 'package:flutter/material.dart';
import '../models/sale.dart';

class AddSaleDialog extends StatefulWidget {
  const AddSaleDialog({super.key});

  @override
  State<AddSaleDialog> createState() => _AddSaleDialogState();
}

class _AddSaleDialogState extends State<AddSaleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _customerController = TextEditingController();
  final _amountController = TextEditingController();
  String _paymentMethod = 'Cash';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Sale'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _customerController,
              decoration: const InputDecoration(labelText: 'Customer'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration: const InputDecoration(labelText: 'Payment Method'),
              items: ['Cash', 'Card', 'bKash'].map((pm) {
                return DropdownMenuItem(value: pm, child: Text(pm));
              }).toList(),
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final sale = Sale(
                id: DateTime.now().toIso8601String(),
                customer: _customerController.text,
                amount: double.parse(_amountController.text),
                date: DateTime.now(),
                paymentMethod: _paymentMethod,
              );
              Navigator.of(context).pop(sale);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
