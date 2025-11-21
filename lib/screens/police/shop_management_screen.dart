import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/police_drawer.dart';

// Dummy Shop Verification Model
class ShopVerification {
  final String id;
  final String name;
  final String ownerName;
  final String status; // "Verified", "Pending", "Suspended"
  final String location;
  final String phone;

  const ShopVerification({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.status,
    required this.location,
    required this.phone,
  });
}

class ShopManagementScreen extends StatefulWidget {
  const ShopManagementScreen({super.key});

  @override
  State<ShopManagementScreen> createState() => _ShopManagementScreenState();
}

class _ShopManagementScreenState extends State<ShopManagementScreen> {
  // Extended Dummy Data
  final List<ShopVerification> _allShops = const [
    ShopVerification(id: '1', name: 'Sabbir\'s Electronics', ownerName: 'Sabbir Ahmed', status: 'Verified', location: 'Dhanmondi 27', phone: '01711000000'),
    ShopVerification(id: '2', name: 'Green Grocers', ownerName: 'Ayesha Khan', status: 'Verified', location: 'Gulshan 1', phone: '01822000000'),
    ShopVerification(id: '3', name: 'Bookworm Corner', ownerName: 'Imran Chowdhury', status: 'Pending', location: 'Banani 11', phone: '01933000000'),
    ShopVerification(id: '4', name: 'The Gadget Hub', ownerName: 'Farah Islam', status: 'Suspended', location: 'Uttara Sector 7', phone: '01644000000'),
    ShopVerification(id: '5', name: 'Daily Needs', ownerName: 'Rahim Uddin', status: 'Verified', location: 'Mirpur 10', phone: '01555000000'),
    ShopVerification(id: '6', name: 'Fashion Fiesta', ownerName: 'Sadia Rahman', status: 'Pending', location: 'Baily Road', phone: '01766000000'),
  ];

  List<ShopVerification> _filteredShops = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredShops = _allShops;
  }

  void _filterShops(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredShops = _allShops;
      } else {
        _filteredShops = _allShops.where((shop) {
          final nameLower = shop.name.toLowerCase();
          final ownerLower = shop.ownerName.toLowerCase();
          final searchLower = query.toLowerCase();
          return nameLower.contains(searchLower) || ownerLower.contains(searchLower);
        }).toList();
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Verified': return AppColors.success;
      case 'Pending': return AppColors.warning;
      case 'Suspended': return AppColors.error;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Verified': return Icons.verified;
      case 'Pending': return Icons.pending_actions;
      case 'Suspended': return Icons.block;
      default: return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: const PoliceDrawer(),
      appBar: AppBar(
        title: const Text('Shop Management', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // TODO: Implement status filtering
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryHeader(),
          _buildSearchBar(),
          Expanded(
            child: _filteredShops.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: _filteredShops.length,
                    itemBuilder: (context, index) {
                      return _buildShopCard(_filteredShops[index], index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    int total = _allShops.length;
    int verified = _allShops.where((s) => s.status == 'Verified').length;
    int pending = _allShops.where((s) => s.status == 'Pending').length;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem('Total', total.toString(), Icons.store),
          _buildSummaryItem('Verified', verified.toString(), Icons.check_circle),
          _buildSummaryItem('Pending', pending.toString(), Icons.hourglass_empty),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        onChanged: _filterShops,
        decoration: const InputDecoration(
          hintText: 'Search by shop or owner name...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildShopCard(ShopVerification shop, int index) {
    Color statusColor = _getStatusColor(shop.status);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showShopDetails(shop),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    shop.name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(shop.ownerName, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(shop.location, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getStatusIcon(shop.status), size: 12, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          shop.status,
                          style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No shops found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  void _showShopDetails(ShopVerification shop) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      shop.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(shop.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(shop.status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailRow(Icons.person, 'Owner', shop.ownerName),
              _buildDetailRow(Icons.phone, 'Phone', shop.phone),
              _buildDetailRow(Icons.location_on, 'Location', shop.location),
              _buildDetailRow(Icons.confirmation_number, 'License ID', 'LIC-${shop.id}8829'),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Message'),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (shop.status == 'Pending')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.verified),
                        label: const Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        label: const Text('Manage'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
