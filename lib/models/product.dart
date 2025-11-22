class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int stock;
  final String? description;
  final String category;

  // Const constructor
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.stock,
    this.description,
    this.category = 'General',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
      // Handle both 'stock' and 'quantity' from backend response
      stock: (json['stock'] ?? json['quantity'] ?? 0) as int,
      description: json['description'],
      category: json['category'] ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      // Sending BOTH stock and quantity to satisfy whichever schema is active
      'stock': stock, 
      'quantity': stock,
      'description': description,
      'imageUrl': imageUrl,
      // Extra fields that might be harmless but good for compatibility if schema changes back
      'category': category,
      'image': imageUrl,
    };
  }
}
