import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'auth_provider.dart';

class ProductProvider with ChangeNotifier {
  final AuthProvider? authProvider;
  List<Product> _products = [];

  ProductProvider(this.authProvider, this._products);

  List<Product> get products => _products;

  String? get token => authProvider?.token;

  // IMPORTANT: Replace with your actual server URL
  final String _baseUrl = 'http://localhost:3000';

  Future<void> fetchProducts() async {
    final url = Uri.parse('$_baseUrl/products');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final List<dynamic> productData = json.decode(response.body);
        _products = productData.map((data) => Product.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('$_baseUrl/products');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 201) {
        final newProduct = Product.fromJson(json.decode(response.body));
        _products.add(newProduct);
        notifyListeners();
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    final url = Uri.parse('$_baseUrl/products/${product.id}');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 200) {
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = product;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('$_baseUrl/products/$id');
    try {
      final response = await http.delete(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        _products.removeWhere((p) => p.id == id);
        notifyListeners();
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
