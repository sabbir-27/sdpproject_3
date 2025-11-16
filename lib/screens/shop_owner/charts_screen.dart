import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/sale.dart';
import '../../providers/accounting_store.dart';
import '../../providers/product_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shop_owner_drawer.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Charts'),
        backgroundColor: AppColors.primary,
        elevation: 0,
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
            _buildChartCard(
              title: 'Monthly Sales Overview',
              subtitle: 'Last 6 Months Performance',
              child: const MonthlySalesChart(),
            ),
            _buildChartCard(
              title: 'Product Inventory Levels',
              subtitle: 'Current Stock of Top Products',
              child: const ProductInventoryChart(),
            ),
            _buildChartCard(
              title: 'Expense Breakdown',
              subtitle: 'Spending by Category for the Current Month',
              child: const ExpenseBreakdownChart(),
            ),
          ].animate(interval: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.5, curve: Curves.easeOutCubic),
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required String subtitle, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 14, color: AppColors.textGrey)),
            const SizedBox(height: 24),
            SizedBox(height: 200, child: child),
          ],
        ),
      ),
    );
  }
}

class MonthlySalesChart extends StatelessWidget {
  const MonthlySalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final salesData = _getMonthlySales(Provider.of<AccountingStore>(context).sales);
    final gradient = LinearGradient(colors: [AppColors.primary, AppColors.accent]);

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                return SideTitleWidget(axisSide: meta.axisSide, child: Text(months[value.toInt() % 12], style: const TextStyle(fontSize: 10)));
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: salesData,
            isCurved: true,
            gradient: gradient,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [gradient.colors.first.withOpacity(0.3), gradient.colors.last.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 1500.ms, curve: Curves.easeOut);
  }

  List<FlSpot> _getMonthlySales(List<Sale> sales) {
    Map<int, double> monthlyTotals = {};
    for (var sale in sales) {
      monthlyTotals.update(sale.date.month -1, (value) => value + sale.amount, ifAbsent: () => sale.amount);
    }
    return monthlyTotals.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
  }
}

class ProductInventoryChart extends StatelessWidget {
  const ProductInventoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;
    if (products.isEmpty) return const Center(child: Text("No product data."));

    String getSafeSubstring(String text) {
      return text.length >= 3 ? text.substring(0, 3) : text;
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: products.map((p) => p.stock).reduce((a, b) => a > b ? a : b).toDouble() * 1.2,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) => SideTitleWidget(axisSide: meta.axisSide, space: 4.0, child: Text(getSafeSubstring(products[value.toInt()].name), style: const TextStyle(fontSize: 10)))))
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem('${products[group.x.toInt()].name}\n', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), children: <TextSpan>[TextSpan(text: rod.toY.round().toString(), style: const TextStyle(color: Colors.yellow))]);
            }
          )
        ),
        barGroups: products.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [BarChartRodData(toY: entry.value.stock.toDouble(), gradient: LinearGradient(colors: [AppColors.getPastelColor(entry.key), AppColors.getPastelColor(entry.key).withOpacity(0.5)], begin: Alignment.bottomCenter, end: Alignment.topCenter), width: 20, borderRadius: BorderRadius.circular(4))],
          );
        }).toList(),
      ),
    ).animate().slideY(begin: 0.5, delay: 200.ms, duration: 800.ms, curve: Curves.easeOutCubic).fadeIn();
  }
}

class ExpenseBreakdownChart extends StatefulWidget {
  const ExpenseBreakdownChart({super.key});

  @override
  State<ExpenseBreakdownChart> createState() => _ExpenseBreakdownChartState();
}

class _ExpenseBreakdownChartState extends State<ExpenseBreakdownChart> {
  int touchedIndex = -1;

  final Map<String, Color> _categoryColorMap = {
    'Office Supplies': AppColors.getPastelColor(0), // Blue
    'Utilities': AppColors.getPastelColor(3),       // Orange
    'Rent': AppColors.getPastelColor(4),             // Purple
  };

  Color _getColor(String category, int index) {
    return _categoryColorMap[category] ?? AppColors.getPastelColor(index);
  }

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<AccountingStore>(context).expenses;
    if (expenses.isEmpty) return const Center(child: Text("No expense data available."));

    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals.update(expense.category, (value) => value + expense.amount, ifAbsent: () => expense.amount);
    }
    final total = expenses.fold(0.0, (sum, item) => sum + item.amount);

    return Row(
      children: <Widget>[
        Expanded(
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              }),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: categoryTotals.entries.map((entry) {
                final index = categoryTotals.keys.toList().indexOf(entry.key);
                final isTouched = index == touchedIndex;
                final radius = isTouched ? 60.0 : 50.0;
                return PieChartSectionData(
                  color: _getColor(entry.key, index),
                  value: entry.value,
                  title: '${(entry.value / total * 100).toStringAsFixed(0)}%',
                  radius: radius,
                  titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 2)]),
                );
              }).toList(),
            ),
          ).animate().scale(duration: 1000.ms, curve: Curves.elasticOut),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categoryTotals.keys.map((name) {
            final index = categoryTotals.keys.toList().indexOf(name);
            return _Indicator(color: _getColor(name, index), text: name, isSquare: true);
          }).toList(),
        ),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({required this.color, required this.text, required this.isSquare, this.size = 16, this.textColor});
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: <Widget>[
          Container(width: size, height: size, decoration: BoxDecoration(shape: isSquare ? BoxShape.rectangle : BoxShape.circle, color: color)),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor))
        ],
      ),
    );
  }
}
