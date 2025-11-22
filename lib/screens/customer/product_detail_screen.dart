import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/product.dart';
import '../../theme/app_colors.dart';
import 'payment_options_modal.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  Future<void> _showPaymentOptions(BuildContext context) async {
    final selectedOption = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => const PaymentOptionsModal(),
    );

    if (selectedOption == null || !mounted) return;

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
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: const BackButton(color: AppColors.textDark),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.9),
              child: IconButton(
                icon: const Icon(Icons.favorite_border, color: AppColors.textDark),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(product),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(product),
                  const SizedBox(height: 24),
                  _buildDescription(product),
                  const SizedBox(height: 32),
                  _buildQuantityAndTotal(product),
                  const SizedBox(height: 32),
                  _buildActionButtons(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return Hero(
      tag: 'product_image_${product.id}',
      child: Container(
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(Icons.image_not_supported_outlined, size: 80, color: Colors.grey[400]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '4.8',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${product.stock} in stock',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDescription(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 12),
        Text(
          product.description ?? 'No description available for this product.',
          style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.6),
        ),
      ],
    );
  }

  Widget _buildQuantityAndTotal(Product product) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildQtyBtn(Icons.remove, () => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1)),
              SizedBox(
                width: 40,
                child: Text(
                  '$_quantity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildQtyBtn(Icons.add, () => setState(() => _quantity++)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Total Price', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                '৳ ${(product.price * _quantity).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Icon(icon, size: 20, color: AppColors.textDark),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textDark,
              side: BorderSide(color: Colors.grey[300]!),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Cart'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.4),
            ),
            onPressed: () => _showPaymentOptions(context),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Buy Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
