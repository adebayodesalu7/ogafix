import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  final String professionalName;
  const ReviewScreen({super.key, required this.professionalName});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double _qualityRating = 5.0;
  double _communicationRating = 5.0;
  double _punctualityRating = 5.0;
  double _valueRating = 5.0;
  final TextEditingController _reviewController = TextEditingController();
  bool _rehire = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'Rate & Review ${widget.professionalName}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'How was the service?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your verified review helps other Lagos customers hire trusted pros.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Column(
                children: [
                  _buildRatingSlider(
                    'Quality of Work',
                    _qualityRating,
                    (val) => setState(() => _qualityRating = val),
                  ),
                  _buildRatingSlider(
                    'Communication',
                    _communicationRating,
                    (val) => setState(() => _communicationRating = val),
                  ),
                  _buildRatingSlider(
                    'Punctuality',
                    _punctualityRating,
                    (val) => setState(() => _punctualityRating = val),
                  ),
                  _buildRatingSlider(
                    'Value for Money',
                    _valueRating,
                    (val) => setState(() => _valueRating = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Write your detailed review...',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade800),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade800),
                ),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text(
                'Would you rehire this professional?',
                style: TextStyle(color: Colors.white),
              ),
              value: _rehire,
              activeColor: const Color(0xFF008751),
              onChanged: (val) => setState(() => _rehire = val),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Verified review submitted successfully! Thank you.',
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008751),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Submit Verified Review',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSlider(
    String label,
    double rating,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Slider(
            value: rating,
            min: 1.0,
            max: 5.0,
            divisions: 4,
            activeColor: const Color(0xFF008751),
            inactiveColor: Colors.grey.shade800,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
