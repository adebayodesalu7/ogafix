import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/ogafix_models.dart';
import '../../models/user_profile_model.dart';
import '../chat/chat_screen.dart';
import '../chat/chats_list_screen.dart';
import '../profile/user_profile_screen.dart';
import 'map_search_screen.dart';
import 'post_job_screen.dart';
import 'search_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  String selectedLocation = 'Lekki Phase 1, Lagos';
  int _bottomNavIndex = 0;
  String? _selectedProfessionFilter; // null means All

  final List<String> lagosLocations = [
    'Lekki Phase 1, Lagos',
    'Victoria Island, Lagos',
    'Ikoyi, Lagos',
    'Ajah, Lagos',
    'Ikeja, Lagos',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF008751), size: 20),
            const SizedBox(width: 4),
            DropdownButton<String>(
              value: selectedLocation,
              underline: const SizedBox(),
              items: lagosLocations.map((loc) {
                return DropdownMenuItem(
                  value: loc,
                  child: Text(
                    loc,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => selectedLocation = val);
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat, color: Color(0xFF008751)),
            tooltip: 'Contacted Chats / Inbox',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatsListScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF008751)),
            tooltip: 'Search Services & Handymen',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.map, color: Color(0xFF008751)),
            tooltip: 'Map & Distance Search',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapSearchScreen(),
                ),
              );
            },
          ),
          // 3-Line Settings & Profile Menu Icon
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Color(0xFF008751)),
            onSelected: (val) async {
              if (val == 'profile') {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final doc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .get();
                  if (doc.exists && doc.data() != null) {
                    final profile = UserProfile.fromMap(doc.data()!);
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserProfileScreen(profile: profile),
                      ),
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('My Profile')),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Account Settings'),
              ),
              const PopupMenuItem(
                value: 'support',
                child: Text('OgaFix Support'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Job Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF008751).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF008751).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need a professional?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1D1D),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pick a category below or post a job request.',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostJobScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008751),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Post Job'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Step 1: Select Category of Profession to Filter List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Service Categories (Tap to Filter)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_selectedProfessionFilter != null)
                  TextButton(
                    onPressed: () =>
                        setState(() => _selectedProfessionFilter = null),
                    child: const Text(
                      'Clear Filter',
                      style: TextStyle(color: Color(0xFF008751)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: MockData.categories.length,
              itemBuilder: (context, index) {
                final cat = MockData.categories[index];
                final isSelected = _selectedProfessionFilter == cat.name;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedProfessionFilter = isSelected ? null : cat.name;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF008751)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF00331A)
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.handyman,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF008751),
                          size: 28,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Step 2: List of Professionals Filtered by Selected Profession
            Row(
              children: [
                Text(
                  _selectedProfessionFilter == null
                      ? 'All Verified Professionals'
                      : 'Professionals in "$_selectedProfessionFilter"',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('professional_profiles')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: Center(
                      child: Text(
                        'No verified professionals registered in the database yet.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  );
                }

                final firestorePros = snapshot.data!.docs.map((doc) {
                  return UserProfile.fromMap(
                    doc.data() as Map<String, dynamic>,
                  );
                }).toList();

                final filteredPros = firestorePros.where((pro) {
                  if (_selectedProfessionFilter == null) return true;
                  return pro.profession.toLowerCase().contains(
                    _selectedProfessionFilter!.toLowerCase(),
                  );
                }).toList();

                if (filteredPros.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Center(
                      child: Text(
                        'No professionals found for "$_selectedProfessionFilter".',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredPros.length,
                  itemBuilder: (context, index) {
                    final profile = filteredPros[index];

                    ImageProvider? avatarImg;
                    if (profile.profileImageUrl.startsWith('data:image')) {
                      try {
                        avatarImg = MemoryImage(
                          base64Decode(profile.profileImageUrl.split(',').last),
                        );
                      } catch (_) {}
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.green.shade200,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserProfileScreen(profile: profile),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFF008751),
                              backgroundImage: avatarImg,
                              child: avatarImg == null
                                  ? Text(
                                      profile.fullName.isNotEmpty
                                          ? profile.fullName.substring(0, 1)
                                          : 'P',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserProfileScreen(profile: profile),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        profile.fullName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF00331A),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.verified,
                                        color: Color(0xFF008751),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    profile.profession,
                                    style: const TextStyle(
                                      color: Color(0xFF006633),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        '4.9',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${profile.lga}, Lagos',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Direct Chat Button
                          IconButton(
                            icon: const Icon(
                              Icons.chat_bubble,
                              color: Color(0xFF008751),
                            ),
                            tooltip: 'Chat with Professional',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(peerProfile: profile),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        selectedItemColor: const Color(0xFF008751),
        unselectedItemColor: Colors.grey,
        onTap: (val) async {
          setState(() => _bottomNavIndex = val);
          if (val == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          } else if (val == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatsListScreen()),
            );
          } else if (val == 3) {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final doc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();
              if (doc.exists && doc.data() != null) {
                final profile = UserProfile.fromMap(doc.data()!);
                if (!mounted) return;
                Navigator.push(
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats / Inbox',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
