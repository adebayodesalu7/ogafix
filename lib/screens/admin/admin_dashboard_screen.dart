import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OgaFix Admin Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metrics Overview
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total GMV',
                    '₦2.4M',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Active Pros',
                    '342',
                    Icons.badge,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Completed Jobs',
                    '1,280',
                    Icons.done_all,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Open Disputes',
                    '2',
                    Icons.warning,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Pending Professional Verifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                final names = [
                  'Chinedu Eze (Electrician)',
                  'Ibrahim Musa (Generator Repair)',
                ];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF008751),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      names[index],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Submitted NIN & Certificate • Level 2 Verification',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Professional verification approved!',
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Professional verification rejected.',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
