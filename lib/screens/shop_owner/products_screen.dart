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
  bool _isGridView = false; // Toggle for List/Grid view
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load products'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: const ShopOwnerDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<ProductProvider>(
              builder: (context, provider, child) {
                final allProducts = provider.products;
                final filteredProducts = _searchQuery.isEmpty
                    ? allProducts
                    : allProducts.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                return CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(),
                    if (allProducts.isEmpty)
                      SliverFillRemaining(child: _buildEmptyState())
                    else ...[
                      _buildSearchBarSliver(),
                      _isGridView 
                          ? _buildProductGrid(filteredProducts)
                          : _buildProductList(filteredProducts),
                    ],
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(context: context, builder: (_) => const AddProductDialog()),
        backgroundColor: AppColors.primary,
        elevation: 4,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      pinned: true,
      floating: false,
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textDark),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: const Text(
          'Inventory',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        background: Container(color: Colors.white),
      ),
      actions: [
        // View Toggle Button
        IconButton(
          icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded, color: AppColors.textGrey),
          tooltip: _isGridView ? 'Switch to List' : 'Switch to Grid',
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.textGrey),
          onPressed: _loadProducts,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  SliverToBoxAdapter _buildSearchBarSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Search products...',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ),
    );
  }

  // --- LIST VIEW ---
  Widget _buildProductList(List<Product> products) {
    if (products.isEmpty && _searchQuery.isNotEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('No products match your search', style: TextStyle(color: Colors.grey))),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildProductListItem(products[index])
                .animate()
                .fadeIn(duration: 400.ms, delay: (30 * index).ms)
                .slideX(begin: 0.1, curve: Curves.easeOut);
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildProductListItem(Product product) {
    final bool inStock = (product.stock) > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showProductDetails(context, product),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(width: 80, height: 80, color: Colors.grey[50], child: Icon(Icons.image_not_supported_outlined, color: Colors.grey[300])),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textDark))),
                          _buildPopupMenu(product),
                        ],
                      ),
                      Text('৳ ${(product.price).toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 8),
                      _buildStockIndicator(inStock, product.stock),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- GRID VIEW ---
  Widget _buildProductGrid(List<Product> products) {
    if (products.isEmpty && _searchQuery.isNotEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('No products match your search', style: TextStyle(color: Colors.grey))),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildProductGridItem(products[index])
                .animate()
                .fadeIn(duration: 400.ms, delay: (30 * index).ms)
                .scaleXY(begin: 0.95, end: 1.0, curve: Curves.easeOut);
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildProductGridItem(Product product) {
    final bool inStock = (product.stock) > 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showProductDetails(context, product),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(color: Colors.grey[50], child: Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.grey[300], size: 40))),
                      ),
                    ),
                    Positioned(top: 8, right: 8, child: _buildPopupMenu(product, isGrid: true)),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark, height: 1.2)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('৳ ${(product.price).toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 4),
                          _buildStockIndicator(inStock, product.stock),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- SHARED WIDGETS ---
  Widget _buildStockIndicator(bool inStock, int stock) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: inStock ? const Color(0xFFE6F4EA) : const Color(0xFFFDE8E8),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            inStock ? 'Stock: $stock' : 'Out of Stock',
            style: TextStyle(
              color: inStock ? const Color(0xFF1E7E34) : const Color(0xFFD32F2F),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenu(Product product, {bool isGrid = false}) {
    return Container(
      decoration: isGrid ? BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ) : null,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.more_horiz, size: 20, color: isGrid ? Colors.black54 : Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (value) {
          if (value == 'edit') {
            showDialog(context: context, builder: (_) => AddProductDialog(product: product));
          } else if (value == 'delete') {
            _confirmDelete(context, product);
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 18), SizedBox(width: 8), Text('Edit')])),
          const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: AppColors.error), SizedBox(width: 8), Text('Delete', style: TextStyle(color: AppColors.error))])),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5))],
            ),
            child: Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.primary.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          const Text('Your Inventory is Empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 8),
          const Text('Add products to start selling', style: TextStyle(fontSize: 15, color: Colors.grey)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => showDialog(context: context, builder: (_) => const AddProductDialog()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add First Product'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to remove "${product.name}"?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Delete'),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted'), backgroundColor: AppColors.success));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete'), backgroundColor: AppColors.error));
      }
    }
  }

  void _showProductDetails(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(product.imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 250, color: Colors.grey[100], child: const Icon(Icons.image, size: 50))),
              ),
              const SizedBox(height: 24),
              Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 8),
              Text('৳ ${product.price}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 16),
              Wrap(spacing: 8, children: [Chip(avatar: Icon(Icons.inventory_2_outlined, size: 16, color: Colors.grey[700]), label: Text('${product.stock} in stock', style: const TextStyle(fontSize: 12)), backgroundColor: Colors.grey[100], side: BorderSide.none)]),
              const SizedBox(height: 24),
              const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(product.description ?? 'No description available.', style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
