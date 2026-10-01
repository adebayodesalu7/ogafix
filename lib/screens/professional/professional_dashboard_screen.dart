import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/ogafix_models.dart';
import '../../models/user_profile_model.dart';
import '../chat/chats_list_screen.dart';
import '../customer/support_screen.dart';
import '../profile/user_profile_screen.dart';
import 'business_analytics_screen.dart';
import 'customers_history_screen.dart';
import 'invoices_screen.dart';
import 'professional_active_job_screen.dart';
import 'professional_calendar_screen.dart';

class ProfessionalDashboardScreen extends StatefulWidget {
  const ProfessionalDashboardScreen({super.key});

  @override
  State<ProfessionalDashboardScreen> createState() =>
      _ProfessionalDashboardScreenState();
}

class _ProfessionalDashboardScreenState
    extends State<ProfessionalDashboardScreen> {
  int _currentIndex = 0;

  void _showDisputeDialog() {
    final TextEditingController disputeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Trust & Safety Dispute Report',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Report suspicious behavior, payment disputes, or safety concerns to FindAPro Trust & Safety:',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: disputeController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Describe the dispute or issue...',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (disputeController.text.trim().isNotEmpty) {
                final user = FirebaseAuth.instance.currentUser;
                await FirebaseFirestore.instance
                    .collection('support_tickets')
                    .add({
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'userId': user?.uid ?? 'pro',
                      'userName': user?.displayName ?? 'Professional',
                      'subject': '[DISPUTE] Trust & Safety Report',
                      'message': disputeController.text.trim(),
                      'status': 'Open',
                      'createdAt': DateTime.now().toIso8601String(),
                      'adminReply': '',
                    });
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Dispute reported successfully. Trust & Safety team is reviewing.',
                    ),
                  ),
                );
              }
            },
            child: const Text(
              'Submit Dispute',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'FindAPro Professional Hub',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.verified, color: Color(0xFF008751)),
            tooltip: 'Verification Level 3 (Skill Verified)',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1E1E1E),
                  title: const Text(
                    'Tiered Verification Status',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Level 3: Skill & Certificate Verified.\n\nYour profile has verified badges visible to customers across Lagos.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Color(0xFF008751)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // 3-Line Settings & Profile Menu Icon
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Color(0xFF008751)),
            onSelected: (val) async {
              if (val == 'profile') {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final doc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .get();
                  if (doc.exists && doc.data() != null) {
                    final profile = UserProfile.fromMap(doc.data()!);
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserProfileScreen(profile: profile),
                      ),
                    );
                  }
                }
              } else if (val == 'calendar') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfessionalCalendarScreen(),
                  ),
                );
              } else if (val == 'invoices') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InvoicesScreen(),
                  ),
                );
              } else if (val == 'customers') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomersHistoryScreen(),
                  ),
                );
              } else if (val == 'analytics') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BusinessAnalyticsScreen(),
                  ),
                );
              } else if (val == 'support') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SupportScreen(),
                  ),
                );
              } else if (val == 'dispute') {
                _showDisputeDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('My Profile')),
              const PopupMenuItem(
                value: 'calendar',
                child: Text('Calendar & Availability'),
              ),
              const PopupMenuItem(
                value: 'invoices',
                child: Text('Invoices & Billing'),
              ),
              const PopupMenuItem(
                value: 'customers',
                child: Text('Customer History & Notes'),
              ),
              const PopupMenuItem(
                value: 'analytics',
                child: Text('Business Analytics'),
              ),
              const PopupMenuItem(
                value: 'support',
                child: Text('FindAPro Pro Support'),
              ),
              const PopupMenuItem(
                value: 'dispute',
                child: Text('Report Dispute / Trust & Safety'),
              ),
            ],
          ),
        ],
      ),
      body: _currentIndex == 0
          ? _buildJobFeed()
          : _currentIndex == 1
          ? const ChatsListScreen()
          : _currentIndex == 2
          ? _buildServiceDirectory()
          : _currentIndex == 3
          ? const ProfessionalActiveJobScreen()
          : _buildEarningsView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFF008751),
        unselectedItemColor: Colors.grey,
        onTap: (val) => setState(() => _currentIndex = val),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Job Feed',
          ),
          BottomNavigationBarItem(
            icon: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('professional_profiles')
                  .snapshots(),
              builder: (context, snapshot) {
                int unreadTotal = 0;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.chat_bubble_outline),
                    if (unreadTotal > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$unreadTotal',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: 'Inbox',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Directory',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Active',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Earnings',
          ),
        ],
      ),
    );
  }

  Widget _buildJobFeed() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('jobs')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No incoming job posts from customers yet.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final jobs = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return JobPost.fromMap(data);
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        job.specificService,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '₦${job.budgetMin.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF008751),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    job.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${job.lga}, Lagos',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          _showSubmitQuoteDialog(job);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF008751),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Submit Quote & Arrival Time'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSubmitQuoteDialog(JobPost job) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Submit Quote to Customer',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job: ${job.specificService}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Quote Amount (₦)',
                labelStyle: const TextStyle(color: Colors.grey),
                prefixText: '₦ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: messageController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Message & Estimated Arrival Time',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final amount =
                  double.tryParse(amountController.text.trim()) ??
                  job.budgetMin;
              final msg = messageController.text.trim();
              if (amount > 0) {
                final user = FirebaseAuth.instance.currentUser;
                await FirebaseFirestore.instance.collection('quotes').add({
                  'jobId': job.id,
                  'professionalId': user?.uid ?? 'pro1',
                  'professionalName': user?.displayName ?? 'Verified Artisan',
                  'amount': amount,
                  'message': msg,
                  'createdAt': DateTime.now().toIso8601String(),
                });
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quote submitted successfully to customer!'),
                  ),
                );
              }
            },
            child: const Text(
              'Send Quote',
              style: TextStyle(
                color: Color(0xFF008751),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDirectory() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: MockData.categories.length,
      itemBuilder: (context, index) {
        final cat = MockData.categories[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Row(
            children: [
              const Icon(Icons.handyman, color: Color(0xFF008751), size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cat.description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEarningsView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Earnings & Analytics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF00331A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF008751)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Revenue Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                SizedBox(height: 8),
                Text(
                  '₦185,400.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Completed Jobs: 14',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      'Rating: 4.9 ⭐',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
