import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/sale.dart';
import '../../providers/accounting_store.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shop_owner_drawer.dart';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  String _selectedPeriod = 'Last 30 Days';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Trends'),
        backgroundColor: AppColors.primary,
      ),
      drawer: const ShopOwnerDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            _buildPeriodSelector(),
            const SizedBox(height: 24),
            _buildChartCard(
              title: 'Sales Over Time',
              subtitle: 'Revenue trend for the $_selectedPeriod',
              child: SalesOverTimeChart(period: _selectedPeriod),
            ),
            _buildChartCard(
              title: 'Performance Snapshot',
              subtitle: 'Sales vs. Expenses & Profit for the $_selectedPeriod',
              child: PerformanceComparisonChart(period: _selectedPeriod),
            ),
            _buildChartCard(
              title: 'Key Metrics',
              subtitle: 'Performance indicators for the $_selectedPeriod',
              child: KeyMetricsGrid(period: _selectedPeriod),
            ),
          ].animate(interval: 100.ms).fadeIn(duration: 500.ms).slideY(begin: 0.2),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedPeriod,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.calendar_today, color: AppColors.primary),
      ),
      items: ['Last 7 Days', 'Last 30 Days', 'Last 90 Days']
          .map((period) => DropdownMenuItem(
                value: period,
                child: Text(period),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedPeriod = value;
          });
        }
      },
    );
  }

  Widget _buildChartCard({required String title, required String subtitle, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 14, color: AppColors.textGrey)),
            const SizedBox(height: 24),
            SizedBox(height: 220, child: child),
          ],
        ),
      ),
    );
  }
}

class SalesOverTimeChart extends StatelessWidget {
  final String period;
  const SalesOverTimeChart({required this.period, super.key});

  int get days {
    if (period == 'Last 7 Days') return 7;
    if (period == 'Last 30 Days') return 30;
    return 90;
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountingStore>(context, listen: false);
    final now = DateTime.now();
    final fromDate = now.subtract(Duration(days: days));

    final spots = List.generate(days, (index) {
      final date = fromDate.add(Duration(days: index));
      final salesOnDate = store.sales
        .where((s) =>
            s.date.year == date.year &&
            s.date.month == date.month &&
            s.date.day == date.day)
        .fold(0.0, (prev, s) => prev + s.amount);
      return FlSpot(index.toDouble(), salesOnDate);
    });

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.3), AppColors.accent.withOpacity(0.0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 1.seconds, curve: Curves.easeOut);
  }
}

class PerformanceComparisonChart extends StatelessWidget {
  final String period;
  const PerformanceComparisonChart({required this.period, super.key});
  
    int get days {
    if (period == 'Last 7 Days') return 7;
    if (period == 'Last 30 Days') return 30;
    return 90;
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountingStore>(context, listen: false);
    final fromDate = DateTime.now().subtract(Duration(days: days));

    final totalSales = store.totalSales(from: fromDate);
    final totalExpenses = store.totalExpenses(from: fromDate);
    final netProfit = totalSales - totalExpenses;
    
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                String text = '';
                switch (value.toInt()) {
                    case 0: text = 'Sales'; break;
                    case 1: text = 'Expenses'; break;
                    case 2: text = 'Profit'; break;
                }
                return SideTitleWidget(axisSide: meta.axisSide, child: Text(text));
            })),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: [
            _buildBarGroupData(0, totalSales, AppColors.primary),
            _buildBarGroupData(1, totalExpenses, AppColors.accent),
            _buildBarGroupData(2, netProfit, Colors.green),
        ]
      )
    ).animate().scale(duration: 800.ms, curve: Curves.easeOut);
  }
  
    BarChartGroupData _buildBarGroupData(int x, double y, Color color) {
    return BarChartGroupData(x: x, barRods: [
        BarChartRodData(toY: y, color: color, width: 40, borderRadius: BorderRadius.circular(4))
    ]);
  }
}


class KeyMetricsGrid extends StatelessWidget {
  final String period;
  const KeyMetricsGrid({required this.period, super.key});
  
  int get days {
    if (period == 'Last 7 Days') return 7;
    if (period == 'Last 30 Days') return 30;
    return 90;
  }

  @override
  Widget build(BuildContext context) {
        final store = Provider.of<AccountingStore>(context, listen: false);
        final fromDate = DateTime.now().subtract(Duration(days: days));
        final sales = store.sales.where((s) => s.date.isAfter(fromDate)).toList();
        final averageSale = sales.isEmpty ? 0 : sales.map((s) => s.amount).reduce((a, b) => a + b) / sales.length;
        final numSales = sales.length;

        // Dummy MoM growth
        final monthlyGrowth = (period == 'Last 30 Days') ? 12.5 : 5.2;

    return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
        physics: const NeverScrollableScrollPhysics(),
        children: [
            _buildMetricCard('Avg. Sale', NumberFormat.currency(symbol: '৳').format(averageSale), Icons.monetization_on_outlined, Colors.green),
            _buildMetricCard('Num. of Sales', numSales.toString(), Icons.receipt_long_outlined, Colors.blue),
            _buildMetricCard('Monthly Growth', '${monthlyGrowth.toStringAsFixed(1)}%', Icons.trending_up, Colors.purple),
            _buildMetricCard('New Customers', '14', Icons.person_add_alt_1_outlined, Colors.orange), // Dummy
        ],
    );
  }
  
    Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
        return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(title, style: TextStyle(color: color, fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                        children: [
                            Icon(icon, color: color),
                            const SizedBox(width: 8),
                            Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                    )
                ]
            )
        );
    }
}
