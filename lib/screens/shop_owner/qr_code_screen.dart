import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shop_owner_drawer.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final String shopName = authProvider.username ?? "Your Shop";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Shop QR Code'),
        backgroundColor: AppColors.primary,
      ),
      drawer: const ShopOwnerDrawer(),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      shopName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 16),
                    // Removed QR Code and replaced with the image directly
                    Image.asset(
                      'assets/images/sabbir.jpg',
                      width: 320,
                      height: 320,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 100),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Scan this code to visit our shop!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
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
}
