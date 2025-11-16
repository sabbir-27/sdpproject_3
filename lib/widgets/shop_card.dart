import 'dart:math';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/shop.dart'; // Import the new model
import '../theme/app_colors.dart';

class ShopCard extends StatelessWidget {
  final Shop shop; // Use the Shop model
  final double contentWidth; // Add contentWidth parameter

  const ShopCard({super.key, required this.shop, required this.contentWidth});

  // Helper for smart, clamped responsive sizing
  double _getClampedResponsiveSize(
    double contentWidth, {
    required double baseSize,
    double minSize = 0,
    double maxSize = double.infinity,
  }) {
    // Using a smaller base width for scaling calculations
    double scaleFactor = contentWidth / 400.0;
    double size = baseSize * scaleFactor;
    return size.clamp(minSize, maxSize);
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizes based on contentWidth
    final cardHeight = _getClampedResponsiveSize(contentWidth, baseSize: 140, minSize: 130, maxSize: 160);
    final imageSize = _getClampedResponsiveSize(contentWidth, baseSize: 100, minSize: 90, maxSize: 120);
    final titleFontSize = _getClampedResponsiveSize(contentWidth, baseSize: 18, minSize: 16, maxSize: 22);
    final bodyFontSize = _getClampedResponsiveSize(contentWidth, baseSize: 14, minSize: 12, maxSize: 16);
    final iconSize = _getClampedResponsiveSize(contentWidth, baseSize: 18, minSize: 16, maxSize: 20);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/shop_detail', arguments: shop),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: cardHeight,
        borderRadius: 24,
        blur: 12,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.3)]),
        borderGradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.5), Colors.white.withOpacity(0.5)]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Use Hero widget for the image animation
              Hero(
                tag: 'shop_image_${shop.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    shop.imageUrl, // Use Image.network for demo pictures
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.storefront, size: imageSize * 0.6),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(shop.name, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: titleFontSize)),
                    Text(shop.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: bodyFontSize)),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: iconSize),
                        Text(' ${shop.rating}', style: TextStyle(fontSize: bodyFontSize)),
                        const Spacer(),
                        Chip(label: Text(shop.distance, style: TextStyle(fontSize: bodyFontSize * 0.9)), visualDensity: VisualDensity.compact),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
