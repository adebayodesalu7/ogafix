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
      appBar: AppBar(
        title: Text('Rate & Review ${widget.professionalName}'),
        backgroundColor: const Color(0xFF008751),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'How was the service?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your honest review helps other Lagos customers hire trusted pros.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
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
            const SizedBox(height: 24),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Write your review...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Would you rehire this professional?'),
              value: _rehire,
              activeColor: const Color(0xFF008751),
              onChanged: (val) => setState(() => _rehire = val),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Review submitted successfully! Thank you.'),
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
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
