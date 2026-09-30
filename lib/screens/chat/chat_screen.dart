import 'package:flutter/material.dart';

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
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'm1',
      senderId: 'peer',
      senderName: 'Handyman',
      text: 'Hello! I saw your service request on OgaFix. When would you want me to arrive?',
      type: 'text',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    ChatMessage(
      id: 'm2',
      senderId: 'me',
      senderName: 'Me',
      text: 'Hi! Can you come over by 2 PM today?',
      type: 'text',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ];

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
              MaterialPageRoute(
                builder: (context) =>
                    UserProfileScreen(profile: widget.peerProfile),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Text(
                  widget.peerProfile.fullName.substring(0, 1),
                  style: const TextStyle(
                    color: Color(0xFF008751),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.peerProfile.fullName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    widget.peerProfile.profession,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${widget.peerProfile.phone}...'),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserProfileScreen(profile: widget.peerProfile),
                  ),
                );
              } else if (val == 'clear') {
                setState(() => _messages.clear());
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('View Profile'),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear Chat History'),
              ),
              const PopupMenuItem(value: 'block', child: Text('Block User')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.senderId == 'me';
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFE8F5E9) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isMe
                            ? Colors.green.shade200
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg.text, style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(
                          '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Chat Input Bar with Attachments, Voice & Emojis
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Color(0xFF008751)),
                  onPressed: () {
                    _showAttachmentSheet(context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Color(0xFF008751)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Image captured and attached!'),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Color(0xFF008751)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Voice message recorded & sent!'),
                      ),
                    );
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
              title: const Text('Send Image / Video'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image/Video attached!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.insert_drive_file,
                color: Color(0xFF008751),
              ),
              title: const Text('Send Document / Invoice'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Document attached!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
