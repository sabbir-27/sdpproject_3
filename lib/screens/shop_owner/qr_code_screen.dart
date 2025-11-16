import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shop_owner_drawer.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  // In a real app, this would be your shop's unique ID or URL.
  final String shopData = "shop_id_12345";

  @override
  Widget build(BuildContext context) {
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
                    QrImageView(
                      data: shopData,
                      version: QrVersions.auto,
                      size: 250.0,
                      embeddedImage: const AssetImage('assets/images/logo.png'), // Optional: Add your shop logo
                      embeddedImageStyle: const QrEmbeddedImageStyle(
                        size: Size(40, 40),
                      ),
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
