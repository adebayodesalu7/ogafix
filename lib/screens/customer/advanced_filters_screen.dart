import 'package:flutter/material.dart';

class AdvancedFiltersScreen extends StatefulWidget {
  const AdvancedFiltersScreen({super.key});

  @override
  State<AdvancedFiltersScreen> createState() => _AdvancedFiltersScreenState();
}

class _AdvancedFiltersScreenState extends State<AdvancedFiltersScreen> {
  double _maxDistanceKm = 10.0;
  double _minRating = 4.0;
  double _maxPrice = 50000.0;
  bool _availableNow = true;
  bool _verifiedOnly = true;
  int _minExperienceYears = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Advanced Search Filters',
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
              'Maximum Distance (km)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Slider(
              value: _maxDistanceKm,
              min: 1.0,
              max: 50.0,
              divisions: 49,
              activeColor: const Color(0xFF008751),
              inactiveColor: Colors.grey.shade800,
              label: '${_maxDistanceKm.toStringAsFixed(0)} km',
              onChanged: (val) => setState(() => _maxDistanceKm = val),
            ),
            Text(
              '${_maxDistanceKm.toStringAsFixed(0)} km radius around your location',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
            const Text(
              'Minimum Rating',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Slider(
              value: _minRating,
              min: 1.0,
              max: 5.0,
              divisions: 4,
              activeColor: const Color(0xFF008751),
              inactiveColor: Colors.grey.shade800,
              label: '${_minRating.toStringAsFixed(1)} ⭐',
              onChanged: (val) => setState(() => _minRating = val),
            ),
            Text(
              '${_minRating.toStringAsFixed(1)} Stars and above',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
            const Text(
              'Maximum Starting Price (₦)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Slider(
              value: _maxPrice,
              min: 5000.0,
              max: 200000.0,
              divisions: 39,
              activeColor: const Color(0xFF008751),
              inactiveColor: Colors.grey.shade800,
              label: '₦${_maxPrice.toStringAsFixed(0)}',
              onChanged: (val) => setState(() => _maxPrice = val),
            ),
            Text(
              'Up to ₦${_maxPrice.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text(
                'Available Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Show professionals currently online and ready',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              value: _availableNow,
              activeColor: const Color(0xFF008751),
              onChanged: (val) => setState(() => _availableNow = val),
            ),
            SwitchListTile(
              title: const Text(
                'Verified Only (NIN & Phone)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Filter for level 2+ verified artisans',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              value: _verifiedOnly,
              activeColor: const Color(0xFF008751),
              onChanged: (val) => setState(() => _verifiedOnly = val),
            ),
            const SizedBox(height: 24),
            const Text(
              'Minimum Years of Experience',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Slider(
              value: _minExperienceYears.toDouble(),
              min: 1.0,
              max: 15.0,
              divisions: 14,
              activeColor: const Color(0xFF008751),
              inactiveColor: Colors.grey.shade800,
              label: '$_minExperienceYears yrs',
              onChanged: (val) =>
                  setState(() => _minExperienceYears = val.toInt()),
            ),
            Text(
              'At least $_minExperienceYears years experience',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'maxDistanceKm': _maxDistanceKm,
                    'minRating': _minRating,
                    'maxPrice': _maxPrice,
                    'availableNow': _availableNow,
                    'verifiedOnly': _verifiedOnly,
                    'minExperienceYears': _minExperienceYears,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Advanced search filters applied!'),
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
                  'Apply Filters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
