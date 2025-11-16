import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../models/expense.dart';
import '../../models/purchase.dart';
import '../../models/sale.dart';
import '../../providers/accounting_store.dart';
import '../../theme/app_colors.dart';
import '../../widgets/add_expense_dialog.dart';
import '../../widgets/add_purchase_dialog.dart';
import '../../widgets/add_sale_dialog.dart';
import '../../widgets/shop_owner_drawer.dart';
import 'accounting_dashboard_screen.dart';
import 'expenses_screen.dart';
import 'purchases_screen.dart';
import 'reports_screen.dart';
import 'sales_screen.dart';

class AccountingScreen extends StatefulWidget {
  const AccountingScreen({super.key});

  @override
  State<AccountingScreen> createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    AccountingDashboardScreen(),
    SalesScreen(),
    ExpensesScreen(),
    PurchasesScreen(),
    ReportsScreen(),
  ];

  static const List<String> _titles = [
    'Accounting Dashboard',
    'Sales Records',
    'Expense Tracking',
    'Purchase History',
    'Financial Reports',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.gradientStart.withOpacity(0.8),
        elevation: 0,
      ),
      drawer: const ShopOwnerDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Container(
           key: ValueKey<int>(_selectedIndex),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: _screens.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.white,
        elevation: 4.0,
        indicatorColor: AppColors.primary.withOpacity(0.15),
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.point_of_sale, color: AppColors.primary),
            icon: Icon(Icons.point_of_sale_outlined),
            label: 'Sales',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.receipt_long, color: AppColors.primary),
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Expenses',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.shopping_cart, color: AppColors.primary),
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Purchases',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bar_chart, color: AppColors.primary),
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Reports',
          ),
        ],
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: _buildFAB(),
      ),
    );
  }

  Widget? _buildFAB() {
    switch (_selectedIndex) {
      case 1: // Sales
        return FloatingActionButton(
          key: const ValueKey('add_sale'),
          onPressed: () => _showAddSaleDialog(context),
          tooltip: 'Add Sale',
          child: const Icon(Icons.add),
        );
      case 2: // Expenses
        return FloatingActionButton(
          key: const ValueKey('add_expense'),
          onPressed: () => _showAddExpenseDialog(context),
          tooltip: 'Add Expense',
          child: const Icon(Icons.add),
        );
      case 3: // Purchases
        return FloatingActionButton(
          key: const ValueKey('add_purchase'),
          onPressed: () => _showAddPurchaseDialog(context),
          tooltip: 'Add Purchase',
          child: const Icon(Icons.add),
        );
      default:
        return null; // No FAB for Dashboard or Reports
    }
  }

   void _showAddSaleDialog(BuildContext context) async {
    final result = await showDialog<Sale?>(
      context: context,
      builder: (c) => const AddSaleDialog(),
    );
    if (result != null && mounted) {
      Provider.of<AccountingStore>(context, listen: false).addSale(result);
    }
  }

  void _showAddExpenseDialog(BuildContext context) async {
    final result = await showDialog<Expense?>(
      context: context,
      builder: (c) => const AddExpenseDialog(),
    );
    if (result != null && mounted) {
      Provider.of<AccountingStore>(context, listen: false).addExpense(result);
    }
  }

  void _showAddPurchaseDialog(BuildContext context) async {
    final result = await showDialog<Purchase?>(
      context: context,
      builder: (c) => const AddPurchaseDialog(),
    );
    if (result != null && mounted) {
      Provider.of<AccountingStore>(context, listen: false).addPurchase(result);
    }
  }
}
