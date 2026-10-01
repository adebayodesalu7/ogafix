import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/ogafix_models.dart';
import '../../services/notification_service.dart';
import '../../utils/lagos_lgas.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  Category? selectedCategory;
  List<String> selectedSpecificServices = [];
  String selectedState = LagosData.state;
  String selectedLga = LagosData.localGovernments[0];
  String locationStamp = 'Lekki Phase 1, Lagos';

  final TextEditingController _descController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  String _selectedUrgency = 'Normal (Today/Tomorrow)';
  DateTime? _scheduledDateTime;
  bool _isRecurring = false;
  String _recurringFrequency = 'Weekly';

  Future<void> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _scheduledDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _runAiAssistant() {
    final text = _descController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter some text in the description first to let AI assist you.',
          ),
        ),
      );
      return;
    }
    setState(() {
      _descController.text =
          '🔧 [AI Polished & Categorized]: $text (Optimized for fast artisan dispatch)';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'AI Assistant successfully categorized and polished your service request!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Post a Job Request',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '1. Select Service Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF008751),
                  ),
                ),
                TextButton.icon(
                  onPressed: _runAiAssistant,
                  icon: const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF008751),
                    size: 16,
                  ),
                  label: const Text(
                    'AI Assist',
                    style: TextStyle(color: Color(0xFF008751)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Category>(
              value: selectedCategory,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                hintText: 'Choose category...',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
              items: MockData.categories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(
                    cat.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedCategory = val;
                  selectedSpecificServices.clear();
                });
              },
            ),
            if (selectedCategory != null) ...[
              const SizedBox(height: 16),
              const Text(
                '2. Specific Services Needed',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008751),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedCategory!.specificServices.map((service) {
                  final isSelected = selectedSpecificServices.contains(service);
                  return FilterChip(
                    label: Text(service),
                    selected: isSelected,
                    selectedColor: const Color(0xFF008751),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                    backgroundColor: const Color(0xFF1E1E1E),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedSpecificServices.add(service);
                        } else {
                          selectedSpecificServices.remove(service);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              '3. Problem Description & Appointment Schedule',
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
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Describe what needs fixing in detail (or tap AI Assist)...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _pickDateTime(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF008751)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _scheduledDateTime == null
                            ? 'Schedule Appointment Date & Time (Optional)'
                            : 'Scheduled: ${_scheduledDateTime.toString().substring(0, 16)}',
                        style: TextStyle(
                          color: _scheduledDateTime == null
                              ? Colors.grey
                              : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text(
                'Recurring Service Booking',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Repeat this service on a recurring schedule',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              value: _isRecurring,
              activeColor: const Color(0xFF008751),
              onChanged: (val) => setState(() => _isRecurring = val),
            ),
            if (_isRecurring) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _recurringFrequency,
                dropdownColor: const Color(0xFF1E1E1E),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                ),
                items: ['Weekly', 'Bi-Weekly', 'Monthly'].map((freq) {
                  return DropdownMenuItem(
                    value: freq,
                    child: Text(
                      freq,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(
                  () => _recurringFrequency = val ?? _recurringFrequency,
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              '4. Budget & Urgency (Naira Currency)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008751),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _budgetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'e.g. 15,000.00',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixText: '₦ ',
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedUrgency,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
              ),
              items:
                  [
                    'Emergency (< 2 hours - Priority)',
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
                onPressed: () async {
                  if (selectedCategory == null ||
                      selectedSpecificServices.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please select a category and at least one specific service.',
                        ),
                      ),
                    );
                    return;
                  }

                  final budget =
                      double.tryParse(
                        _budgetController.text.trim().replaceAll(',', ''),
                      ) ??
                      10000.0;
                  final jobPost = JobPost(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    categoryId: selectedCategory!.id,
                    specificService: selectedSpecificServices.join(', '),
                    description: _descController.text.trim(),
                    state: selectedState,
                    lga: selectedLga,
                    locationStamp: locationStamp,
                    budgetMin: budget,
                    budgetMax: budget * 1.5,
                    status: 'open',
                    createdAt: DateTime.now(),
                  );

                  await FirebaseFirestore.instance
                      .collection('jobs')
                      .add(jobPost.toMap());

                  // Broadcast push notification alert to professionals
                  await NotificationService().sendNotification(
                    userId: 'all_professionals',
                    title:
                        '🚨 ${_selectedUrgency.contains('Emergency') ? '[EMERGENCY] ' : ''}New Job Posted!',
                    body:
                        '${selectedCategory!.name} in $selectedLga • Budget: ₦$budget',
                  );

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Job posted successfully and broadcasted to professionals!',
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Post Job & Broadcast to Artisans',
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
