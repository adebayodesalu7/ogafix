import 'package:flutter/material.dart';

import 'post_job_screen.dart';

class AiDiagnosticScreen extends StatefulWidget {
  const AiDiagnosticScreen({super.key});

  @override
  State<AiDiagnosticScreen> createState() => _AiDiagnosticScreenState();
}

class _AiDiagnosticScreenState extends State<AiDiagnosticScreen> {
  final TextEditingController _problemController = TextEditingController();
  bool _isAnalyzing = false;
  String? _aiClassification;
  String? _clarifyingQuestion;

  void _analyzeProblem() {
    final text = _problemController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe what is wrong first.')),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        if (text.toLowerCase().contains('pipe') ||
            text.toLowerCase().contains('leak') ||
            text.toLowerCase().contains('water')) {
          _aiClassification = 'Plumbing (Leaking Pipe Repair)';
          _clarifyingQuestion = 'Is the leak coming from under the kitchen sink or the bathroom mainline?';
        } else if (text.toLowerCase().contains('generator') ||
            text.toLowerCase().contains('power') ||
            text.toLowerCase().contains('engine')) {
          _aiClassification = 'Generator repair (Engine Overhaul)';
          _clarifyingQuestion = 'Is it a diesel or petrol generator, and does it crank but fail to start?';
        } else if (text.toLowerCase().contains('ac') ||
            text.toLowerCase().contains('cool') ||
            text.toLowerCase().contains('fridge')) {
          _aiClassification = 'AC/Refrigeration (AC Full Servicing)';
          _clarifyingQuestion =
              'When was the last time the AC gas was topped up?';
        } else {
          _aiClassification = 'Electrical (Wiring & Rewiring)';
          _clarifyingQuestion =
              'Is this affecting a single room or the entire apartment?';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Tell FindAPro What\'s Wrong (AI)',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'AI Diagnostic & Problem Assistant',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Describe your issue using natural language, voice recording, or photo upload. Our AI will classify your service request and match you instantly.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _problemController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'e.g., "My generator is making a loud noise and won\'t power the house"',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade800),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade800),
                ),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '🎙️ Voice note recorded: "Generator making noise..."',
                          ),
                        ),
                      );
                      _problemController.text = 'Generator is making a loud noise and won\'t power the house';
                    },
                    icon: const Icon(Icons.mic, color: Color(0xFF008751)),
                    label: const Text(
                      'Voice Input',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF008751)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('📷 Photo attached for AI diagnosis.'),
                        ),
                      );
                      _problemController.text =
                          'Leaking pipe under kitchen sink';
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Color(0xFF008751),
                    ),
                    label: const Text(
                      'Photo Input',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF008751)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isAnalyzing ? null : _analyzeProblem,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008751),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isAnalyzing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Analyze with AI Assistant',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            if (_aiClassification != null) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF00331A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF008751)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🤖 AI Classification Result',
                      style: TextStyle(
                        color: Color(0xFF008751),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Suggested Category: $_aiClassification',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Clarifying Question:',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _clarifyingQuestion!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostJobScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Post Job with AI Match',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
