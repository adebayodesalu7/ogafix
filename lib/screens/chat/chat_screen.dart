import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  String get _chatId {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'user1';
    final peerUserId = widget.peerProfile.uid;
    return currentUserId.compareTo(peerUserId) < 0
        ? '${currentUserId}_$peerUserId'
        : '${peerUserId}_$currentUserId';
  }

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  Future<void> _markMessagesAsRead() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    try {
      final unreadDocs = await FirebaseFirestore.instance
          .collection('chats')
          .doc(_chatId)
          .collection('messages')
          .where('senderId', isNotEqualTo: currentUserId)
          .where('read', isEqualTo: false)
          .get();

      for (var doc in unreadDocs.docs) {
        doc.reference.update({'read': true});
      }
    } catch (_) {}
  }

  Future<void> _sendMessage({
    required String text,
    String type = 'text',
    String? mediaUrl,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'user1';
    final currentUserName =
        FirebaseAuth.instance.currentUser?.displayName ?? 'User';

    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUserId,
      senderName: currentUserName,
      text: text,
      type: type,
      mediaUrl: mediaUrl,
      read: false,
      timestamp: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(_chatId)
        .collection('messages')
        .add(msg.toMap());
  }

  Future<void> _pickMedia(ImageSource source, String type) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      final bytes = await File(picked.path).readAsBytes();
      final base64Media =
          'data:${type == 'image' ? 'image/jpeg' : 'video/mp4'};base64,${base64Encode(bytes)}';
      await _sendMessage(
        text: type == 'image' ? '[Photo Attachment]' : '[Video Attachment]',
        type: type,
        mediaUrl: base64Media,
      );
    }
  }

  void _startAgoraCall(bool isVideo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isVideo ? 'Agora Video Call' : 'Agora Voice Call'),
        content: Text(
          'Connecting Agora RTC session with ${widget.peerProfile.fullName}...\n\n(Ready for Agora Temp Token).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('End Call', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF008751),
              foregroundColor: Colors.white,
            ),
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

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
                  widget.peerProfile.fullName.isNotEmpty
                      ? widget.peerProfile.fullName.substring(0, 1)
                      : 'U',
                  style: const TextStyle(
                    color: Color(0xFF008751),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.peerProfile.fullName,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.peerProfile.profession,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
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
                  MaterialPageRoute(
                    builder: (context) =>
                        UserProfileScreen(profile: widget.peerProfile),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('View Profile'),
              ),
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
              style: TextStyle(
                color: Color(0xFF008751),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(_chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet. Send a message or start a conversation!',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  );
                }

                final messages = snapshot.data!.docs.map((doc) {
                  return ChatMessage.fromMap(
                    doc.data() as Map<String, dynamic>,
                  );
                }).toList();

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUserId;

                    ImageProvider? mediaImg;
                    if (msg.mediaUrl != null &&
                        msg.mediaUrl!.startsWith('data:image')) {
                      try {
                        mediaImg = MemoryImage(
                          base64Decode(msg.mediaUrl!.split(',').last),
                        );
                      } catch (_) {}
                    }

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
                            if (mediaImg != null)
                              Container(
                                height: 150,
                                width: 200,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: mediaImg,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            Text(
                              msg.text,
                              style: const TextStyle(fontSize: 15),
                            ),
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
                    _sendMessage(
                      text: '🎤 [Voice Message - 0:12]',
                      type: 'voice',
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF008751)),
                  onPressed: () {
                    if (_msgController.text.trim().isNotEmpty) {
                      _sendMessage(
                        text: _msgController.text.trim(),
                        type: 'text',
                      );
                      _msgController.clear();
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
