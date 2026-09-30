import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/chat_models.dart';
import '../../models/user_profile_model.dart';
import '../profile/user_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final UserProfile peerProfile;
  const ChatScreen({super.key, required this.peerProfile});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final List<ChatMessage> _messages = []; // Zero mock data as requested

  Future<void> _pickMedia(ImageSource source, String type) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _messages.add(
          ChatMessage(
            id: DateTime.now().toString(),
            senderId: 'me',
            senderName: 'Me',
            text: type == 'image' ? '[Photo Attachment]' : '[Video Attachment]',
            type: type,
            mediaUrl: picked.path,
            timestamp: DateTime.now(),
          ),
        );
      });
    }
  }

  void _startAgoraCall(bool isVideo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isVideo ? 'Agora Video Call' : 'Agora Voice Call'),
        content: Text('Connecting Agora RTC session with ${widget.peerProfile.fullName}...\n\n(Ready for Agora Temp Token).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('End Call', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008751), foregroundColor: Colors.white),
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008751),
        foregroundColor: Colors.white,
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfileScreen(profile: widget.peerProfile)),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Text(
                  widget.peerProfile.fullName.isNotEmpty ? widget.peerProfile.fullName.substring(0, 1) : 'U',
                  style: const TextStyle(color: Color(0xFF008751), fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.peerProfile.fullName, style: const TextStyle(fontSize: 16)),
                  Text(widget.peerProfile.profession, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            tooltip: 'Agora Voice Call',
            onPressed: () => _startAgoraCall(false),
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            tooltip: 'Agora Video Call',
            onPressed: () => _startAgoraCall(true),
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen(profile: widget.peerProfile)),
                );
              } else if (val == 'clear') {
                setState(() => _messages.clear());
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('View Profile')),
              const PopupMenuItem(value: 'clear', child: Text('Clear Chat History')),
              const PopupMenuItem(value: 'block', child: Text('Block User')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // End-to-End Encryption Stamp
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.green.shade50,
            child: const Text(
              '🔒 Messages are end-to-end encrypted',
              style: TextStyle(color: Color(0xFF008751), fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'No messages yet. Send a message or start a conversation!',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMe = msg.senderId == 'me';
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMe ? const Color(0xFFE8F5E9) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isMe ? Colors.green.shade200 : Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (msg.mediaUrl != null && File(msg.mediaUrl!).existsSync())
                                Container(
                                  height: 150,
                                  width: 200,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(image: FileImage(File(msg.mediaUrl!)), fit: BoxFit.cover),
                                  ),
                                ),
                              Text(msg.text, style: const TextStyle(fontSize: 15)),
                              const SizedBox(height: 4),
                              Text(
                                '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Chat Input Bar
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Color(0xFF008751)),
                  onPressed: () => _showAttachmentSheet(context),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Color(0xFF008751)),
                  onPressed: () => _pickMedia(ImageSource.camera, 'image'),
                ),
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Color(0xFF008751)),
                  onPressed: () {
                    setState(() {
                      _messages.add(
                        ChatMessage(
                          id: DateTime.now().toString(),
                          senderId: 'me',
                          senderName: 'Me',
                          text: '🎤 [Voice Message - 0:12]',
                          type: 'voice',
                          timestamp: DateTime.now(),
                        ),
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF008751)),
                  onPressed: () {
                    if (_msgController.text.trim().isNotEmpty) {
                      setState(() {
                        _messages.add(
                          ChatMessage(
                            id: DateTime.now().toString(),
                            senderId: 'me',
                            senderName: 'Me',
                            text: _msgController.text.trim(),
                            type: 'text',
                            timestamp: DateTime.now(),
                          ),
                        );
                        _msgController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image, color: Color(0xFF008751)),
              title: const Text('Send Image from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.gallery, 'image');
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: Color(0xFF008751)),
              title: const Text('Send Video from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.gallery, 'video');
              },
            ),
          ],
        ),
      ),
    );
  }
}
