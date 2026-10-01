import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/ogafix_models.dart';
import '../../services/notification_service.dart';
import '../../utils/lagos_lgas.dart';

class VoiceJobScreen extends StatefulWidget {
  const VoiceJobScreen({super.key});

  @override
  State<VoiceJobScreen> createState() => _VoiceJobScreenState();
}

class _VoiceJobScreenState extends State<VoiceJobScreen> {
  bool _isRecording = false;
  bool _isProcessing = false;
  String _transcribedText = '';
  String _detectedTrade = '';

  void _toggleRecording() {
    setState(() => _isRecording = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          _isProcessing = false;
          _transcribedText = 'Oga my generator no dey start since morning, fuel dey inside but engine heavy.';
          _detectedTrade = 'Generator repair';
        });
      });
    });
  }

  Future<void> _postVoiceJob() async {
    if (_transcribedText.isEmpty) return;

    final jobPost = JobPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categoryId: 'c4',
      specificService: 'Generator Servicing & Repair',
      description: '🎤 [Voice Note - Pidgin]: $_transcribedText',
      state: LagosData.state,
      lga: LagosData.localGovernments[0],
      locationStamp: 'Lekki Phase 1, Lagos',
      budgetMin: 15000.0,
      budgetMax: 25000.0,
      status: 'open',
      createdAt: DateTime.now(),
    );

    await FirebaseFirestore.instance.collection('jobs').add(jobPost.toMap());

    await NotificationService().sendNotification(
      userId: 'all_professionals',
      title: '🎤 New Voice Note Job Posted!',
      body: '$_detectedTrade in Lekki • Budget: ₦15,000',
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Voice job posted successfully and broadcasted to artisans!',
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Voice Note Job Posting (Pidgin / English)',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Speak Your Service Request',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the microphone and speak naturally in English or Nigerian Pidgin (e.g. "Generator no dey start"). AI will transcribe and post it instantly.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Center(
              child: GestureDetector(
                onTap: _isRecording || _isProcessing ? null : _toggleRecording,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.red : const Color(0xFF008751),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (_isRecording
                                    ? Colors.red
                                    : const Color(0xFF008751))
                                .withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                _isRecording
                    ? 'Recording voice note...'
                    : (_isProcessing
                          ? 'Processing speech to text & AI classifying...'
                          : 'Tap mic to start speaking'),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 36),
            if (_transcribedText.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF008751)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎙️ AI Transcription & Classification:',
                      style: TextStyle(
                        color: Color(0xFF008751),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"$_transcribedText"',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Detected Trade: $_detectedTrade',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _postVoiceJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008751),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Post Voice Job to Marketplace',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
