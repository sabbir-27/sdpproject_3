import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';

class CardPaymentScreen extends StatefulWidget {
  const CardPaymentScreen({super.key});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  late AnimationController _flipAnimationController;
  late Animation<double> _flipAnimation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _flipAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(_flipAnimationController)
      ..addListener(() {
        setState(() {});
      });

    _cvcController.addListener(() {
      if (_cvcController.text.isNotEmpty && !_isFlipped) {
        _flipAnimationController.forward();
        _isFlipped = true;
      } else if (_cvcController.text.isEmpty && _isFlipped) {
        _flipAnimationController.reverse();
        _isFlipped = false;
      }
    });
  }

  Future<void> _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);
      await Future.delayed(const Duration(seconds: 3));
      setState(() => _isProcessing = false);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Successful'),
          content: const Text('Your payment has been processed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvcController.dispose();
    _flipAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Payment'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500), // Constrain width for larger screens
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildCreditCard(),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCardNumberField(),
                      const SizedBox(height: 16),
                      _buildCardholderNameField(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildExpiryDateField()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildCvcField()),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _isProcessing
                          ? const Center(child: CircularProgressIndicator())
                          : _buildPayNowButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreditCard() {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(pi * _flipAnimation.value),
      alignment: Alignment.center,
      child: _flipAnimation.value < 0.5 ? _buildCardFront() : _buildCardBack(),
    );
  }

  Widget _buildCardFront() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF00897B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(alignment: Alignment.topRight, child: Icon(Icons.contactless, color: Colors.white, size: 30)),
            const Spacer(),
            Text(
              _cardNumberController.text.isEmpty ? 'XXXX XXXX XXXX XXXX' : _cardNumberController.text,
              style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Card Holder', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(
                      _cardHolderController.text.isEmpty ? 'Your Name' : _cardHolderController.text,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Expires', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(
                      _expiryDateController.text.isEmpty ? 'MM/YY' : _expiryDateController.text,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Transform(
      transform: Matrix4.identity()..rotateY(pi), // Flip the back
      alignment: Alignment.center,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFEEEEEE),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(height: 40, color: Colors.black87),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(width: double.infinity, height: 30, color: Colors.white),
                    const SizedBox(height: 4),
                    Text(_cvcController.text, style: const TextStyle(color: Colors.black, letterSpacing: 2, fontStyle: FontStyle.italic)),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }


  TextFormField _buildCardholderNameField() {
    return TextFormField(
      controller: _cardHolderController,
      onChanged: (value) => setState(() {}),
      decoration: const InputDecoration(
        labelText: 'Cardholder Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter the cardholder name' : null,
    );
  }

  TextFormField _buildCardNumberField() {
    return TextFormField(
      controller: _cardNumberController,
      onChanged: (value) => setState(() {}),
      decoration: const InputDecoration(
        labelText: 'Card Number',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.credit_card),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        _CardNumberInputFormatter(),
      ],
      validator: (value) {
        if (value!.isEmpty) return 'Please enter your card number';
        if (value.replaceAll(' ', '').length != 16) return 'Card number must be 16 digits';
        return null;
      },
    );
  }

  TextFormField _buildExpiryDateField() {
    return TextFormField(
      controller: _expiryDateController,
      onChanged: (value) => setState(() {}),
      decoration: const InputDecoration(labelText: 'MM/YY', border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        _CardExpiryInputFormatter(),
      ],
      validator: (value) {
        if (value!.isEmpty) return 'Enter expiry date';
        if (value.length != 5) return 'Invalid date format';
        return null;
      },
    );
  }

  TextFormField _buildCvcField() {
    return TextFormField(
      controller: _cvcController,
      decoration: const InputDecoration(labelText: 'CVC', border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
      validator: (value) => value!.length < 3 ? 'Enter a valid CVC' : null,
    );
  }

  ElevatedButton _buildPayNowButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: _processPayment,
      child: const Text('Pay Now'),
    );
  }
}

// Input formatters
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) buffer.write('  ');
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      if (i == 1 && i != newText.length - 1) buffer.write('/');
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}
