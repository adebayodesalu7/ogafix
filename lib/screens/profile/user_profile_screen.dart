import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import '../../models/user_profile_model.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../chat/chats_list_screen.dart';
import '../customer/customer_home_screen.dart';
import '../customer/map_search_screen.dart';
import '../customer/search_screen.dart';
import '../professional/professional_dashboard_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const UserProfileScreen({super.key, required this.profile});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthService _authService = AuthService();
  bool _isUploading = false;
  int _bottomNavIndex = 4; // Profile tab selected

  Future<void> _pickAndChangeImage(UserProfile currentProfile) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != currentProfile.uid) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _isUploading = true);

      final bytes = await File(pickedFile.path).readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      final updated = UserProfile(
        uid: currentProfile.uid,
        email: currentProfile.email,
        phone: currentProfile.phone,
        role: currentProfile.role,
        fullName: currentProfile.fullName,
        state: currentProfile.state,
        lga: currentProfile.lga,
        stateOfOrigin: currentProfile.stateOfOrigin,
        yearsOfExperience: currentProfile.yearsOfExperience,
        profession: currentProfile.profession,
        ninNumber: currentProfile.ninNumber,
        description: currentProfile.description,
        profileImageUrl: base64Image,
        jobStatuses: currentProfile.jobStatuses,
        verificationLevel: currentProfile.verificationLevel,
        emailVerified: currentProfile.emailVerified,
        phoneVerified: currentProfile.phoneVerified,
        ninVerified: currentProfile.ninVerified,
      );

      await _authService.saveCompleteUserProfile(updated);
      setState(() => _isUploading = false);
    }
  }

  void _showPreferencesDialog(UserProfile currentProfile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Preferences', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text(
                'Dark Theme Mode',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Toggle between light and dark appearance',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              secondary: const Icon(Icons.dark_mode, color: Color(0xFF008751)),
              value: themeModeNotifier.value == ThemeMode.dark,
              onChanged: (val) {
                themeModeNotifier.value = val
                    ? ThemeMode.dark
                    : ThemeMode.light;
                setState(() {});
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFF008751)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.profile.uid)
          .snapshots(),
      builder: (context, snapshot) {
        UserProfile currentProfile = widget.profile;
        if (snapshot.hasData &&
            snapshot.data!.exists &&
            snapshot.data!.data() != null) {
          currentProfile = UserProfile.fromMap(
            snapshot.data!.data() as Map<String, dynamic>,
          );
        }

        final bool isMyProfile = currentUserId == currentProfile.uid;

        ImageProvider? avatarBg;
        if (currentProfile.profileImageUrl.startsWith('data:image')) {
          try {
            avatarBg = MemoryImage(
              base64Decode(currentProfile.profileImageUrl.split(',').last),
            );
          } catch (_) {}
        } else if (currentProfile.profileImageUrl.startsWith('http')) {
          avatarBg = NetworkImage(currentProfile.profileImageUrl);
        } else if (currentProfile.profileImageUrl.isNotEmpty &&
            File(currentProfile.profileImageUrl).existsSync()) {
          avatarBg = FileImage(File(currentProfile.profileImageUrl));
        }

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Dark Green Header matching Screenshot 5
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
                  decoration: const BoxDecoration(color: Color(0xFF00331A)),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: const Color(0xFF008751),
                            backgroundImage: avatarBg,
                            child: avatarBg == null
                                ? Text(
                                    currentProfile.fullName.isNotEmpty
                                        ? currentProfile.fullName.substring(
                                            0,
                                            1,
                                          )
                                        : 'A',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                          if (isMyProfile)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () =>
                                    _pickAndChangeImage(currentProfile),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF008751),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          currentProfile.fullName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildMenuTile(Icons.bookmark_border, 'My interests', () {}),
                _buildMenuTile(Icons.send_outlined, 'Invite friends', () {}),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                _buildMenuTile(
                  Icons.settings_outlined,
                  'Preferences',
                  () => _showPreferencesDialog(currentProfile),
                ),
                _buildMenuTile(Icons.person_outline, 'Account', () {}),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Resources',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                _buildMenuTile(Icons.help_outline, 'Support', () {}),
                _buildMenuTile(
                  Icons.info_outline,
                  'Community and legal',
                  () {},
                ),
                _buildMenuTile(
                  Icons.card_giftcard,
                  'Become a seller',
                  () async {
                    // Switch role to professional
                    final updatedProfile = UserProfile(
                      uid: currentProfile.uid,
                      email: currentProfile.email,
                      phone: currentProfile.phone,
                      role: 'professional',
                      fullName: currentProfile.fullName,
                      state: currentProfile.state,
                      lga: currentProfile.lga,
                      stateOfOrigin: currentProfile.stateOfOrigin,
                      yearsOfExperience: currentProfile.yearsOfExperience,
                      profession: 'Master Artisan',
                      ninNumber: currentProfile.ninNumber,
                      description: currentProfile.description,
                      profileImageUrl: currentProfile.profileImageUrl,
                      jobStatuses: currentProfile.jobStatuses,
                      verificationLevel: currentProfile.verificationLevel,
                      emailVerified: currentProfile.emailVerified,
                      phoneVerified: currentProfile.phoneVerified,
                      ninVerified: currentProfile.ninVerified,
                    );
                    await _authService.saveCompleteUserProfile(updatedProfile);
                    if (!mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ProfessionalDashboardScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
                if (isMyProfile) ...[
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await _authService.signOut();
                          if (!mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    '4.5.0',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _bottomNavIndex,
            backgroundColor: const Color(0xFF1E1E1E),
            selectedItemColor: const Color(0xFF008751),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            onTap: (val) {
              setState(() => _bottomNavIndex = val);
              if (val == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerHomeScreen(),
                  ),
                );
              } else if (val == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatsListScreen(),
                  ),
                );
              } else if (val == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              } else if (val == 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapSearchScreen(),
                  ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mail_outline),
                label: '',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: '',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      leading: Icon(icon, color: const Color(0xFF008751)),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
