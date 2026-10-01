import 'package:flutter/material.dart';

class ProfessionalCalendarScreen extends StatefulWidget {
  const ProfessionalCalendarScreen({super.key});

  @override
  State<ProfessionalCalendarScreen> createState() =>
      _ProfessionalCalendarScreenState();
}

class _ProfessionalCalendarScreenState
    extends State<ProfessionalCalendarScreen> {
  bool _isAvailable = true;
  final List<String> _availabilityBlocks = [
    'Monday: 08:00 AM - 05:00 PM',
    'Tuesday: 08:00 AM - 05:00 PM',
    'Wednesday: 08:00 AM - 05:00 PM',
    'Thursday: 08:00 AM - 05:00 PM',
    'Friday: 08:00 AM - 05:00 PM',
    'Saturday: 09:00 AM - 02:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Professional Calendar & Availability',
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
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Available for New Bookings',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Toggle your instant availability status for customers',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                value: _isAvailable,
                activeColor: const Color(0xFF008751),
                onChanged: (val) {
                  setState(() => _isAvailable = val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        val
                            ? 'You are now online & available for bookings!'
                            : 'You are currently offline.',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Weekly Availability Schedule',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _availabilityBlocks.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Color(0xFF008751),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _availabilityBlocks[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Availability block updated!'),
                            ),
                          );
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(color: Color(0xFF008751)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Upcoming Bookings & Recurring Jobs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Plumbing Maintenance',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Lekki Phase 1, Lagos • Every Thursday at 10:00 AM',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Status: Confirmed & Scheduled',
                    style: TextStyle(
                      color: Color(0xFF008751),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
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
