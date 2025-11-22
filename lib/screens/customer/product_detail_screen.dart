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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      extendBodyBehindAppBar: !isWide,
      appBar: AppBar(
        backgroundColor: isWide ? Colors.white : Colors.transparent,
        elevation: isWide ? 1 : 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isWide ? Colors.transparent : Colors.white.withOpacity(0.7),
            child: BackButton(color: isWide ? Colors.black : Colors.black),
          ),
        ),
        title: isWide ? Text(product.name, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)) : null,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: isWide ? Colors.transparent : Colors.white.withOpacity(0.7),
              child: IconButton(
                icon: const Icon(Icons.share, color: Colors.black),
                onPressed: () {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: isWide ? Colors.transparent : Colors.white.withOpacity(0.7),
              child: IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: isWide 
          ? _buildWideLayout(product) 
          : _buildMobileLayout(product),
      bottomNavigationBar: isWide 
          ? null 
          : _buildBottomBar(context),
    );
  }

  Widget _buildMobileLayout(Product product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(product, isWide: false),
          _buildProductInfo(product),
        ],
      ),
    );
  }

  Widget _buildWideLayout(Product product) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: _buildProductImage(product, isWide: true),
            ),
            const SizedBox(width: 32),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductInfo(product, isWide: true),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF2BCDB5),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextButton(
                              onPressed: () => _showPaymentOptions(context),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFF57224),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Buy Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
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
    );
  }

  Widget _buildProductImage(Product product, {required bool isWide}) {
    return Container(
      color: Colors.white,
      child: AspectRatio(
        aspectRatio: isWide ? 1.2 : 1.0,
        child: Image.network(
          product.imageUrl,
          fit: isWide ? BoxFit.contain : BoxFit.cover,
          errorBuilder: (c, e, s) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(Product product, {bool isWide = false}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isWide) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '৳ ${product.price}',
                  style: const TextStyle(
                    color: Color(0xFFF57224),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.favorite_border, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: isWide ? 24 : 16, color: Colors.black87, fontWeight: isWide ? FontWeight.bold : FontWeight.normal),
          ),
          if (isWide) ...[
            const SizedBox(height: 16),
            Text(
              '৳ ${product.price}',
              style: const TextStyle(
                color: Color(0xFFF57224),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Color(0xFFF57224)),
              const Icon(Icons.star, size: 14, color: Color(0xFFF57224)),
              const Icon(Icons.star, size: 14, color: Color(0xFFF57224)),
              const Icon(Icons.star, size: 14, color: Color(0xFFF57224)),
              const Icon(Icons.star_half, size: 14, color: Color(0xFFF57224)),
              const SizedBox(width: 4),
              const Text('(25)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const Spacer(),
              const Icon(Icons.share, size: 18, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          
          // Description Section (Moved UP)
          const SizedBox(height: 8),
          const Text(
            'Description',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            product.description ?? 'No description available.',
            style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 16),
          const Divider(),

          // Quantity and Total Section
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quantity', style: TextStyle(fontSize: 14, color: Colors.grey)),
              Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: const Icon(Icons.remove, size: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('$_quantity'),
                  ),
                  InkWell(
                    onTap: () => setState(() => _quantity++),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: const Icon(Icons.add, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Total Price Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Price', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text(
                '৳ ${(product.price * _quantity).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFF57224)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.store, color: Colors.grey), Text('Store', style: TextStyle(fontSize: 10, color: Colors.grey))],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.chat_bubble_outline, color: Colors.grey), Text('Chat', style: TextStyle(fontSize: 10, color: Colors.grey))],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFF2BCDB5),
              child: TextButton(
                onPressed: () {},
                child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFFF57224),
              child: TextButton(
                onPressed: () => _showPaymentOptions(context),
                child: const Text('Buy Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
