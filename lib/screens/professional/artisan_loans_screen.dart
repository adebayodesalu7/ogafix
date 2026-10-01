import 'package:flutter/material.dart';

class ArtisanLoansScreen extends StatefulWidget {
  const ArtisanLoansScreen({super.key});

  @override
  State<ArtisanLoansScreen> createState() => _ArtisanLoansScreenState();
}

class _ArtisanLoansScreenState extends State<ArtisanLoansScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedPurpose = 'Generator Upgrade / Replacement';
  bool _isSubmitted = false;

  final List<String> _purposes = [
    'Generator Upgrade / Replacement',
    'Professional Tools & Diagnostic Kits',
    'Working Capital / Shop Rent',
    'Vehicle / Transport Maintenance',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Artisan Micro-Loans & Equipment Financing',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF00331A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF008751)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💳 FindAPro Financial Inclusion',
                    style: TextStyle(
                      color: Color(0xFF008751),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Get instant working capital and equipment financing of up to ₦500,000 based on your completed jobs rating and NIN verification level.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Loan Purpose',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedPurpose,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
              ),
              items: _purposes.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(p, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (val) =>
                  setState(() => _selectedPurpose = val ?? _selectedPurpose),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Requested Amount (₦ 50,000 - ₦ 500,000)',
                labelStyle: const TextStyle(color: Colors.grey),
                prefixText: '₦ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 36),
            if (!_isSubmitted)
              ElevatedButton(
                onPressed: () {
                  final amount =
                      double.tryParse(_amountController.text.trim()) ?? 0.0;
                  if (amount < 10000) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a valid loan amount (Minimum ₦10,000).',
                        ),
                      ),
                    );
                    return;
                  }
                  setState(() => _isSubmitted = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Loan application submitted! Partner lender review in progress.',
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
                  'Submit Instant Financing Application',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            if (_isSubmitted)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF008751)),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Color(0xFF008751),
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Application Under Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your credit score and job history qualify you for tier-1 disbursement within 2 hours.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
