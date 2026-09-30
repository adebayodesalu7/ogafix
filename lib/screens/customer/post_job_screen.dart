import 'package:flutter/material.dart';

import '../../models/ogafix_models.dart';
import '../../utils/lagos_lgas.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  Category? selectedCategory;
  String? selectedSpecificService;
  String selectedState = LagosData.state;
  String selectedLga = LagosData.localGovernments[0];
  String locationStamp = 'Stamped: 6.4527° N, 3.3883° E (GPS Verified)';

  final TextEditingController _descController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  String _selectedUrgency = 'Normal (Today/Tomorrow)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Job & Request Quote')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. Select Service Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008751),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Category>(
              value: selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              hint: const Text(
                'Choose a category (e.g., Plumbing, Electrical)',
              ),
              items: MockData.categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat.name));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedCategory = val;
                  selectedSpecificService = null;
                });
              },
            ),
            if (selectedCategory != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Select Specific Professional Service',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedSpecificService,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                hint: const Text('Select exact service type'),
                items: selectedCategory!.specificServices.map((service) {
                  return DropdownMenuItem(value: service, child: Text(service));
                }).toList(),
                onChanged: (val) =>
                    setState(() => selectedSpecificService = val),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              '2. Location & Lagos LGA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008751),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedState,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: [LagosData.state].map((st) {
                      return DropdownMenuItem(value: st, child: Text(st));
                    }).toList(),
                    onChanged: (val) {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedLga,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: LagosData.localGovernments.map((lga) {
                      return DropdownMenuItem(
                        value: lga,
                        child: Text(lga, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedLga = val;
                          locationStamp =
                              'Stamped: GPS Verified in $val, Lagos State';
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.my_location,
                    color: Color(0xFF008751),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      locationStamp,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF008751),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '3. Problem Description & Media',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008751),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Describe what needs fixing in detail...',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt, color: Color(0xFF008751)),
                  label: const Text('Add Photo'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.mic, color: Color(0xFF008751)),
                  label: const Text('Voice Note'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '4. Budget & Timing',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008751),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Estimated budget',
                prefixText: '₦ ',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedUrgency,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items:
                  [
                    'Emergency (< 2 hours)',
                    'Normal (Today/Tomorrow)',
                    'Flexible',
                  ].map((urg) {
                    return DropdownMenuItem(value: urg, child: Text(urg));
                  }).toList(),
              onChanged: (val) =>
                  setState(() => _selectedUrgency = val ?? _selectedUrgency),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedCategory == null ||
                      selectedSpecificService == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please select a category and specific service.',
                        ),
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Job broadcasted for $selectedLga, Lagos! Awaiting professional quotes.',
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008751),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Broadcast Job to Local Professionals'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
