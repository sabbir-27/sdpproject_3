import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/accounting_store.dart';
import '../../theme/app_colors.dart';
import '../../models/expense.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    // Default to show current month
    final now = DateTime.now();
    _selectedDateRange = DateTimeRange(start: DateTime(now.year, now.month, 1), end: now);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (newDateRange != null) {
      setState(() {
        _selectedDateRange = newDateRange;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountingStore>(context);
    final expenses = store.expenses.where((e) {
      if (_selectedDateRange == null) return true;
      return e.date.isAfter(_selectedDateRange!.start) && e.date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
    }).toList()..sort((a, b) => b.date.compareTo(a.date));

    final totalExpenses = expenses.fold(0.0, (prev, expense) => prev + expense.amount);

    return Column(
      children: [
        _buildHeader(context, totalExpenses),
        Expanded(
          child: expenses.isEmpty
              ? _buildEmptyState()
              : Animate(
                  effects: const [FadeEffect(), SlideEffect(begin: Offset(0, 0.1))],
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      _buildChart(expenses),
                      const SizedBox(height: 16),
                      ..._buildExpenseList(expenses),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, double totalExpenses) {
    final f = DateFormat('MMM d, yyyy');
    final dateRangeText = _selectedDateRange == null
        ? 'All Time'
        : '${f.format(_selectedDateRange!.start)} - ${f.format(_selectedDateRange!.end)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Expenses', style: TextStyle(color: Colors.grey)),
                  Text(
                    NumberFormat.currency(symbol: '৳').format(totalExpenses),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _selectDateRange(context),
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(dateRangeText, style: const TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Colors.red,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, curve: Curves.easeOut),
    );
  }

  Widget _buildChart(List<Expense> expenses) {
    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals.update(expense.category, (value) => value + expense.amount, ifAbsent: () => expense.amount);
    }

    final List<PieChartSectionData> sections = categoryTotals.entries.map((entry) {
      final isTouched = false; // Placeholder for future interactivity
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: AppColors.getPastelColor(categoryTotals.keys.toList().indexOf(entry.key)),
        value: entry.value,
        title: '${(entry.value / expenses.fold(0.0, (p, e) => p + e.amount) * 100).toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 40, sectionsSpace: 2)),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: ListView( 
                  shrinkWrap: true,
                  children: categoryTotals.keys.map((name) {
                    return Row(
                      children: [
                        Container(width: 8, height: 8, color: AppColors.getPastelColor(categoryTotals.keys.toList().indexOf(name))),
                        const SizedBox(width: 8),
                        Text(name),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpenseList(List<Expense> expenses) {
    return expenses.map((expense) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red.withOpacity(0.1),
              child: const Icon(Icons.money_off, color: Colors.red),
            ),
            title: Text(expense.category, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              '${DateFormat.yMMMd().format(expense.date)} • ${expense.note}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            trailing: Text(
              NumberFormat.currency(symbol: '৳').format(expense.amount),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),
            ),
          ),
        ).animate().fadeIn(delay: (100 * expenses.indexOf(expense)).ms, duration: 300.ms).slideX(begin: -0.2, curve: Curves.easeOut);
      }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No expenses recorded in this period.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
