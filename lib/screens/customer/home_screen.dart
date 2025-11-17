import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/shop.dart';
import '../../models/product.dart';
import '../../theme/app_colors.dart';
import '../../widgets/customer_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Shop> shopData = [
    const Shop(id: '1', name: 'Islam grocery', description: 'Latest gadgets and electronics.', rating: 4.5, distance: '1.2 km', imageUrl: 'assets/images/shop1.png', products: [
      Product(id: '1', name: 'Grocery', price: 25.99, imageUrl: 'assets/images/pro1.png', stock: 50),
      Product(id: '2', name: 'Capsicum', price: 45.50, imageUrl: 'assets/images/pro2.png', stock: 25),
    ]),
    const Shop(id: '2', name: 'Green store', description: 'Fresh and organic vegetables.', rating: 4.8, distance: '800 m', imageUrl: 'assets/images/shop2.png', products: [
      Product(id: '3', name: '', price: 30.00, imageUrl: 'assets/images/pro3.png', stock: 0),
      Product(id: '4', name: 'Tomato', price: 89.99, imageUrl: 'assets/images/tomatos.png', stock: 15),
    ]),
    const Shop(id: '3', name: 'Asif store', description: 'A cozy place for book lovers.', rating: 4.7, distance: '2.5 km', imageUrl: 'assets/images/shop3.png', products: []),
    const Shop(id: '4', name: 'Mukta phermacy', description: 'Your one-stop tech shop.', rating: 4.9, distance: '500 m', imageUrl: 'assets/images/shop4.png', products: []),
    const Shop(id: '5', name: 'Ghorer Bazar', description: 'Trendy apparel and accessories.', rating: 4.6, distance: '3.1 km', imageUrl: 'assets/images/shop5.png', products: []),
    const Shop(id: '6', name: 'Home Essentials', description: 'Everything for your home.', rating: 4.8, distance: '1.5 km', imageUrl: 'assets/images/shop6.png', products: []),
    const Shop(id: '7', name: 'Mr D.I.Y', description: 'All you need for your furry friends.', rating: 4.9, distance: '2.2 km', imageUrl: 'assets/images/shop7.png', products: []),
    const Shop(id: '8', name: 'Sarlok Mart', description: 'Handmade crafts and art supplies.', rating: 4.7, distance: '4.0 km', imageUrl: 'assets/images/shop8.png', products: []),
    const Shop(id: '9', name: 'Kids & Family', description: 'Supplements and gear for your workout.', rating: 4.6, distance: '1.8 km', imageUrl: 'assets/images/shop9.png', products: []),
    const Shop(id: '10', name: 'sakib pharmacy', description: 'Delicious cakes, pastries, and more.', rating: 4.9, distance: '900 m', imageUrl: 'assets/images/shop10.png', products: []),
  ];

  final List<Shop> favoriteShops = [
    const Shop(id: '4', name: 'Mukta pharmacy', description: 'Your one-stop tech shop.', rating: 4.9, distance: '500 m', imageUrl: 'assets/images/shop4.png', products: []),
    const Shop(id: '2', name: 'Green store', description: 'Fresh and organic vegetables.', rating: 4.8, distance: '800 m', imageUrl: 'assets/images/shop2.png', products: []),
    const Shop(id: '1', name: 'Islam grocery', description: 'Latest gadgets and electronics.', rating: 4.5, distance: '1.2 km', imageUrl: 'assets/images/shop1.png', products: []),
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

    return Scaffold(
      drawer: const CustomerDrawer(),
      body: Center(
        child: Container(
          width: contentWidth,
          child: CustomScrollView(
            slivers: [
              _buildPremiumAppBar(context, contentWidth),
              _buildFloatingSearchBar(),
              _buildFavoritesSection(context, contentWidth),
              _buildSectionHeaderSliver('All Shops', contentWidth),
              _buildShopGrid(contentWidth),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPremiumAppBar(BuildContext context, double contentWidth) {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      elevation: 4,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white, // Handles icon and text colors in the AppBar
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          "POTHOBONDHU",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(blurRadius: 2, color: Colors.black38)]),
        ),
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Decorative shapes
            Positioned(
              top: -40,
              left: -40,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ).animate().fadeIn(duration: 800.ms),
            Positioned(
              bottom: -60,
              right: -20,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white.withOpacity(0.15),
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
          ],
        ),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: () => Navigator.pushNamed(context, '/qr_scanner')),
        IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () => Navigator.pushNamed(context, '/notifications')),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildFloatingSearchBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverSearchBarDelegate(
        child: Container(
          color: AppColors.gradientStart, // Match app bar color
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: AppColors.textDark),
                hintText: 'Search for shops or products...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 500.ms).moveY(begin: -10, end: 0),
      ),
    );
  }

  Widget _buildSectionHeader(String title, double contentWidth, {bool showSeeAll = false, VoidCallback? onSeeAllTap}) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: _getClampedResponsiveSize(contentWidth, baseSize: 20, minSize: 18, maxSize: 22),
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            if (showSeeAll)
              TextButton(
                onPressed: onSeeAllTap,
                child: Text('See All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: _getClampedResponsiveSize(contentWidth, baseSize: 14, minSize: 12, maxSize: 15))),
              )
          ],
        ),
      );
  }
  SliverToBoxAdapter _buildSectionHeaderSliver(String title, double contentWidth, {bool showSeeAll = false, VoidCallback? onSeeAllTap}) {
    return SliverToBoxAdapter(
      child: _buildSectionHeader(title, contentWidth, showSeeAll: showSeeAll, onSeeAllTap: onSeeAllTap),
    );
  }

  Widget _buildFavoritesSection(BuildContext context, double contentWidth) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Your Favorites', contentWidth, showSeeAll: true, onSeeAllTap: () => Navigator.pushNamed(context, '/favorites')),
          SizedBox(
            height: _getClampedResponsiveSize(contentWidth, baseSize: 150, minSize: 140, maxSize: 180),
            child: ListView.builder(
              primary: false,
              scrollDirection: Axis.horizontal,
              itemCount: favoriteShops.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {
                final shop = favoriteShops[index];
                return _buildFavoriteShopCard(shop, index, contentWidth);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteShopCard(Shop shop, int index, double contentWidth) {
    final cardWidth = _getClampedResponsiveSize(contentWidth, baseSize: 120, minSize: 110, maxSize: 150);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/shop_detail', arguments: shop),
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: 'shop_image_${shop.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    shop.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.store, size: 40)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              shop.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _getClampedResponsiveSize(contentWidth, baseSize: 14, minSize: 12, maxSize: 15),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().slideX(delay: (200 * index).ms, duration: 500.ms, curve: Curves.easeOutCubic).fadeIn();
  }

  Widget _buildShopGrid(double contentWidth) {
    int crossAxisCount = (contentWidth / 220).floor().clamp(2, 4);

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16,0,16,16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildShopGridItem(shopData[index], contentWidth, index);
          },
          childCount: shopData.length,
        ),
      ),
    );
  }

  Widget _buildShopGridItem(Shop shop, double contentWidth, int index) {
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
                  tag: 'shop_grid_image_${shop.id}', // Unique tag for grid
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(shop.imageUrl, fit: BoxFit.cover, errorBuilder: (c, o, s) => const Icon(Icons.storefront)),
                  )),
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
    ).animate().fadeIn(delay: (100 * index).ms, duration: 400.ms).scaleXY(begin: 0.95, end: 1.0, curve: Curves.easeOut).moveY(begin: 20, end: 0);
  }
}

// Delegate for the floating/pinned search bar
class _SliverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverSearchBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 66.0; // Height of the search bar container

  @override
  double get minExtent => 66.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
