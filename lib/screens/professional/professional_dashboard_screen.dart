import 'package:flutter/material.dart';

import '../../models/ogafix_models.dart';
import '../../models/user_profile_model.dart';
import '../profile/user_profile_screen.dart';

class ProfessionalDashboardScreen extends StatefulWidget {
  const ProfessionalDashboardScreen({super.key});

  @override
  State<ProfessionalDashboardScreen> createState() =>
      _ProfessionalDashboardScreenState();
}

class _ProfessionalDashboardScreenState
    extends State<ProfessionalDashboardScreen> {
  int _currentIndex = 0;

  final List<JobPost> _incomingJobs = [
    JobPost(
      id: 'j1',
      categoryId: 'c1',
      specificService: 'Leaking Pipe Repair',
      description: 'Kitchen sink pipe is leaking heavily and flooding the floor in Lekki Phase 1.',
      state: 'Lagos State',
      lga: 'Eti-Osa (Lekki / Victoria Island / Ikoyi)',
      locationStamp: 'Lekki Phase 1, Lagos',
      budgetMin: 5000,
      budgetMax: 15000,
      status: 'open',
      createdAt: DateTime.now(),
    ),
    JobPost(
      id: 'j2',
      categoryId: 'c3',
      specificService: 'AC Full Servicing',
      description:
          '2 split AC units need servicing and gas top-up in Victoria Island.',
      state: 'Lagos State',
      lga: 'Eti-Osa (Lekki / Victoria Island / Ikoyi)',
      locationStamp: 'Victoria Island, Lagos',
      budgetMin: 10000,
      budgetMax: 25000,
      status: 'open',
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OgaFix Professional Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.verified, color: Color(0xFF008751)),
            tooltip: 'Verification Level 3 (Skill Verified)',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Tiered Verification Status'),
                  content: const Text(
                    'Level 3: Skill & Certificate Verified.\n\nYour profile has verified badges visible to customers across Lagos.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          // 3-Line Settings & Profile Menu Icon
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Color(0xFF008751)),
            onSelected: (val) {
              if (val == 'profile') {
                final demoProProfile = UserProfile(
                  uid: 'pro1',
                  email: 'professional@ogafix.ng',
                  phone: '+2348011905411',
                  role: 'professional',
                  fullName: 'Emeka Okafor',
                  state: 'Lagos State',
                  lga: 'Eti-Osa',
                  stateOfOrigin: 'Anambra',
                  age: 34,
                  yearsOfExperience: 8,
                  profession: 'Master Plumber',
                  ninNumber: '98765432109',
                  description: 'Certified Master Plumber serving Lagos State with 8 years of excellence.',
                  profileImageUrl: '',
                  verificationLevel: 3,
                  emailVerified: true,
                  phoneVerified: true,
                  ninVerified: true,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserProfileScreen(profile: demoProProfile),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('My Profile')),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Business Settings'),
              ),
              const PopupMenuItem(
                value: 'support',
                child: Text('OgaFix Pro Support'),
              ),
            ],
          ),
        ],
      ),
      body: _currentIndex == 0
          ? _buildJobFeed()
          : _currentIndex == 1
          ? _buildActiveJobs()
          : _buildEarningsView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF008751),
        unselectedItemColor: Colors.grey,
        onTap: (val) => setState(() => _currentIndex = val),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Job Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Active Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Earnings',
          ),
        ],
      ),
    );
  }

  Widget _buildJobFeed() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _incomingJobs.length,
      itemBuilder: (context, index) {
        final job = _incomingJobs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF008751).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        job.specificService,
                        style: const TextStyle(
                          color: Color(0xFF008751),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₦${job.budgetMin.toStringAsFixed(0)} - ₦${job.budgetMax.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(job.description, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${job.lga}, ${job.state}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showQuoteDialog(context, job);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008751),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Submit Quote & Arrival Time'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQuoteDialog(BuildContext context, JobPost job) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController durationController = TextEditingController();
    final TextEditingController msgController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Quote for ${job.specificService}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quote Amount (₦)',
                  prefixText: '₦ ',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'Estimated Duration (e.g., 2 hours)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: msgController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Message to Customer',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quote submitted successfully to customer!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF008751),
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Quote'),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveJobs() {
    return const Center(
      child: Text(
        'No active job bookings currently.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildEarningsView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Earnings (Gross)',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            '₦185,400',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF008751),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Payouts',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Ready for bank transfer',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const Text(
                    '₦45,000',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
