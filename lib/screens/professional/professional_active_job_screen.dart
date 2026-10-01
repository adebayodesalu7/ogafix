import 'package:flutter/material.dart';

class ProfessionalActiveJobScreen extends StatefulWidget {
  const ProfessionalActiveJobScreen({super.key});

  @override
  State<ProfessionalActiveJobScreen> createState() =>
      _ProfessionalActiveJobScreenState();
}

class _ProfessionalActiveJobScreenState
    extends State<ProfessionalActiveJobScreen> {
  String _jobState =
      'Confirmed'; // Confirmed -> On the way -> Arrived -> Started -> Completed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Active Job Management',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer: Adebayo Desalu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Service: Leaking Pipe Repair & Sanitary Inspection',
                    style: TextStyle(
                      color: Color(0xFF008751),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Location: Lekki Phase 1, Eti-Osa, Lagos',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Opening Google Maps navigation to customer location...',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.navigation, size: 16),
                        label: const Text('Navigate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF008751),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Opening secure chat with customer...',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.chat,
                          size: 16,
                          color: Color(0xFF008751),
                        ),
                        label: const Text(
                          'Chat',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF008751)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Job Execution Milestones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildMilestoneTile(
              'Confirmed',
              'Job accepted and payment secured in escrow.',
            ),
            _buildMilestoneTile(
              'On the way',
              'You are en route to customer location.',
            ),
            _buildMilestoneTile(
              'Arrived',
              'You have arrived at the service address.',
            ),
            _buildMilestoneTile('Started', 'Work has officially commenced.'),
            _buildMilestoneTile(
              'Completed',
              'Work finished and before/after evidence uploaded.',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_jobState == 'Confirmed')
                      _jobState = 'On the way';
                    else if (_jobState == 'On the way')
                      _jobState = 'Arrived';
                    else if (_jobState == 'Arrived')
                      _jobState = 'Started';
                    else if (_jobState == 'Started')
                      _jobState = 'Completed';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Job status updated to: $_jobState'),
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
                child: Text(
                  'Advance Job Status (Current: $_jobState)',
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

  Widget _buildMilestoneTile(String title, String subtitle) {
    final bool isDone = _jobState == title || _isPassed(title);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? const Color(0xFF008751) : Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDone ? Colors.white : Colors.grey,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isPassed(String stage) {
    final list = ['Confirmed', 'On the way', 'Arrived', 'Started', 'Completed'];
    return list.indexOf(stage) < list.indexOf(_jobState);
  }
}
