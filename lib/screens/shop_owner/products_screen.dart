import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/add_product_dialog.dart';
import '../../widgets/shop_owner_drawer.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    } catch (error) {
      // _showErrorDialog('Failed to load products. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Consumer<ProductProvider>(
          builder: (context, provider, child) {
            if (provider.products.isEmpty) {
              return const Center(
                child: Text('No products yet. Add one to get started!'),
              );
            }
            return RefreshIndicator(
              onRefresh: _loadProducts,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
                itemCount: provider.products.length,
                itemBuilder: (context, index) {
                  return _buildProductListItem(context, provider.products[index])
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                      .slideY(begin: 0.2, curve: Curves.easeOut);
                },
              ),
            );
          },
        ),
      ),
    );
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
                  _deleteProduct(product.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(String id) async {
    try {
      await Provider.of<ProductProvider>(context, listen: false).deleteProduct(id);
    } catch (error) {
      _showErrorDialog('Failed to delete product.');
    }
  }

  Widget _buildProductListItem(BuildContext context, Product product) {
    final bool inStock = (product.stock) > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showProductDetails(context, product),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl, // fallback
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey[200],
                      child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${(product.price).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(
                          inStock ? 'In Stock (${product.stock})' : 'Out of Stock',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: inStock ? Colors.green.shade600 : Colors.red.shade600,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Edit',
                      onPressed: () => showDialog(
                          context: context,
                          builder: (_) => AddProductDialog(product: product)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      tooltip: 'Delete',
                      onPressed: () => _confirmDelete(context, product),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
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
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(product.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(
                      '\$${product.price}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Chip(
                      label: Text(
                          (product.stock) > 0
                              ? 'In Stock (${product.stock})'
                              : 'Out of Stock',
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor:
                      (product.stock) > 0 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 20),
                    Text(product.description ?? 'No description',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(height: 1.5)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
