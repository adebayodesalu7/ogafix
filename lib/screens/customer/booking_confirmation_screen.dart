import 'package:flutter/material.dart';

import 'payment_escrow_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String professionalName;
  final String serviceTitle;
  final double quoteAmount;
  final String scheduledDate;

  const BookingConfirmationScreen({
    super.key,
    required this.professionalName,
    required this.serviceTitle,
    required this.quoteAmount,
    required this.scheduledDate,
  });

  @override
  Widget build(BuildContext context) {
    final double platformFee = quoteAmount * 0.05; // 5% service platform fee
    final double totalAmount = quoteAmount + platformFee;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Booking Confirmation',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review Booking Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryRow('Professional', professionalName),
                  const Divider(color: Colors.grey),
                  _buildSummaryRow('Service', serviceTitle),
                  const Divider(color: Colors.grey),
                  _buildSummaryRow('Scheduled Date', scheduledDate),
                  const Divider(color: Colors.grey),
                  _buildSummaryRow(
                    'Labour / Quote',
                    '₦${quoteAmount.toStringAsFixed(2)}',
                  ),
                  const Divider(color: Colors.grey),
                  _buildSummaryRow(
                    'Platform Fee (5%)',
                    '₦${platformFee.toStringAsFixed(2)}',
                  ),
                  const Divider(color: Colors.grey),
                  _buildSummaryRow(
                    'Total Amount',
                    '₦${totalAmount.toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF00331A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF008751)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cancellation & Refund Terms',
                    style: TextStyle(
                      color: Color(0xFF008751),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'You can cancel free of charge up to 2 hours before scheduled arrival time. Funds held in escrow are fully protected.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentEscrowScreen(
                        totalAmount: totalAmount,
                        professionalName: professionalName,
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
                child: const Text(
                  'Proceed to Secure Payment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.white : Colors.grey,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? const Color(0xFF008751) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
