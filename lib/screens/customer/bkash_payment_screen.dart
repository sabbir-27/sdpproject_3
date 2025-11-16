import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';

enum BkashPaymentStep { enterNumber, enterOtp, processing, success }

class BkashPaymentScreen extends StatefulWidget {
  const BkashPaymentScreen({super.key});

  @override
  State<BkashPaymentScreen> createState() => _BkashPaymentScreenState();
}

class _BkashPaymentScreenState extends State<BkashPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  BkashPaymentStep _currentStep = BkashPaymentStep.enterNumber;

  void _proceedToOtp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep = BkashPaymentStep.enterOtp;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your bKash verification code is 123456')),
      );
    }
  }

  Future<void> _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _currentStep = BkashPaymentStep.processing);
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      setState(() => _currentStep = BkashPaymentStep.success);
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('bKash Payment Successful'),
          content: const Text('Your payment has been processed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/customer_home', (route) => false);
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('bKash Payment'),
        backgroundColor: const Color(0xFFE2136E),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    'https://i.postimg.cc/PqYp5T8y/bkash-logo-FBB258-B90-C-seeklogo-com.png', // bKash logo
                    height: 80,
                  ).animate().fadeIn(duration: 600.ms),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: _buildCurrentStepUi(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepUi() {
    switch (_currentStep) {
      case BkashPaymentStep.enterNumber:
        return _buildEnterNumberStep();
      case BkashPaymentStep.enterOtp:
        return _buildEnterOtpStep();
      case BkashPaymentStep.processing:
        return const Center(key: ValueKey('processing'), child: CircularProgressIndicator());
      case BkashPaymentStep.success:
        return const Center(key: ValueKey('success'), child: Icon(Icons.check_circle, color: Colors.green, size: 60));
    }
  }

  Widget _buildEnterNumberStep() {
    return Column(
      key: const ValueKey('enterNumber'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Enter your bKash Account number',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'e.g. 01XXXXXXXXX',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone_android),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter your bKash number';
            if (value.length != 11) return 'Number must be 11 digits';
            return null;
          },
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE2136E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onPressed: _proceedToOtp,
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Widget _buildEnterOtpStep() {
    return Column(
      key: const ValueKey('enterOtp'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Enter the verification code',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        TextFormField(
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 24, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: '- - - - - -',
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            counterText: "",
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter the OTP';
            if (value.length != 6) return 'Code must be 6 digits';
            return null;
          },
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE2136E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onPressed: _processPayment,
          child: const Text('Verify & Pay'),
        ),
      ],
    );
  }
}
