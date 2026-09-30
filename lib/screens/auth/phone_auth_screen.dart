import 'package:flutter/material.dart';

import '../customer/customer_home_screen.dart';
import '../professional/professional_dashboard_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  final String role; // 'customer' or 'professional'
  const PhoneAuthScreen({super.key, required this.role});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.role == 'customer'
              ? 'Customer Sign In'
              : 'Professional Onboarding',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user, size: 64, color: Color(0xFF008751)),
            const SizedBox(height: 16),
            Text(
              _otpSent
                  ? 'Enter 6-digit OTP sent to phone'
                  : 'Enter your Nigerian Phone Number',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _otpSent
                  ? 'Verification code dispatched via SMS.'
                  : 'We will send a secure OTP to verify your account.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 32),
            if (!_otpSent) ...[
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixText: '+234 ',
                  hintText: '8012345678',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_phoneController.text.length < 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a valid Nigerian phone number.',
                        ),
                      ),
                    );
                    return;
                  }
                  setState(() => _otpSent = true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008751),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Send OTP'),
              ),
            ] else ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: '123456',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() => _isLoading = true);
                  Future.delayed(const Duration(seconds: 1), () {
                    if (!mounted) return;
                    setState(() => _isLoading = false);
                    if (widget.role == 'customer') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerHomeScreen(),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProfessionalDashboardScreen(),
                        ),
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008751),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Verify & Continue'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
