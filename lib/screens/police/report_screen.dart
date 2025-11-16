import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/police_drawer.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Reports', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentPolice,
          indicatorWeight: 4,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 16),
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ],
        ),
      ),
      drawer: const PoliceDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildReportTab(context, 'Daily', [7, 8, 6, 9, 7, 8, 7]),
            _buildReportTab(context, 'Weekly', [45, 50, 48, 55, 52, 60, 58]),
            _buildReportTab(context, 'Monthly', [210, 220, 215, 230, 225, 240, 235]),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTab(BuildContext context, String period, List<double> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildChartCard(period, data),
          const SizedBox(height: 24),
          _buildSummaryCards(data),
        ],
      ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOutCubic),
    );
  }

  Widget _buildChartCard(String period, List<double> data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$period Complaint Trend', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: AppColors.primary.withOpacity(0.8),
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          return LineTooltipItem(
                            barSpot.y.toStringAsFixed(0),
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _getLeftTitleInterval(data),
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(color: AppColors.textGrey, strokeWidth: 0.2);
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => _bottomTitleWidgets(value, meta, period),
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) => _leftTitleWidgets(value, meta),
                        interval: _getLeftTitleInterval(data),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                      isCurved: true,
                      gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accentPolice]),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [AppColors.primary.withOpacity(0.3), AppColors.accentPolice.withOpacity(0.0)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 1500.ms, curve: Curves.easeOut),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(List<double> data) {
    final total = data.reduce((a, b) => a + b);
    final resolved = total * 0.7; // Dummy data
    final pending = total - resolved;

    return Column(
      children: [
        _buildSummaryCard('Total Complaints', total.toStringAsFixed(0), Icons.receipt_long, AppColors.primary),
        _buildSummaryCard('Resolved', resolved.toStringAsFixed(0), Icons.check_circle, AppColors.success),
        _buildSummaryCard('Pending', pending.toStringAsFixed(0), Icons.pending_actions, AppColors.warning),
      ]
          .animate(interval: 200.ms)
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.5),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta, String period) {
    const style = TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold, fontSize: 12);
    Widget text;
    switch (period) {
      case 'Daily':
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        if (value.toInt() < days.length) {
          text = Text(days[value.toInt()], style: style);
        } else {
          text = const Text('', style: style);
        }
        break;
      case 'Weekly':
        text = Text('W${value.toInt() + 1}', style: style);
        break;
      case 'Monthly':
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        if (value.toInt() < months.length) {
          text = Text(months[value.toInt()], style: style);
        } else {
          text = const Text('', style: style);
        }
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold, fontSize: 12);
    return Text(value.toInt().toString(), style: style, textAlign: TextAlign.left);
  }

  double _getLeftTitleInterval(List<double> data) {
    if (data.isEmpty) return 1;
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    if (maxVal <= 10) return 2;
    if (maxVal <= 50) return 10;
    if (maxVal <= 100) return 20;
    return 50;
  }
}
