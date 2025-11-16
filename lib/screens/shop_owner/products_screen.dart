import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/add_product_dialog.dart';
import '../../widgets/shop_owner_drawer.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double maxWidth = 1200.0;
    final double contentWidth = min(screenWidth, maxWidth);

    int crossAxisCount;
    if (contentWidth > 1000) {
      crossAxisCount = 4;
    } else if (contentWidth > 600) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.gradientStart.withAlpha(204),
      ),
      drawer: const ShopOwnerDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(context: context, builder: (_) => const AddProductDialog()),
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Container(
          width: contentWidth,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
          ),
          child: Consumer<ProductProvider>(
            builder: (context, provider, child) {
              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: provider.products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(context, provider.products[index], contentWidth, index);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

  void _confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${product.name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Provider.of<ProductProvider>(context, listen: false).deleteProduct(product.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, double contentWidth, int index) {
    final bool inStock = product.stock > 0;
    final titleSize = _getClampedResponsiveSize(contentWidth, baseSize: 16, minSize: 14, maxSize: 18);
    final priceSize = _getClampedResponsiveSize(contentWidth, baseSize: 14, minSize: 12, maxSize: 16);
    final chipFontSize = _getClampedResponsiveSize(contentWidth, baseSize: 10, minSize: 9, maxSize: 11);
    final iconSize = _getClampedResponsiveSize(contentWidth, baseSize: 20, minSize: 18, maxSize: 22);

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showProductDetails(context, product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.grey[200],
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: AppColors.accentPolice),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleSize),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${product.price}', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600, fontSize: priceSize)),
                        Chip(
                          label: Text(inStock ? 'In Stock (${product.stock})' : 'Out of Stock', style: TextStyle(color: Colors.white, fontSize: chipFontSize)),
                          backgroundColor: inStock ? Colors.green : Colors.red,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(icon: Icon(Icons.edit, size: iconSize), onPressed: () => showDialog(context: context, builder: (_) => AddProductDialog(product: product))),
                        IconButton(
                          icon: Icon(Icons.delete, size: iconSize, color: AppColors.accentPolice),
                          onPressed: () => _confirmDelete(context, product),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).scaleXY(begin: 0.9, end: 1.0, curve: Curves.easeOut);
  }

  void _showProductDetails(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(product.imageUrl, fit: BoxFit.cover, height: 200, width: double.infinity),
                    ),
                    const SizedBox(height: 24),
                    Text(product.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('\$${product.price}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Chip(
                      label: Text(product.stock > 0 ? 'In Stock (${product.stock})' : 'Out of Stock', style: const TextStyle(color: Colors.white)),
                      backgroundColor: product.stock > 0 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 20),
                    Text('This is a placeholder description for ${product.name}. In a real app, this would be a full, detailed description of the product, its features, and specifications.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  double _getClampedResponsiveSize(double contentWidth, {required double baseSize, double minSize = 0, double maxSize = double.infinity}) {
    double scaleFactor = contentWidth / 400.0;
    double size = baseSize * scaleFactor;
    return size.clamp(minSize, maxSize);
  }
