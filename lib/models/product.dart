class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int stock;
  final String? description;

  // Const constructor
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.stock,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      stock: (json['stock'] ?? json['quantity'] ?? 0) as int,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'stock': stock,
      'description': description,
    };
  }
}
