import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/complaint.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';
import '../../widgets/shop_owner_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (_isSearchActive) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        _searchFocusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final inAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(animation);
            final outAnimation = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(animation);

            if (child.key == const ValueKey('searchField')) {
              return ClipRect(
                child: SlideTransition(
                  position: inAnimation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
              );
            } else {
              return ClipRect(
                child: SlideTransition(
                  position: outAnimation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
              );
            }
          },
          child: _isSearchActive
              ? TextField(
                  key: const ValueKey('searchField'),
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search dashboard...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.textDark),
                  ),
                  style: const TextStyle(color: AppColors.textDark, fontSize: 18),
                )
              : const Text(
                  "POTHOBONDHU",
                  key: ValueKey('title'),
                  style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 24),
                ),
        ),
        backgroundColor: AppColors.gradientStart.withAlpha(204),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSearchActive ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      drawer: const ShopOwnerDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 950) {
                      return _buildWideLayout(context);
                    } else {
                      return _buildNarrowLayout(context);
                    }
                  },
                ),
              ),
            ),
            _buildRightSidebar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRightSidebar(BuildContext context) {
    final activeUsers = {
      'User 1': 'https://i.pravatar.cc/150?u=a042581f4e290267041',
      'User 2': 'https://i.pravatar.cc/150?u=a042581f4e290267042',
      'User 3': 'https://i.pravatar.cc/150?u=a042581f4e290267043',
      'User 4': 'https://i.pravatar.cc/150?u=a042581f4e290267044',
      'User 5': 'https://i.pravatar.cc/150?u=a042581f4e290267045',
    };

    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white.withOpacity(0.3),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: activeUsers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(activeUsers.values.elementAt(index)),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          FloatingActionButton(
            mini: true,
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _DashboardCard(child: _buildRecentCustomersContent(context))),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: _DashboardCard(child: _buildWeeklySalesContent(context))),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: _DashboardCard(child: _buildStoreOverviewContent(context))),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _DashboardCard(child: _buildTodaysOrdersContent(context), color: const Color(0xFFFEF0F6))),
            const SizedBox(width: 16),
            Expanded(
              flex: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _DashboardCard(child: _buildOnlineUsersContent(context), color: const Color(0xFFE6F6F5), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16))),
                  const SizedBox(width: 16),
                  Expanded(child: _DashboardCard(child: _buildNewVsReturningContent(context), color: const Color(0xFFFFF4EC), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16))),
                  const SizedBox(width: 16),
                  Expanded(child: _DashboardCard(child: _buildCheckoutStatusContent(context), color: const Color(0xFFF6F0FF), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16))),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _DashboardCard(child: _buildHistoricalSalesContent(context))),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: _DashboardCard(child: _buildDailySalesSummaryContent(context))),
          ],
        ),
        const SizedBox(height: 16),
        _DashboardCard(child: _buildRecentComplaintsContent(context)),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      children: [
        _DashboardCard(child: _buildRecentCustomersContent(context)),
        const SizedBox(height: 16),
        _DashboardCard(child: _buildWeeklySalesContent(context)),
        const SizedBox(height: 16),
        _DashboardCard(child: _buildStoreOverviewContent(context)),
        const SizedBox(height: 16),
        _DashboardCard(child: _buildTodaysOrdersContent(context), color: const Color(0xFFFEF0F6)),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _DashboardCard(child: _buildOnlineUsersContent(context), color: const Color(0xFFE6F6F5), padding: const EdgeInsets.all(8))),
            const SizedBox(width: 16),
            Expanded(child: _DashboardCard(child: _buildNewVsReturningContent(context), color: const Color(0xFFFFF4EC), padding: const EdgeInsets.all(8))),
          ],
        ),
        const SizedBox(height: 16),
        _DashboardCard(child: _buildCheckoutStatusContent(context), color: const Color(0xFFF6F0FF)),
        const SizedBox(height: 16),
        _DashboardCard(child: _buildHistoricalSalesContent(context)),
        const SizedBox(height: 16),
        _DashboardCard(child: _buildDailySalesSummaryContent(context)),
        const SizedBox(height: 16),
        _DashboardCard(child: _buildRecentComplaintsContent(context)),
      ],
    );
  }

  Widget _buildRecentCustomersContent(BuildContext context) {
    final customers = {
      'Mimi': 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
      'Sarlok': 'https://i.pravatar.cc/150?u=a042581f4e29026704e',
      'Nusrat': 'https://i.pravatar.cc/150?u=a042581f4e29026704f',
      'Asif': 'https://i.pravatar.cc/150?u=a042581f4e29026704a',
      'Tanny': 'https://i.pravatar.cc/150?u=a042581f4e29026704b',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Customers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: customers.entries.map((e) => _buildCustomerAvatar(e.key, e.value)).toList(),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildCustomerAvatar(String name, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(radius: 22, backgroundImage: NetworkImage(imageUrl)),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildWeeklySalesContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Weekly Sales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\৳84,920.54 Tk', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  Text('+14% increase', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.bar_chart, size: 40, color: AppColors.primary),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms);
  }

  Widget _buildStoreOverviewContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Store Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text('Total Products in Store: 124', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/products'),
            child: const Text('Add New Product'),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms);
  }

  Widget _buildTodaysOrdersContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Today\'s Sales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text('\৳14,920.54 Tk', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.pink)),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(label: 'Sold', value: '224'),
            _StatItem(label: 'Returns', value: '12'),
            _StatItem(label: 'Picked', value: '210'),
            _StatItem(label: 'In Transit', value: '112'),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 600.ms, duration: 500.ms);
  }

  Widget _buildOnlineUsersContent(BuildContext context) {
    return Row(
      children: [
        const RotatedBox(quarterTurns: -1, child: Text('Online Users', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        const VerticalDivider(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _StatItem(label: 'Last 30 Min', value: '96', valueStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Icon(Icons.bar_chart, color: Colors.teal.shade200, size: 28),
              const SizedBox(height: 8),
              const _StatItem(label: 'Right Now', value: '12', valueStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 800.ms, duration: 500.ms);
  }

  Widget _buildNewVsReturningContent(BuildContext context) {
    return Row(
      children: [
        const RotatedBox(quarterTurns: -1, child: Text('New vs Returning', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        const VerticalDivider(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _StatItem(label: 'Returning', value: '13.3k', valueStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
              const SizedBox(height: 12),
              const _StatItem(label: 'New', value: '21.4k', valueStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1000.ms, duration: 500.ms);
  }

  Widget _buildCheckoutStatusContent(BuildContext context) {
    return Row(
      children: [
        const RotatedBox(quarterTurns: -1, child: Text('Checkout Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        const VerticalDivider(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _StatItem(label: 'Completed', value: '981', valueStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)),
              const SizedBox(height: 12),
              const _StatItem(label: 'Abandoned', value: '654', valueStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1200.ms, duration: 500.ms);
  }

  Widget _buildHistoricalSalesContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Historical Sales Stat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Since Jan 2025', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: CustomPaint(
            painter: _LineChartPainter(),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
              .map((month) => Text(month, style: const TextStyle(fontSize: 10, color: Colors.grey)))
              .toList(),
        )
      ],
    ).animate().fadeIn(delay: 1400.ms, duration: 500.ms);
  }

  Widget _buildDailySalesSummaryContent(BuildContext context) {
    final List<double> salesData = [0.5, 0.8, 0.6, 0.9, 0.7, 0.5, 0.8, 0.4, 0.6, 0.9, 0.7];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Sales Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('From 12 Oct - 24 Nov', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.download_for_offline_outlined, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: salesData.map((height) {
              return Container(
                width: 12,
                height: 80 * height,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.5),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 24),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(label: 'Minimum', value: '14,170'),
            _StatItem(label: 'Maximum', value: '28,170'),
            _StatItem(label: 'Average', value: '21,518'),
          ],
        )
      ],
    ).animate().fadeIn(delay: 1600.ms, duration: 500.ms);
  }

  Widget _buildRecentComplaintsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Complaints', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 8),
        const ComplaintTile(title: 'Late Delivery', date: '2 days ago', status: ComplaintStatus.InReview),
        const ComplaintTile(title: 'Damaged Item', date: '5 days ago', status: ComplaintStatus.Resolved),
      ],
    ).animate().fadeIn(delay: 1800.ms, duration: 500.ms);
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.purple.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final paint2 = Paint()
      ..color = Colors.pink.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path1 = Path();
    final path2 = Path();

    final points1 = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.1, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.7),
      Offset(size.width * 0.3, size.height * 0.4),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.3),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.7, size.height * 0.6),
      Offset(size.width * 0.8, size.height * 0.5),
      Offset(size.width * 0.9, size.height * 0.7),
      Offset(size.width, size.height * 0.6),
    ];

    final points2 = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.1, size.height * 0.9),
      Offset(size.width * 0.2, size.height * 0.7),
      Offset(size.width * 0.3, size.height * 0.8),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.7),
      Offset(size.width * 0.6, size.height * 0.5),
      Offset(size.width * 0.7, size.height * 0.6),
      Offset(size.width * 0.8, size.height * 0.8),
      Offset(size.width * 0.9, size.height * 0.7),
      Offset(size.width, size.height * 0.8),
    ];

    _drawSmoothPath(path1, points1);
    _drawSmoothPath(path2, points2);

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  void _drawSmoothPath(Path path, List<Offset> points) {
    if (points.isEmpty) return;
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset((p0.dx + p1.dx) / 2, p0.dy);
      final controlPoint2 = Offset((p0.dx + p1.dx) / 2, p1.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p1.dx, p1.dy);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _DashboardCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;

  const _DashboardCard({required this.child, this.color, this.padding = const EdgeInsets.all(16.0)});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: color ?? Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _StatItem({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: valueStyle ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
