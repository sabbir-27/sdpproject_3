import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/shop.dart';
import '../../theme/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  // Dummy data for favorite shops (in a real app, this would be dynamic)
  final List<Shop> favoriteShops = const [
    Shop(id: '4', name: 'The Gadget Hub', description: 'Your one-stop tech shop.', rating: 4.9, distance: '500 m', imageUrl: 'assets/images/shop4.png', products: []),
    Shop(id: '2', name: 'Green Grocers', description: 'Fresh and organic vegetables.', rating: 4.8, distance: '800 m', imageUrl: 'assets/images/shop2.png', products: []),
    Shop(id: '1', name: 'Sabbir\'s Electronics', description: 'Latest gadgets and electronics.', rating: 4.5, distance: '1.2 km', imageUrl: 'assets/images/shop1.png', products: []),
     Shop(id: '7', name: 'Pet Paradise', description: 'All you need for your furry friends.', rating: 4.9, distance: '2.2 km', imageUrl: 'assets/images/shop7.png', products: []),
    Shop(id: '10', name: 'Sweet Treats Bakery', description: 'Delicious cakes, pastries, and more.', rating: 4.9, distance: '900 m', imageUrl: 'assets/images/shop10.png', products: []),
  ];

  double _getClampedResponsiveSize(double contentWidth, {required double baseSize, double minSize = 0, double maxSize = double.infinity}) {
    double scaleFactor = contentWidth / 400.0;
    double size = baseSize * scaleFactor;
    return size.clamp(minSize, maxSize);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double maxWidth = 1200.0;
    final double contentWidth = min(screenWidth, maxWidth);

    int crossAxisCount = (contentWidth / 220).floor().clamp(2, 4);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        width: contentWidth,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: favoriteShops.length,
          itemBuilder: (context, index) {
            return _buildShopGridItem(context, favoriteShops[index], contentWidth);
          },
        ),
      ),
    );
  }

  Widget _buildShopGridItem(BuildContext context, Shop shop, double contentWidth) {
    final titleSize = _getClampedResponsiveSize(contentWidth, baseSize: 14, minSize: 12, maxSize: 16);
    final detailSize = _getClampedResponsiveSize(contentWidth, baseSize: 12, minSize: 10, maxSize: 14);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/shop_detail', arguments: shop),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Hero(
                tag: 'shop_image_${shop.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(shop.imageUrl, fit: BoxFit.cover, errorBuilder: (c, o, s) => const Icon(Icons.storefront)),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleSize), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Text(shop.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: detailSize, color: Colors.black54)),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: detailSize),
                            Text(' ${shop.rating}', style: TextStyle(fontSize: detailSize, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text(shop.distance, style: TextStyle(fontSize: detailSize, color: Colors.black54)),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
