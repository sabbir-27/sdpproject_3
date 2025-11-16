import 'product.dart';

class Shop {
  final String id;
  final String name;
  final String description;
  final double rating;
  final String distance;
  final String imageUrl;
  final List<Product> products;

  const Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.distance,
    required this.imageUrl,
    required this.products,
  });
}
