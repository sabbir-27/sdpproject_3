import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/shop.dart';
import '../../models/product.dart';
import '../../theme/app_colors.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/complaint_tile.dart';
import '../../widgets/police_drawer.dart';

class PoliceDashboardScreen extends StatefulWidget {
  const PoliceDashboardScreen({super.key});

  @override
  State<PoliceDashboardScreen> createState() => _PoliceDashboardScreenState();
}

class _PoliceDashboardScreenState extends State<PoliceDashboardScreen> {
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

  void _performSearch(String shopId) {
    if (shopId.trim().isEmpty) return;

    final searchedShop = Shop(
      id: shopId,
      name: 'Shop #$shopId',
      description: 'Details for shop fetched via ID search.',
      rating: 4.2,
      distance: 'Unknown',
      imageUrl: 'https://picsum.photos/seed/$shopId/400/300',
      products: const [],
    );

    Navigator.pushNamed(
      context,
      '/police_shop_details',
      arguments: searchedShop,
    );

    _toggleSearch();
  }

  void _showActionSheet(BuildContext context, String complaintTitle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            margin: const EdgeInsets.all(16),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: AppColors.gradientEnd.withOpacity(0.9), borderRadius: BorderRadius.circular(24)),
            child: Wrap(
              children: <Widget>[
                ListTile(title: Text(complaintTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), subtitle: const Text('Complaint ID: #C-12345')),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.assignment_ind_outlined, color: AppColors.primary), title: const Text('Assign to Officer'), onTap: () => Navigator.pop(context)),
                ListTile(leading: const Icon(Icons.info_outline, color: Colors.orange), title: const Text('Issue Warning'), onTap: () => Navigator.pop(context)),
                ListTile(leading: const Icon(Icons.gavel, color: AppColors.error), title: const Text('Issue Fine'), onTap: () => Navigator.pop(context)),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.cancel_outlined, color: Colors.grey), title: const Text('Dismiss'), onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const PoliceDrawer(),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.gradientStart, AppColors.gradientEnd])),
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
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
            return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0.0, 0.5), end: Offset.zero)
                        .animate(animation),
                    child: child),
            );
        },
        child: _isSearchActive
            ? Container(
                key: const ValueKey('searchContainer'),
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search by Shop ID...',
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                    hintStyle: const TextStyle(color: AppColors.textGrey),
                  ),
                  style: const TextStyle(color: AppColors.textDark, fontSize: 16),
                  onSubmitted: _performSearch,
                ),
              )
            : const Text("Admin Dashboard", key: ValueKey('title'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      centerTitle: true,
      toolbarHeight: 60, // Corrected AppBar height
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accentPolice], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(onPressed: _toggleSearch, icon: Icon(_isSearchActive ? Icons.close : Icons.search)),
        IconButton(onPressed: () => Navigator.pushNamed(context, '/police_notifications'), icon: const Icon(Icons.notifications_outlined)),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _buildDashboardSection(title: 'User Statistics', child: _buildUserStats(context))),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: _buildDashboardSection(title: 'Complaint Status', child: _buildComplaintStatusGrid(context, crossAxisCount: 3, aspectRatio: 2.0))),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildDashboardSection(title: 'Shop Verification Status', child: _buildShopVerificationChart())),
            const SizedBox(width: 16),
            Expanded(flex: 3, child: _buildDashboardSection(title: 'High-Priority Complaints', child: _buildHighPriorityComplaints(context), onSeeAll: () => Navigator.pushNamed(context, '/police_high_priority_complaints') )),
          ],
        ),
      ].animate(interval: 200.ms).slideY(begin: 0.5, duration: 800.ms, curve: Curves.easeOutCubic).fadeIn(),
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      children: [
        _buildDashboardSection(title: 'User Statistics', child: _buildUserStats(context)),
        _buildDashboardSection(title: 'Shop Verification Status', child: _buildShopVerificationChart()),
        _buildDashboardSection(title: 'High-Priority Complaints', child: _buildHighPriorityComplaints(context), onSeeAll: () => Navigator.pushNamed(context, '/police_high_priority_complaints')),
        _buildDashboardSection(title: 'Complaint Status', child: _buildComplaintStatusGrid(context, crossAxisCount: 2, aspectRatio: 1.8)),
      ].animate(interval: 200.ms).slideY(begin: 0.5, duration: 800.ms, curve: Curves.easeOutCubic).fadeIn(),
    );
  }

  Widget _buildUserStats(BuildContext context) {
    final double consumerCount = 980;
    final double ownerCount = 265;
    final double totalUsers = consumerCount + ownerCount;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/police_users'), child: StatCard(title: 'Total Users', value: NumberFormat.compact().format(totalUsers), color: AppColors.primary, icon: Icons.group, isSmall: true))),
            const SizedBox(width: 12),
            Expanded(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/police_active_users'), child: const StatCard(title: 'Active Today', value: '312', color: AppColors.success, icon: Icons.online_prediction, isSmall: true))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/police_consumers'), child: StatCard(title: 'Consumers', value: NumberFormat.compact().format(consumerCount), color: Colors.blue, icon: Icons.person, isSmall: true))),
            const SizedBox(width: 12),
            Expanded(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/police_shop_owners'), child: StatCard(title: 'Shop Owners', value: NumberFormat.compact().format(ownerCount), color: AppColors.accentShopOwner, icon: Icons.store, isSmall: true))),
          ],
        ),
      ],
    );
  }

  Widget _buildComplaintStatusGrid(BuildContext context, {required int crossAxisCount, required double aspectRatio}) {
    final items = [
      GestureDetector(onTap: () => Navigator.pushNamed(context, '/police_complaints'), child: const StatCard(title: 'Total', value: '48', color: AppColors.primary, icon: Icons.receipt_long, isSmall: true)),
      GestureDetector(onTap: () => Navigator.pushNamed(context, '/police_pending_complaints'), child: const StatCard(title: 'Pending', value: '12', color: Colors.grey, icon: Icons.pending, isSmall: true)),
      GestureDetector(onTap: () => Navigator.pushNamed(context, '/police_in_review_complaints'), child: const StatCard(title: 'In Review', value: '8', color: AppColors.warning, icon: Icons.hourglass_top, isSmall: true)),
      GestureDetector(onTap: () => Navigator.pushNamed(context, '/police_assigned_complaints'), child: const StatCard(title: 'Assigned', value: '6', color: Colors.blueAccent, icon: Icons.assignment_ind, isSmall: true)),
      GestureDetector(onTap: () => Navigator.pushNamed(context, '/police_resolved_complaints'), child: const StatCard(title: 'Resolved', value: '20', color: AppColors.success, icon: Icons.check_circle, isSmall: true)),
      GestureDetector(onTap: () => Navigator.pushNamed(context, '/police_rejected_complaints'), child: const StatCard(title: 'Rejected', value: '2', color: AppColors.error, icon: Icons.cancel, isSmall: true)),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: aspectRatio,
      children: items.animate(interval: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.5),
    );
  }
  
  Widget _buildShopVerificationChart() {
    final double verifiedCount = 210;
    final double pendingCount = 45;
    final double suspendedCount = 10;
    final double totalShops = verifiedCount + pendingCount + suspendedCount;

    return SizedBox(
      height: 180,
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: Colors.blue.shade400, // Updated Color
                    value: verifiedCount,
                    title: '${(verifiedCount / totalShops * 100).toStringAsFixed(0)}%',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Colors.teal.shade400, // Updated Color
                    value: pendingCount,
                    title: '${(pendingCount / totalShops * 100).toStringAsFixed(0)}%',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Colors.purple.shade400, // Updated Color
                    value: suspendedCount,
                    title: '${(suspendedCount / totalShops * 100).toStringAsFixed(0)}%',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ).animate().scale(delay: 400.ms, duration: 800.ms),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Indicator(color: Colors.blue.shade400, text: 'Verified'),
              _Indicator(color: Colors.teal.shade400, text: 'Pending'),
              _Indicator(color: Colors.purple.shade400, text: 'Suspended'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHighPriorityComplaints(BuildContext context) {
    final complaints = [
      const ComplaintTile(title: 'Illegal Parking Violation', date: '2024-07-28', status: ComplaintStatus.New, hasVideo: true),
      const ComplaintTile(title: 'Loud Noise Complaint', date: '2024-07-27', status: ComplaintStatus.InReview, hasVideo: false),
      const ComplaintTile(title: 'Public Disturbance', date: '2024-07-26', status: ComplaintStatus.New, hasVideo: true),
    ];

    return Column(
      children: complaints
          .map((c) => GestureDetector(onTap: () => _showActionSheet(context, c.title), child: c))
          .toList()
          .animate(interval: 200.ms)
          .fadeIn()
          .slideY(begin: 0.5),
    );
  }
  
  Widget _buildDashboardSection({required String title, required Widget child, VoidCallback? onSeeAll}) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                if (onSeeAll != null)
                  TextButton(onPressed: onSeeAll, child: const Text('View All')),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.title, required this.value, required this.icon, required this.color});

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
          ],
        )
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
      ],
    );
  }
}
