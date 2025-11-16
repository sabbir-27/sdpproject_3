import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/shop.dart';
import '../../theme/app_colors.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isScanning = true;

  void _simulateScan() {
    if (!mounted) return;

    setState(() {
      _isScanning = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('QR Code Scanned Successfully!')),
    );

    // Dummy shop data for demonstration
    const Shop scannedShop = Shop(
        id: 'qr_scanned_shop',
        name: 'Scanned Pop-Up Shop',
        description: 'A special shop found via QR code!',
        rating: 5.0,
        distance: '10 m',
        imageUrl: 'https://picsum.photos/seed/qrshop/200',
        products: [], // Added an empty list for products
    );

    // Navigate to shop detail screen after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context); // Pop the scanner screen
        Navigator.pushNamed(context, '/shop_detail', arguments: scannedShop);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: AppColors.primary,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Placeholder for camera view
          Container(
            color: Colors.black,
            child: const Center(
              child: Icon(Icons.qr_code_scanner, color: Colors.white54, size: 150),
            ),
          ),
          // Scanning animation overlay
          if (_isScanning)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
              width: 250,
              height: 250,
            ),
          Positioned(
            bottom: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: _simulateScan,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Simulate Scan'),
            ),
          )
        ],
      ),
    );
  }
}
