import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../theme/app_colors.dart';
import 'payment_options_modal.dart'; // Import the new modal

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  // Refactored method to correctly handle navigation
  Future<void> _showPaymentOptions(BuildContext context) async {
    final selectedOption = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => const PaymentOptionsModal(),
    );

    if (selectedOption == null || !mounted) return; // Modal was dismissed or widget is no longer in the tree

    // Handle navigation based on the returned value from the modal
    switch (selectedOption) {
      case 'card_payment':
        Navigator.pushNamed(context, '/card_payment');
        break;
      case 'bKash':
        Navigator.pushNamed(context, '/bkash_payment');
        break;
      case 'Nagad':
        Navigator.pushNamed(context, '/nagad_payment');
        break;
      case 'Rocket':
        Navigator.pushNamed(context, '/rocket_payment');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, overflow: TextOverflow.ellipsis, maxLines: 1),
        backgroundColor: AppColors.primary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 700) {
            return _buildWideLayout(context, product);
          } else {
            return _buildNarrowLayout(context, product);
          }
        },
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, Product product) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.all(32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _buildImageGallery(product)),
            const SizedBox(width: 32),
            Expanded(flex: 2, child: _buildProductDetailsColumn(context, product, isWide: true)),
          ],
        ),
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context, Product product) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildImageGallery(product),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildProductDetailsColumn(context, product, isWide: false),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(Product product) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1.0, // Square image or whatever fits best
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if network fails (e.g., it's an asset path or invalid URL)
            return Image.asset(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductDetailsColumn(BuildContext context, Product product, {required bool isWide}) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      // Makes the details column scrollable on wide screens if content overflows
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: isWide ? textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold) : textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            '৳ ${product.price}',
            style: isWide ? textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold) : textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildRating(context, 4.8, 210),
          const SizedBox(height: 32),
          Text('Description', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(product.description ?? 'No description available.', style: textTheme.bodyLarge?.copyWith(height: 1.5)),
          const SizedBox(height: 32),
          _buildQuantitySelector(),
          const SizedBox(height: 32),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Quantity:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove), 
                onPressed: () => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1)
              ),
              Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add), 
                onPressed: () => setState(() => _quantity++)
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () { /* TODO: Implement Add to Cart logic */ },
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Add to Cart'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _showPaymentOptions(context),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Buy Now'),
          ),
        ),
      ],
    );
  }

  Widget _buildRating(BuildContext context, double rating, int reviewCount) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return const Icon(Icons.star, color: Colors.amber, size: 24);
          } else if (index < rating) {
            return const Icon(Icons.star_half, color: Colors.amber, size: 24);
          } else {
            return const Icon(Icons.star_border, color: Colors.amber, size: 24);
          }
        }),
        const SizedBox(width: 8),
        Text('$rating ($reviewCount Reviews)', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
