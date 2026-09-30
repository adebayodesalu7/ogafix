import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile_model.dart';
import '../customer/customer_home_screen.dart';
import '../customer/map_search_screen.dart';
import '../customer/search_screen.dart';
import '../profile/user_profile_screen.dart';
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
                    .where('read', isEqualTo: false)
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
                      onLongPress: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.archive,
                                    color: Color(0xFF008751),
                                  ),
                                  title: const Text('Archive Chat'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  title: const Text(
                                    'Delete Chat History',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final batch = FirebaseFirestore.instance
                                        .batch();
                                    final messagesSnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('chats')
                                            .doc(chatId)
                                            .collection('messages')
                                            .get();
                                    for (var doc in messagesSnapshot.docs) {
                                      batch.delete(doc.reference);
                                    }
                                    await batch.commit();
                                  },
                                ),
                              ],
                            ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFF008751),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (val) async {
          if (val == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomerHomeScreen(),
              ),
            );
          } else if (val == 1) {
            // Already here
          } else if (val == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          } else if (val == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MapSearchScreen()),
            );
          } else if (val == 4) {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final doc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();
              if (doc.exists && doc.data() != null) {
                final profile = UserProfile.fromMap(doc.data()!);
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(profile: profile),
                  ),
                );
              }
            }
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}
