import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/accounting_store.dart';
import '../../theme/app_colors.dart';
import '../../models/sale.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    // Default to show current month
    final now = DateTime.now();
    _selectedDateRange = DateTimeRange(start: DateTime(now.year, now.month, 1), end: now);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final initialDateRange = _selectedDateRange ??
        DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 30)),
          end: DateTime.now(),
        );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: initialDateRange,
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
    final sales = store.sales.where((s) {
      if (_selectedDateRange == null) return true;
      return s.date.isAfter(_selectedDateRange!.start) && s.date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
    }).toList()..sort((a, b) => b.date.compareTo(a.date));

    final totalSales = sales.fold(0.0, (prev, sale) => prev + sale.amount);

    return Column(
      children: [
        _buildHeader(context, totalSales),
        Expanded(
          child: sales.isEmpty
              ? _buildEmptyState()
              : _buildSalesList(sales),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, double totalSales) {
    final f = DateFormat('MMM d, yyyy');
    final dateRangeText = _selectedDateRange == null
        ? 'All Time'
        : '${f.format(_selectedDateRange!.start)} - ${f.format(_selectedDateRange!.end)}';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
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
                      const Text('Total Sales', style: TextStyle(color: Colors.grey)),
                      Text(NumberFormat.currency(symbol: '৳').format(totalSales), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _selectDateRange(context),
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(dateRangeText, style: const TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, curve: Curves.easeOut),
        ],
      ),
    );
  }

  Widget _buildSalesList(List<Sale> sales) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(Icons.person, color: AppColors.primary),
            ),
            title: Text(sale.customer, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              '${DateFormat.yMMMd().add_jm().format(sale.date)} • Paid with ${sale.paymentMethod}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            trailing: Text(
              NumberFormat.currency(symbol: '৳').format(sale.amount),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
            ),
          ),
        ).animate().fadeIn(delay: (100 * index).ms, duration: 300.ms).slideX(begin: -0.2, curve: Curves.easeOut);
      },
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.point_of_sale_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No sales recorded in this period.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
