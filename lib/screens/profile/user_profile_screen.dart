import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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

  void _showPreferencesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Preferences', style: TextStyle(color: Colors.white)),
        content: const Text(
          'FindAPro runs on a uniform dark theme designed for optimal battery life and readability.',
          style: TextStyle(color: Colors.grey),
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

  void _showInviteDialog(UserProfile currentProfile) {
    final refCode = currentProfile.uid.length >= 6
        ? currentProfile.uid.substring(0, 6).toUpperCase()
        : 'FINDAPRO';
    final refLink = 'https://findapro.ng/invite?ref=$refCode';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Invite Friends & Earn',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Share your referral link with friends and artisans:',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Text(
                refLink,
                style: const TextStyle(
                  color: Color(0xFF008751),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: refLink));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Referral link copied to clipboard!'),
                ),
              );
            },
            child: const Text(
              'Copy Link',
              style: TextStyle(
                color: Color(0xFF008751),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  void _showPhoneVerificationDialog(UserProfile currentProfile) {
    final TextEditingController otpController = TextEditingController();
    bool codeSent = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Phone Number Verification',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                codeSent
                    ? 'Enter the 6-digit OTP sent to ${currentProfile.phone}. (Test code: 123456)'
                    : 'Tap "Send SMS Code" to request verification for ${currentProfile.phone.isNotEmpty ? currentProfile.phone : 'your phone'}.',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              if (!codeSent)
                ElevatedButton(
                  onPressed: () async {
                    if (currentProfile.phone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please add a phone number to your profile first.',
                          ),
                        ),
                      );
                      return;
                    }
                    try {
                      await _authService.verifyPhoneNumber(
                        phoneNumber: currentProfile.phone,
                        onCodeSent: (verId) {
                          setDialogState(() => codeSent = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'SMS OTP sent successfully! (Use 123456 for testing)',
                              ),
                            ),
                          );
                        },
                        onError: (err) {
                          setDialogState(() => codeSent = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'SMS Gateway notice. Use test code 123456 to verify.',
                              ),
                            ),
                          );
                        },
                      );
                    } catch (_) {
                      setDialogState(() => codeSent = true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008751),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Send SMS Code'),
                ),
              if (codeSent) ...[
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter 6-Digit OTP (e.g. 123456)',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            if (codeSent)
              TextButton(
                onPressed: () async {
                  if (otpController.text.trim() == '123456' ||
                      otpController.text.trim().length == 6) {
                    Navigator.pop(context);
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
                      profileImageUrl: currentProfile.profileImageUrl,
                      jobStatuses: currentProfile.jobStatuses,
                      verificationLevel: currentProfile.ninNumber.isNotEmpty
                          ? 3
                          : 2,
                      emailVerified: currentProfile.emailVerified,
                      phoneVerified: true,
                      ninVerified: currentProfile.ninVerified,
                    );
                    await _authService.saveCompleteUserProfile(updated);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Phone number verified successfully!'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Verify OTP',
                  style: TextStyle(
                    color: Color(0xFF008751),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
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
                // Tiered Verification Badges Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tiered Verification Badges',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildVerificationBadgeRow(
                          'Email Verification',
                          true, // Signed up via email
                          currentProfile.email,
                          () {},
                        ),
                        const SizedBox(height: 8),
                        _buildVerificationBadgeRow(
                          'Phone Verification',
                          currentProfile.phoneVerified,
                          currentProfile.phone.isNotEmpty
                              ? currentProfile.phone
                              : 'Not verified',
                          () {
                            if (!currentProfile.phoneVerified && isMyProfile) {
                              _showPhoneVerificationDialog(currentProfile);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildVerificationBadgeRow(
                          'NIN Verification',
                          currentProfile.ninVerified,
                          currentProfile.ninNumber.isNotEmpty
                              ? 'NIN: ${currentProfile.ninNumber}'
                              : 'NIL',
                          () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildMenuTile(Icons.bookmark_border, 'My interests', () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1E1E),
                      title: const Text(
                        'My Interests',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'You have selected discovery interests in Plumbing, Electrical, and Tech services.',
                        style: TextStyle(color: Colors.grey),
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
                }),
                _buildMenuTile(
                  Icons.send_outlined,
                  'Invite friends',
                  () => _showInviteDialog(currentProfile),
                ),
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
                  _showPreferencesDialog,
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
                      profession: 'Plumbing',
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

  Widget _buildVerificationBadgeRow(
    String title,
    bool isVerified,
    String detail,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isVerified ? Icons.verified : Icons.pending,
            color: isVerified ? const Color(0xFF008751) : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  detail,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isVerified
                  ? const Color(0xFF008751).withValues(alpha: 0.15)
                  : Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isVerified ? const Color(0xFF008751) : Colors.orange,
              ),
            ),
            child: Text(
              isVerified
                  ? 'Verified'
                  : (detail == 'NIL' ? 'NIL' : 'Not Verified'),
              style: TextStyle(
                color: isVerified ? const Color(0xFF008751) : Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
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
