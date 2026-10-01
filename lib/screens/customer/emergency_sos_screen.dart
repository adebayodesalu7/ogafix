import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/ogafix_models.dart';
import '../../services/notification_service.dart';
import '../../utils/lagos_lgas.dart';

class EmergencySosScreen extends StatefulWidget {
  const EmergencySosScreen({super.key});

  @override
  State<EmergencySosScreen> createState() => _EmergencySosScreenState();
}

class _EmergencySosScreenState extends State<EmergencySosScreen> {
  bool _isDispatching = false;
  String _emergencyType = 'Severe Electrical Spark / Hazard';

  final List<String> _emergencies = [
    'Severe Electrical Spark / Hazard',
    'Major Water Pipe Burst / Flooding',
    'Generator Fire Risk / Breakdown',
    'Emergency Lockout / Security Breach',
  ];

  Future<void> _triggerSosDispatch() async {
    setState(() => _isDispatching = true);

    try {
      final jobPost = JobPost(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        categoryId: 'c2',
        specificService: '🚨 SOS EMERGENCY: $_emergencyType',
        description: 'URGENT PRIORITY DISPATCH (< 2 hours response required). Immediate artisan needed.',
        state: LagosData.state,
        lga: LagosData.localGovernments[0],
        locationStamp: 'Lekki Phase 1, Lagos',
        budgetMin: 35000.0, // Surge pricing
        budgetMax: 60000.0,
        status: 'open',
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('jobs').add(jobPost.toMap());

      await NotificationService().sendNotification(
        userId: 'all_professionals',
        title: '🚨 EMERGENCY SOS ALERT IN ${LagosData.localGovernments[0]}!',
        body: '$_emergencyType • Surge Bounty: ₦35,000+',
      );

      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() => _isDispatching = false);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            '🚨 SOS Emergency Dispatched',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Emergency alert successfully broadcasted to all standby emergency artisans in your area with priority surge bounty. Expect a call within 5 minutes.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'View Active Dispatch',
                style: TextStyle(
                  color: Color(0xFF008751),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _isDispatching = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error dispatching SOS: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          '24/7 Emergency SOS Dispatch',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade900,
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
                color: Colors.red.shade900.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Priority Emergency Response',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Use this only for critical household emergencies (major pipe bursts, electrical smoke, severe security hazards). Emergency surge pricing applies.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Emergency Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ..._emergencies.map((emerg) {
              final isSelected = _emergencyType == emerg;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.red.shade900.withValues(alpha: 0.3)
                      : const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.red : Colors.grey.shade800,
                  ),
                ),
                child: RadioListTile<String>(
                  title: Text(
                    emerg,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: emerg,
                  groupValue: _emergencyType,
                  activeColor: Colors.red,
                  onChanged: (val) =>
                      setState(() => _emergencyType = val ?? _emergencyType),
                ),
              );
            }),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isDispatching ? null : _triggerSosDispatch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isDispatching
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        '🚨 TRIGGER SOS EMERGENCY DISPATCH',
                        style: TextStyle(
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
