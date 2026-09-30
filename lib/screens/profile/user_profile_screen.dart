import 'package:flutter/material.dart';

import '../../models/user_profile_model.dart';

class UserProfileScreen extends StatelessWidget {
  final UserProfile profile;

  const UserProfileScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('${profile.fullName} Profile'),
        backgroundColor: const Color(0xFF008751),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF008751).withValues(alpha: 0.2),
              child: Text(
                profile.fullName.isNotEmpty
                    ? profile.fullName.substring(0, 1).toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008751),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profile.fullName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              profile.profession,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF008751),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Chip(
              avatar: const Icon(Icons.verified, color: Colors.white, size: 16),
              label: Text(
                'Verification Level ${profile.verificationLevel} (NIN & Phone Verified)',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xFF008751),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.green.shade200),
              ),
              color: const Color(0xFFE8F5E9),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Professional Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF008751),
                      ),
                    ),
                    const Divider(color: Colors.green),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Location',
                      '${profile.lga}, ${profile.state}',
                    ),
                    _buildDetailRow('State of Origin', profile.stateOfOrigin),
                    _buildDetailRow('Age', '${profile.age} years'),
                    _buildDetailRow(
                      'Experience',
                      '${profile.yearsOfExperience} years',
                    ),
                    _buildDetailRow('Phone', profile.phone),
                    _buildDetailRow('Email', profile.email),
                    _buildDetailRow(
                      'NIN Status',
                      profile.ninNumber.isNotEmpty
                          ? 'Verified (11-digit)'
                          : 'Pending',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Professional Bio & Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile.description.isNotEmpty
                          ? profile.description
                          : 'No professional description provided yet.',
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
