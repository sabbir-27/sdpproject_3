import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/shop.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_tile.dart';

class ShopDetailsForPoliceScreen extends StatelessWidget {
  const ShopDetailsForPoliceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = ModalRoute.of(context)!.settings.arguments as Shop? ??
        const Shop(
            id: 'fallback',
            name: 'Unknown Shop',
            description: '',
            rating: 0,
            distance: '',
            imageUrl: 'https://i.pravatar.cc/150',
            products: [],
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(shop.name),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildShopHeader(shop),
            const SizedBox(height: 24),
            _buildSectionHeader('Complaint History'),
            const ComplaintTile(title: 'Product was defective', date: '2024-07-25', status: ComplaintStatus.Resolved, hasVideo: false),
            const ComplaintTile(title: 'Did not ship on time', date: '2024-07-20', status: ComplaintStatus.Resolved, hasVideo: false),
            const SizedBox(height: 24),
            _buildSectionHeader('Review Summary'),
            _buildReviewSummary(context, shop.rating),
            const SizedBox(height: 24),
             _buildSectionHeader('Products'),
            if (shop.products.isEmpty)
              const Center(child: Text('No products found.'))
            else
              ...shop.products.map((product) => ListTile(
                    leading: Image.asset(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price}'),
                  )).toList().animate(interval: 100.ms).fadeIn().slideX(begin: 0.2),
          ],
        ),
      ),
    );
  }

  Widget _buildShopHeader(Shop shop) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Hero(
              tag: 'shop_image_${shop.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(shop.imageUrl, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (c, o, s) => const Icon(Icons.storefront, size: 80)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(shop.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(shop.description, style: const TextStyle(color: AppColors.textGrey)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildReviewSummary(BuildContext context, double rating) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 32),
                const SizedBox(height: 4),
                Text('$rating / 5.0', style: Theme.of(context).textTheme.titleLarge),
                const Text('Average Rating'),
              ],
            ),
            Column(
              children: [
                const Icon(Icons.rate_review_outlined, color: AppColors.primary, size: 32),
                const SizedBox(height: 4),
                Text('125', style: Theme.of(context).textTheme.titleLarge),
                const Text('Total Reviews'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
