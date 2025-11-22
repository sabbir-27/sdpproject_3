import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../models/shop.dart';
import '../../providers/product_provider.dart';
import '../../theme/app_colors.dart';

class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({super.key});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  
  // Removed initState as requested

  // Helper for smart, clamped responsive sizing
  double _getClampedResponsiveSize(
    double contentWidth,
    {
      required double baseSize,
      double minSize = 0,
      double maxSize = double.infinity,
  }) {
    double scaleFactor = contentWidth / 375.0; // Base width for scaling
    double size = baseSize * scaleFactor;
    return size.clamp(minSize, maxSize);
  }

  @override
  Widget build(BuildContext context) {
    final shop = ModalRoute.of(context)!.settings.arguments as Shop;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const double maxWidth = 1200.0;
    final double contentWidth = min(screenWidth, maxWidth);

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: maxWidth),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
          ),
          child: CustomScrollView(
            slivers: <Widget>[
              _buildSliverAppBar(shop, screenHeight),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: contentWidth * 0.05, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About the Shop',
                        style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        shop.description,
                        style: textTheme.bodyLarge?.copyWith(color: AppColors.textDark.withAlpha(204)),
                      ),
                      const SizedBox(height: 16),
                      _buildShopRating(context, contentWidth),
                      const SizedBox(height: 24),
                      _buildActionButtons(context, contentWidth),
                      const SizedBox(height: 24),
                      Text(
                        'Products',
                        style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                    ],
                  ),
                ),
              ),
              _buildProductGrid(contentWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopRating(BuildContext context, double contentWidth) {
    double rating = 4.5;
    int reviewCount = 125;
    final textTheme = Theme.of(context).textTheme;

    List<Widget> stars = List.generate(5, (index) {
      final starSize = _getClampedResponsiveSize(contentWidth, baseSize: 22, minSize: 18, maxSize: 28);
      if (index < rating.floor()) {
        return Icon(Icons.star, color: Colors.amber, size: starSize);
      } else if (index < rating) {
        return Icon(Icons.star_half, color: Colors.amber, size: starSize);
      } else {
        return Icon(Icons.star_border, color: Colors.amber, size: starSize);
      }
    });

    return Row(
      children: [
        ...stars,
        const SizedBox(width: 8),
        Text(
          '$rating ($reviewCount Reviews)',
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: _getClampedResponsiveSize(contentWidth, baseSize: 14, minSize: 12, maxSize: 16)),
        )
      ],
    );
  }

  SliverAppBar _buildSliverAppBar(Shop shop, double screenHeight) {
    return SliverAppBar(
      expandedHeight: screenHeight * 0.3,
      pinned: true,
      elevation: 4.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          shop.name,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(blurRadius: 2.0, color: Colors.black45)],
          ),
        ),
        background: Hero(
          tag: 'shop_image_${shop.id}',
          child: Image.asset(
            shop.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.store, size: 100, color: Colors.grey)),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, double contentWidth) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      alignment: WrapAlignment.end,
      children: [
        _actionButton(context, icon: Icons.chat_bubble_outline, label: 'Chat', onPressed: () => Navigator.pushNamed(context, '/customer_chat'), contentWidth: contentWidth),
        _actionButton(context, icon: Icons.favorite_border, label: 'Follow', isOutlined: true, onPressed: () {}, contentWidth: contentWidth),
        _actionButton(context, icon: Icons.report_problem_outlined, label: 'Complaint', isOutlined: true, onPressed: () => Navigator.pushNamed(context, '/file_complaint'), contentWidth: contentWidth),
        PopupMenuButton<String>(
          onSelected: (value) {
            Navigator.pushNamed(context, value);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: '/card_payment',
              child: Text('Pay with Card'),
            ),
            const PopupMenuItem<String>(
              value: '/bkash_payment',
              child: Text('Pay with bKash'),
            ),
            const PopupMenuItem<String>(
              value: '/nagad_payment',
              child: Text('Pay with Nagad'),
            ),
          ],
          child: Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12.0),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _getClampedResponsiveSize(contentWidth, baseSize: 16, minSize: 12, maxSize: 24),
                vertical: _getClampedResponsiveSize(contentWidth, baseSize: 10, minSize: 8, maxSize: 14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.payment, color: Colors.white),
                  const SizedBox(width: 8.0),
                  Text(
                    'Payment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _getClampedResponsiveSize(contentWidth, baseSize: 14, minSize: 12, maxSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(BuildContext context, {required IconData icon, required String label, bool isOutlined = false, required VoidCallback onPressed, required double contentWidth}) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: EdgeInsets.symmetric(
              horizontal: _getClampedResponsiveSize(contentWidth, baseSize: 16, minSize: 12, maxSize: 24),
              vertical: _getClampedResponsiveSize(contentWidth, baseSize: 10, minSize: 8, maxSize: 14),
            ),
            textStyle: TextStyle(fontSize: _getClampedResponsiveSize(contentWidth, baseSize: 14, minSize: 12, maxSize: 16)),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: _getClampedResponsiveSize(contentWidth, baseSize: 16, minSize: 12, maxSize: 24),
              vertical: _getClampedResponsiveSize(contentWidth, baseSize: 10, minSize: 8, maxSize: 14),
            ),
            textStyle: TextStyle(fontSize: _getClampedResponsiveSize(contentWidth, baseSize: 14, minSize: 12, maxSize: 16)),
          );

    return isOutlined
        ? OutlinedButton.icon(icon: Icon(icon), label: Text(label), style: buttonStyle, onPressed: onPressed)
        : ElevatedButton.icon(icon: Icon(icon), label: Text(label), style: buttonStyle, onPressed: onPressed);
  }

    Widget _buildProductGrid(double contentWidth) {
    // Use Consumer to get products from the provider
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        final products = productProvider.products;
        
        // Determine the number of columns based on content width
        int crossAxisCount;
        if (contentWidth >= 900) {
          crossAxisCount = 4;
        } else if (contentWidth >= 600) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }

        // Adjust aspect ratio for a pleasant card look
        final double childAspectRatio = contentWidth < 600 ? 0.7 : 0.8;

        if (products.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: Text("No products available from this shop.")),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildProductCard(context, products[index], contentWidth);
              },
              childCount: products.length,
            ),
          ),
        );
      }
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, double contentWidth) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/product_detail', arguments: product),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(_getClampedResponsiveSize(contentWidth, baseSize: 8, minSize: 6, maxSize: 12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: _getClampedResponsiveSize(contentWidth, baseSize: 15, minSize: 13, maxSize: 18)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '৳ ${product.price}',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: _getClampedResponsiveSize(contentWidth, baseSize: 14, minSize: 12, maxSize: 17)),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontSize: _getClampedResponsiveSize(contentWidth, baseSize: 13, minSize: 12, maxSize: 15)),
                        ),
                        onPressed: () {
                          // TODO: Implement Add to Cart logic
                        },
                        child: const Text('Add to Cart'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
