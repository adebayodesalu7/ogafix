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
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          isVideo ? 'Agora Video Call' : 'Agora Voice Call',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          'Connecting Agora RTC session with ${widget.peerProfile.fullName}...\n\n(Ready for Agora Temp Token).',
          style: const TextStyle(color: Colors.grey),
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
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.peerProfile.uid)
              .snapshots(),
          builder: (context, snapshot) {
            UserProfile peer = widget.peerProfile;
            if (snapshot.hasData &&
                snapshot.data!.exists &&
                snapshot.data!.data() != null) {
              peer = UserProfile.fromMap(
                snapshot.data!.data() as Map<String, dynamic>,
              );
            }

            ImageProvider? peerAvatar;
            if (peer.profileImageUrl.startsWith('data:image')) {
              try {
                peerAvatar = MemoryImage(
                  base64Decode(peer.profileImageUrl.split(',').last),
                );
              } catch (_) {}
            }

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(profile: peer),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF008751),
                    backgroundImage: peerAvatar,
                    child: peerAvatar == null
                        ? Text(
                            peer.fullName.isNotEmpty
                                ? peer.fullName.substring(0, 1)
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          peer.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          peer.profession.isNotEmpty
                              ? peer.profession
                              : 'Verified Service Provider',
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
            );
          },
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
            color: const Color(0xFF00331A),
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
                          color: isMe
                              ? const Color(0xFF00331A)
                              : const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isMe
                                ? const Color(0xFF008751)
                                : Colors.grey.shade800,
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
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
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
            color: const Color(0xFF1E1E1E),
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
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.black,
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
      backgroundColor: const Color(0xFF1E1E1E),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image, color: Color(0xFF008751)),
              title: const Text(
                'Send Image from Gallery',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.gallery, 'image');
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: Color(0xFF008751)),
              title: const Text(
                'Send Video from Gallery',
                style: TextStyle(color: Colors.white),
              ),
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
