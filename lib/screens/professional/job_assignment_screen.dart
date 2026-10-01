import 'package:flutter/material.dart';

class JobAssignmentScreen extends StatefulWidget {
  const JobAssignmentScreen({super.key});

  @override
  State<JobAssignmentScreen> createState() => _JobAssignmentScreenState();
}

class _JobAssignmentScreenState extends State<JobAssignmentScreen> {
  final List<Map<String, String>> _assignments = [
    {
      'job': 'Leaking Pipe Repair (Lekki)',
      'worker': 'Emeka Obi',
      'date': '2026-10-02 10:00 AM',
      'status': 'Assigned',
    },
    {
      'job': 'AC Servicing (Victoria Island)',
      'worker': 'Tunde Bakare',
      'date': '2026-10-02 02:00 PM',
      'status': 'Scheduled',
    },
  ];

  void _showAssignJobDialog() {
    String selectedWorker = 'Emeka Obi';
    String selectedJob = 'Generator Maintenance (Ikeja)';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Assign Job to Worker',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Job:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: selectedJob,
                dropdownColor: const Color(0xFF1E1E1E),
                style: const TextStyle(color: Colors.white),
                items:
                    [
                      'Generator Maintenance (Ikeja)',
                      'Wiring Installation (Ajah)',
                      'POP Painting (Ikoyi)',
                    ].map((j) {
                      return DropdownMenuItem(
                        value: j,
                        child: Text(
                          j,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedJob = val);
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Team Worker:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: selectedWorker,
                dropdownColor: const Color(0xFF1E1E1E),
                style: const TextStyle(color: Colors.white),
                items: ['Emeka Obi', 'Tunde Bakare'].map((w) {
                  return DropdownMenuItem(
                    value: w,
                    child: Text(w, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedWorker = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _assignments.insert(0, {
                    'job': selectedJob,
                    'worker': selectedWorker,
                    'date': 'Tomorrow 10:00 AM',
                    'status': 'Assigned',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Job assigned to team worker successfully!'),
                  ),
                );
              },
              child: const Text(
                'Confirm Assignment',
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Job Assignment & Scheduling',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_add, color: Color(0xFF008751)),
            tooltip: 'Assign Job',
            onPressed: _showAssignJobDialog,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _assignments.length,
        itemBuilder: (context, index) {
          final assignment = _assignments[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assignment['job']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Assigned To: ${assignment['worker']}',
                        style: const TextStyle(
                          color: Color(0xFF008751),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Schedule: ${assignment['date']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF008751).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF008751)),
                  ),
                  child: Text(
                    assignment['status']!,
                    style: const TextStyle(
                      color: Color(0xFF008751),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
