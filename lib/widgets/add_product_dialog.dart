import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../theme/app_colors.dart';

class AddProductDialog extends StatefulWidget {
  final Product? product;

  const AddProductDialog({super.key, this.product});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? imageUrl;
  double? price;
  int? stock;
  String? description;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      name = widget.product!.name;
      imageUrl = widget.product!.imageUrl;
      price = widget.product!.price;
      stock = widget.product!.stock;
      description = widget.product!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Animate(
          effects: [
            FadeEffect(duration: 300.ms),
            ScaleEffect(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
          ],
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      widget.product == null ? 'Add New Product' : 'Edit Product',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 24),
                    _buildTextFormField(
                      initialValue: name,
                      labelText: 'Product Name',
                      icon: Icons.shopping_bag_outlined,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                      onSaved: (value) => name = value,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      initialValue: imageUrl,
                      labelText: 'Image URL',
                      icon: Icons.link,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter an image URL' : null,
                      onSaved: (value) => imageUrl = value,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      initialValue: description,
                      labelText: 'Description',
                      icon: Icons.description_outlined,
                      maxLines: 3,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
                      onSaved: (value) => description = value,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            initialValue: price?.toString(),
                            labelText: 'Price',
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter a price';
                              if (double.tryParse(value) == null) return 'Invalid price';
                              return null;
                            },
                            onSaved: (value) => price = double.tryParse(value!) ?? 0.0,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFormField(
                            initialValue: stock?.toString(),
                            labelText: 'Stock',
                            icon: Icons.inventory_2_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter the stock';
                              if (int.tryParse(value) == null) return 'Invalid number';
                              return null;
                            },
                            onSaved: (value) => stock = int.tryParse(value!) ?? 0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: _isLoading ? const Text('Saving...') : const Text('Save Product'),
                      onPressed: _isLoading ? null : _saveForm,
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      setState(() {
        _isLoading = true;
      });

      try {
        final productProvider = Provider.of<ProductProvider>(context, listen: false);

        final product = Product(
          id: widget.product?.id ?? '', // Server will generate ID for new products
          name: name!,
          price: price!,
          imageUrl: imageUrl!,
          stock: stock!,
          description: description,
        );

        if (widget.product == null) {
          await productProvider.addProduct(product);
        } else {
          await productProvider.updateProduct(product);
        }
        
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save product. Please try again.')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Widget _buildTextFormField({
    String? initialValue,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
