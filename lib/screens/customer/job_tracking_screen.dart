import 'package:flutter/material.dart';

import 'job_completion_screen.dart';

class JobTrackingScreen extends StatefulWidget {
  final String professionalName;
  final String serviceTitle;

  const JobTrackingScreen({
    super.key,
    required this.professionalName,
    required this.serviceTitle,
  });

  @override
  State<JobTrackingScreen> createState() => _JobTrackingScreenState();
}

class _JobTrackingScreenState extends State<JobTrackingScreen> {
  int _currentStepIndex =
      1; // 0: Confirmed, 1: On the way, 2: Arrived, 3: Started, 4: Completed

  final List<String> _stages = [
    'Confirmed',
    'On the way',
    'Arrived',
    'Started',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Live Job Tracking',
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
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFF008751),
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.professionalName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.serviceTitle,
                          style: const TextStyle(
                            color: Color(0xFF008751),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Live Execution Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stages.length,
              itemBuilder: (context, index) {
                final isPassed = index <= _currentStepIndex;
                final isCurrent = index == _currentStepIndex;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isPassed
                                  ? const Color(0xFF008751)
                                  : Colors.grey.shade800,
                              border: Border.all(
                                color: isCurrent
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                isPassed ? Icons.check : Icons.circle,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          if (index < _stages.length - 1)
                            Container(
                              width: 2,
                              height: 35,
                              color: index < _currentStepIndex
                                  ? const Color(0xFF008751)
                                  : Colors.grey.shade800,
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _stages[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isCurrent
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isPassed ? Colors.white : Colors.grey,
                              ),
                            ),
                            if (isCurrent)
                              const Text(
                                'In progress...',
                                style: TextStyle(
                                  color: Color(0xFF008751),
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                if (_currentStepIndex < _stages.length - 1)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _currentStepIndex++);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF008751),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Simulate Next Milestone'),
                    ),
                  ),
                if (_currentStepIndex == _stages.length - 1)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobCompletionScreen(
                              professionalName: widget.professionalName,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF008751),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Proceed to Completion Evidence'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
