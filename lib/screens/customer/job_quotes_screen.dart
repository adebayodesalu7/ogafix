import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/ogafix_models.dart';
import 'review_screen.dart';

class JobQuotesScreen extends StatefulWidget {
  final JobPost jobPost;
  const JobQuotesScreen({super.key, required this.jobPost});

  @override
  State<JobQuotesScreen> createState() => _JobQuotesScreenState();
}

class _JobQuotesScreenState extends State<JobQuotesScreen> {
  String _currentLifecycleStage =
      'Quote'; // Quote -> Booking -> Payment -> Completion -> Review

  Future<void> _updateJobStatus(String newStatus) async {
    await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobPost.id)
        .update({'status': newStatus});
    setState(() => _currentLifecycleStage = newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'Quotes for Job #${widget.jobPost.id.substring(widget.jobPost.id.length - 4)}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lifecycle Progress Tracker
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Complete Job Lifecycle',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStageIndicator(
                        'Quote',
                        _currentLifecycleStage == 'Quote',
                      ),
                      _buildStageIndicator(
                        'Booking',
                        _currentLifecycleStage == 'Booking',
                      ),
                      _buildStageIndicator(
                        'Payment',
                        _currentLifecycleStage == 'Payment',
                      ),
                      _buildStageIndicator(
                        'Complete',
                        _currentLifecycleStage == 'Completion',
                      ),
                      _buildStageIndicator(
                        'Review',
                        _currentLifecycleStage == 'Review',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Job: ${widget.jobPost.specificService}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.jobPost.description,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            const Text(
              'Submitted Professional Quotes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008751),
              ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('quotes')
                  .where('jobId', isEqualTo: widget.jobPost.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'No quotes submitted by professionals yet.\nProfessionals in your area are reviewing your request.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final quoteDocs = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: quoteDocs.length,
                  itemBuilder: (context, index) {
                    final quoteData =
                        quoteDocs[index].data() as Map<String, dynamic>;
                    final amount = quoteData['amount'] ?? 15000.0;
                    final message = quoteData['message'] ?? '';
                    final proName =
                        quoteData['professionalName'] ?? 'Verified Artisan';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green.shade800),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                proName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '₦$amount',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF008751),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            message,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _updateJobStatus('Booking');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Quote accepted! Proceeding to Booking & Escrow Payment.',
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF008751),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Accept Quote & Book'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            if (_currentLifecycleStage == 'Booking')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _updateJobStatus('Payment');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Escrow payment funded via Paystack/Flutterwave! Job in progress.',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Fund Escrow Payment (₦)'),
                ),
              ),
            if (_currentLifecycleStage == 'Payment')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _updateJobStatus('Completion');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Job marked completed! Please review professional.',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirm Job Completion & Release Funds'),
                ),
              ),
            if (_currentLifecycleStage == 'Completion')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _updateJobStatus('Review');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReviewScreen(
                          professionalName: 'Verified Artisan',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008751),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Rate & Review Professional'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageIndicator(String stage, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isActive
              ? const Color(0xFF008751)
              : Colors.grey.shade800,
          child: Text(
            stage[0],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stage,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
