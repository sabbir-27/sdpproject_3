import 'package:flutter/material.dart';
import '../models/sale.dart';
import '../models/expense.dart';
import '../models/purchase.dart';

class AccountingStore extends ChangeNotifier {
  final List<Sale> _sales = [
    // Current Month
    Sale(id: '1', customer: 'Walk-in Customer', amount: 150.50, date: DateTime.now().subtract(const Duration(days: 1)), paymentMethod: 'Cash'),
    Sale(id: '2', customer: 'John Doe', amount: 320.00, date: DateTime.now().subtract(const Duration(hours: 5)), paymentMethod: 'Card'),
    // Last Month
    Sale(id: '3', customer: 'Jane Smith', amount: 850.75, date: DateTime.now().subtract(const Duration(days: 32)), paymentMethod: 'bKash'),
    Sale(id: '4', customer: 'Emily Johnson', amount: 1200.00, date: DateTime.now().subtract(const Duration(days: 40)), paymentMethod: 'Card'),
    // 2 Months Ago
    Sale(id: '5', customer: 'Michael Brown', amount: 550.25, date: DateTime.now().subtract(const Duration(days: 65)), paymentMethod: 'Cash'),
    Sale(id: '6', customer: 'Walk-in Customer', amount: 780.00, date: DateTime.now().subtract(const Duration(days: 70)), paymentMethod: 'Card'),
    // 3 Months Ago
    Sale(id: '7', customer: 'Chris Lee', amount: 420.00, date: DateTime.now().subtract(const Duration(days: 95)), paymentMethod: 'Cash'),
    // 4 Months Ago
    Sale(id: '8', customer: 'Walk-in Customer', amount: 2100.50, date: DateTime.now().subtract(const Duration(days: 125)), paymentMethod: 'Card'),
     // 5 Months Ago
    Sale(id: '9', customer: 'Sarah Connor', amount: 1800.00, date: DateTime.now().subtract(const Duration(days: 155)), paymentMethod: 'bKash'),
  ];

  final List<Expense> _expenses = [
    Expense(id: '1', category: 'Office Supplies', amount: 75.00, date: DateTime.now().subtract(const Duration(days: 2)), note: 'Pens and notebooks'),
    Expense(id: '2', category: 'Utilities', amount: 250.00, date: DateTime.now().subtract(const Duration(days: 1)), note: 'Electricity bill'),
  ];

  final List<Purchase> _purchases = [
    Purchase(id: '1', supplier: 'Tech Supplier Inc.', amount: 1200.00, date: DateTime.now().subtract(const Duration(days: 3))),
    Purchase(id: '2', supplier: 'Local Goods Co.', amount: 450.00, date: DateTime.now().subtract(const Duration(days: 1))),
  ];

  List<Sale> get sales => List.unmodifiable(_sales);
  List<Expense> get expenses => List.unmodifiable(_expenses);
  List<Purchase> get purchases => List.unmodifiable(_purchases);

  void addSale(Sale s) {
    _sales.add(s);
    notifyListeners();
  }

  void addExpense(Expense e) {
    _expenses.add(e);
    notifyListeners();
  }

  void addPurchase(Purchase p) {
    _purchases.add(p);
    notifyListeners();
  }

  double totalSales({DateTime? from, DateTime? to}) {
    var list = _sales.where((s) {
      if (from != null && s.date.isBefore(from)) return false;
      if (to != null && s.date.isAfter(to)) return false;
      return true;
    });
    return list.fold(0.0, (a, b) => a + b.amount);
  }

  double totalExpenses({DateTime? from, DateTime? to}) {
    var list = _expenses.where((e) {
      if (from != null && e.date.isBefore(from)) return false;
      if (to != null && e.date.isAfter(to)) return false;
      return true;
    });
    return list.fold(0.0, (a, b) => a + b.amount);
  }

  double totalPurchases({DateTime? from, DateTime? to}) {
    var list = _purchases.where((p) {
      if (from != null && p.date.isBefore(from)) return false;
      if (to != null && p.date.isAfter(to)) return false;
      return true;
    });
    return list.fold(0.0, (a, b) => a + b.amount);
  }

  double netProfit({DateTime? from, DateTime? to}) {
    return totalSales(from: from, to: to) - totalExpenses(from: from, to: to) - totalPurchases(from: from, to: to);
  }
}
