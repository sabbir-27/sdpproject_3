class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int stock;
  final String? description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.stock,
    this.description,
  });
}
