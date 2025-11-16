import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(id: '1', name: 'Wireless Mouse', price: 25.99, imageUrl: 'assets/images/pro1.png', stock: 50, description: 'A comfortable and reliable wireless mouse.'),
    Product(id: '2', name: 'Bluetooth Keyboard', price: 45.50, imageUrl: 'assets/images/pro2.png', stock: 25, description: 'A slim and stylish Bluetooth keyboard.'),
    Product(id: '3', name: 'USB-C Hub', price: 30.00, imageUrl: 'assets/images/pro3.png', stock: 0, description: 'A versatile USB-C hub with multiple ports.'),
    Product(id: '4', name: '4K Webcam', price: 89.99, imageUrl: 'assets/images/pro4.png', stock: 15, description: 'A high-quality 4K webcam for streaming and video calls.'),
    Product(id: '5', name: 'Gaming Headset', price: 65.00, imageUrl: 'assets/images/pro5.png', stock: 5, description: 'A comfortable gaming headset with immersive sound.'),
    Product(id: '6', name: 'Mechanical Keyboard', price: 120.00, imageUrl: 'assets/images/pro6.png', stock: 10, description: 'A durable mechanical keyboard with satisfying clicks.'),
    Product(id: '7', name: 'Monitor Stand', price: 35.00, imageUrl: 'assets/images/pro7.png', stock: 30, description: 'An ergonomic monitor stand with adjustable height.'),
    Product(id: '8', name: 'Laptop Sleeve', price: 19.99, imageUrl: 'assets/images/pro8.png', stock: 0, description: 'A protective sleeve for your laptop.'),
  ];

  List<Product> get products => _products;

  void addProduct(Product product) {
    final newProduct = Product(
      id: (_products.length + 1).toString(),
      name: product.name,
      price: product.price,
      imageUrl: product.imageUrl,
      stock: product.stock,
      description: product.description,
    );
    _products.add(newProduct);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
