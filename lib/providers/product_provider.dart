import 'dart:convert';
import 'dart:io'; // Import dart:io for Platform check
import 'package:flutter/foundation.dart'; // Import for kIsWeb
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'auth_provider.dart';

class ProductProvider with ChangeNotifier {
  final AuthProvider? authProvider;
  List<Product> _products = [];

  ProductProvider(this.authProvider, [this._products = const []]);

  List<Product> get products => _products;

  String? get token => authProvider?.token;

  // Determine Base URL based on Platform
  String get _baseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000'; // iOS, Windows, macOS
  }

  // -----------------------------
  // FETCH ALL PRODUCTS
  // -----------------------------
  Future<void> fetchProducts() async {
    final url = Uri.parse('$_baseUrl/products');
    try {
      final response = await http.get(url, headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        // Fix: Decode as dynamic because it could be List or Map
        final dynamic responseData = json.decode(response.body);
        
        List<dynamic> productData = [];
        
        if (responseData is List) {
          productData = responseData;
        } else if (responseData is Map && responseData['data'] != null) {
          productData = responseData['data'];
        } else if (responseData is Map) {
           // Fallback if it's a map but no 'data' key (unlikely if list expected)
           // You might want to log this
        }
            
        _products = productData.map((data) => Product.fromJson(data)).toList();
        notifyListeners();
      } else {
        print('Failed to load products: ${response.statusCode} ${response.body}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  // -----------------------------
  // ADD NEW PRODUCT
  // -----------------------------
  Future<void> addProduct(Product product) async {
    final url = Uri.parse('$_baseUrl/products');
    try {
      print('Adding product to $url');
      final body = json.encode(product.toJson());
      print('Request Body: $body'); // Debug print

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        final dynamic responseData = json.decode(response.body);
        // Handle wrapped 'data' or direct object
        final productJson = (responseData is Map && responseData.containsKey('data')) 
            ? responseData['data'] 
            : responseData;
            
        final newProduct = Product.fromJson(productJson);
        _products.add(newProduct);
        notifyListeners();
      } else {
        print('Failed to add product: ${response.statusCode} ${response.body}');
        // Throw detailed error message to display in UI
        throw Exception('Failed to add product: ${response.body}');
      }
    } catch (e) {
      print('Error adding product: $e');
      // Re-throw so UI can catch it
      throw e;
    }
  }

  // -----------------------------
  // UPDATE PRODUCT
  // -----------------------------
  Future<void> updateProduct(Product product) async {
    final url = Uri.parse('$_baseUrl/products/${product.id}');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        final productJson = (responseData is Map && responseData.containsKey('data')) 
            ? responseData['data'] 
            : responseData;
            
        final updatedProduct = Product.fromJson(productJson);
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = updatedProduct;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // -----------------------------
  // DELETE PRODUCT
  // -----------------------------
  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('$_baseUrl/products/$id');
    try {
      final response = await http.delete(url, headers: {
        if (token != null) 'Authorization': 'Bearer $token',
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
