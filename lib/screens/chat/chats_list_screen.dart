import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile_model.dart';
import 'chat_screen.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages & Inbox'),
        backgroundColor: const Color(0xFF008751),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('professional_profiles')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No active conversations yet.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final profiles = snapshot.data!.docs
              .map((doc) {
                return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
              })
              .where((p) => p.uid != currentUserId)
              .toList();

          if (profiles.isEmpty) {
            return const Center(
              child: Text(
                'No other users found in chat inbox.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final peer = profiles[index];

              ImageProvider? avatarImg;
              if (peer.profileImageUrl.startsWith('data:image')) {
                try {
                  avatarImg = MemoryImage(
                    base64Decode(peer.profileImageUrl.split(',').last),
                  );
                } catch (_) {}
              }

              final chatId = currentUserId.compareTo(peer.uid) < 0
                  ? '${currentUserId}_${peer.uid}'
                  : '${peer.uid}_$currentUserId';

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatId)
                    .collection('messages')
                    .where('senderId', isNotEqualTo: currentUserId)
                    .snapshots(),
                builder: (context, msgSnapshot) {
                  int unreadCount = 0;
                  if (msgSnapshot.hasData) {
                    unreadCount = msgSnapshot.data!.docs.length;
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF008751),
                        backgroundImage: avatarImg,
                        child: avatarImg == null
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
                      title: Text(
                        peer.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        peer.profession,
                        style: const TextStyle(color: Color(0xFF006633)),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chat, color: Color(0xFF008751)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(peerProfile: peer),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
