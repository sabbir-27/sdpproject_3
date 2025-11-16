import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';

class PaymentOptionsModal extends StatelessWidget {
  const PaymentOptionsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // A list of all payment options for a unified grid
    final paymentOptions = {
      'Visa / Mastercard': 'card_payment',
      'bKash': 'bKash',
      'Nagad': 'Nagad',
      'Rocket': 'Rocket',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Payment Method',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: paymentOptions.entries.map((entry) {
                // Determine the icon based on the title
                IconData icon;
                switch (entry.key) {
                  case 'Visa / Mastercard':
                    icon = Icons.credit_card;
                    break;
                  default:
                    icon = Icons.phone_android;
                }
                return _buildPaymentOption(context, entry.key, icon, () => Navigator.pop(context, entry.value));
              }).toList(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildPaymentOption(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Flexible width calculation
    final itemWidth = (screenWidth - (16 * 2) - (12 * 2)) / 3;

    return SizedBox(
      width: itemWidth > 110 ? 110 : itemWidth,
      height: 90,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: AppColors.primary.withOpacity(0.05),
        child: Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 * (title.length % 4)).ms).moveY(begin: 10, end: 0);
  }
}
