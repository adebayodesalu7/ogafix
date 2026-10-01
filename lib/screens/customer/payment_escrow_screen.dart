import 'package:flutter/material.dart';

import 'job_tracking_screen.dart';

class PaymentEscrowScreen extends StatefulWidget {
  final double totalAmount;
  final String professionalName;

  const PaymentEscrowScreen({
    super.key,
    required this.totalAmount,
    required this.professionalName,
  });

  @override
  State<PaymentEscrowScreen> createState() => _PaymentEscrowScreenState();
}

class _PaymentEscrowScreenState extends State<PaymentEscrowScreen> {
  String _selectedGateway = 'Paystack Escrow';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Secure Escrow Payment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF00331A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF008751)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔒 Secure Escrow Vault',
                    style: TextStyle(
                      color: Color(0xFF008751),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Funds are safely held in escrow and only released to the professional upon your final sign-off.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Amount to Fund: ₦${widget.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Payment Gateway',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            RadioListTile<String>(
              title: const Text(
                'Paystack Secure Checkout',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Card, Bank Transfer, USSD',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              value: 'Paystack Escrow',
              groupValue: _selectedGateway,
              activeColor: const Color(0xFF008751),
              onChanged: (val) =>
                  setState(() => _selectedGateway = val ?? _selectedGateway),
            ),
            RadioListTile<String>(
              title: const Text(
                'Flutterwave Checkout',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Cards, Mobile Money, Bank',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              value: 'Flutterwave Escrow',
              groupValue: _selectedGateway,
              activeColor: const Color(0xFF008751),
              onChanged: (val) =>
                  setState(() => _selectedGateway = val ?? _selectedGateway),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        await Future.delayed(const Duration(seconds: 2));
                        if (!mounted) return;
                        setState(() => _isLoading = false);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Escrow funded successfully! Job tracking initiated.',
                            ),
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobTrackingScreen(
                              professionalName: widget.professionalName,
                              serviceTitle: 'Plumbing & Repair',
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008751),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Pay ₦${widget.totalAmount.toStringAsFixed(2)} via $_selectedGateway',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
