import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile_model.dart';
import '../chat/chat_screen.dart';
import '../profile/user_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Plumbing',
    'Electrical',
    'Web Designer',
    'App Developer',
    'AC & Refrigeration',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Handymen & Services'),
        backgroundColor: const Color(0xFF008751),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText:
                    'Search plumber, web designer, app developer, Ikeja...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF008751)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: const Color(0xFF008751),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) =>
                          setState(() => _selectedFilter = filter),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('professional_profiles')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No verified professionals registered in the database yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final firestorePros = snapshot.data!.docs.map((doc) {
                    return UserProfile.fromMap(
                      doc.data() as Map<String, dynamic>,
                    );
                  }).toList();

                  final filteredPros = firestorePros.where((pro) {
                    final matchesQuery =
                        pro.fullName.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        pro.profession.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        pro.lga.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        );
                    final matchesFilter =
                        _selectedFilter == 'All' ||
                        pro.profession.toLowerCase().contains(
                          _selectedFilter.toLowerCase(),
                        );
                    return matchesQuery && matchesFilter;
                  }).toList();

                  if (filteredPros.isEmpty) {
                    return const Center(
                      child: Text(
                        'No professionals found matching your search.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredPros.length,
                    itemBuilder: (context, index) {
                      final profile = filteredPros[index];

                      ImageProvider? avatarImg;
                      if (profile.profileImageUrl.startsWith('data:image')) {
                        try {
                          avatarImg = MemoryImage(
                            base64Decode(
                              profile.profileImageUrl.split(',').last,
                            ),
                          );
                        } catch (_) {}
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: const Color(0xFF008751),
                              backgroundImage: avatarImg,
                              child: avatarImg == null
                                  ? Text(
                                      profile.fullName.isNotEmpty
                                          ? profile.fullName.substring(0, 1)
                                          : 'P',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 14),
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
                                    Text(
                                      profile.fullName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      profile.profession,
                                      style: const TextStyle(
                                        color: Color(0xFF008751),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${profile.lga}, Lagos • Level ${profile.verificationLevel} Verified',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
            ),
          ],
        ),
      ),
    );
  }
}
