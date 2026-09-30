import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user_profile_model.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const UserProfileScreen({super.key, required this.profile});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthService _authService = AuthService();
  bool _isUploading = false;

  Future<void> _pickAndChangeImage(UserProfile currentProfile) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != currentProfile.uid)
      return; // Security: only owner can edit

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

  void _showFullScreenImage(UserProfile currentProfile) {
    ImageProvider? fullImg;
    if (currentProfile.profileImageUrl.startsWith('data:image')) {
      try {
        fullImg = MemoryImage(
          base64Decode(currentProfile.profileImageUrl.split(',').last),
        );
      } catch (_) {}
    } else if (currentProfile.profileImageUrl.startsWith('http')) {
      fullImg = NetworkImage(currentProfile.profileImageUrl);
    } else if (currentProfile.profileImageUrl.isNotEmpty &&
        File(currentProfile.profileImageUrl).existsSync()) {
      fullImg = FileImage(File(currentProfile.profileImageUrl));
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: fullImg != null
                  ? Image(image: fullImg)
                  : const CircleAvatar(
                      radius: 80,
                      child: Icon(Icons.person, size: 80),
                    ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _addStatus(UserProfile currentProfile, bool isVideo) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != currentProfile.uid) return;

    final picker = ImagePicker();
    final picked = isVideo
        ? await picker.pickVideo(source: ImageSource.gallery)
        : await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await File(picked.path).readAsBytes();
      final base64Media =
          'data:${isVideo ? 'video/mp4' : 'image/jpeg'};base64,${base64Encode(bytes)}';
      final prefix = isVideo ? 'video:' : 'image:';
      final statusEntry = '$prefix$base64Media';
      final updatedStatuses = List<String>.from(currentProfile.jobStatuses)
        ..add(statusEntry);

      final updatedProfile = UserProfile(
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
        jobStatuses: updatedStatuses,
        verificationLevel: currentProfile.verificationLevel,
        emailVerified: currentProfile.emailVerified,
        phoneVerified: currentProfile.phoneVerified,
        ninVerified: currentProfile.ninVerified,
      );

      await _authService.saveCompleteUserProfile(updatedProfile);
    }
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
        final bool isProfessional = currentProfile.role == 'professional';

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
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: Text(
              '${currentProfile.fullName} (${isProfessional ? 'Professional Profile' : 'Customer Profile'})',
            ),
            backgroundColor: const Color(0xFF008751),
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    InkWell(
                      onTap: () => _showFullScreenImage(currentProfile),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(0xFF008751)
                            .withValues(alpha: 0.2),
                        backgroundImage: avatarBg,
                        child: avatarBg == null
                            ? const Icon(
                                Icons.person,
                                size: 55,
                                color: Color(0xFF008751),
                              )
                            : (_isUploading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : null),
                      ),
                    ),
                    if (isMyProfile)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () => _pickAndChangeImage(currentProfile),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF008751),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  currentProfile.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isProfessional
                      ? currentProfile.profession
                      : 'FindAPro Valued Customer',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF008751),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Chip(
                  avatar: const Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text(
                    isProfessional
                        ? 'Verification Level ${currentProfile.verificationLevel} (NIN & Phone Verified)'
                        : 'Customer Account (Phone & Email Verified)',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFF008751),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.green.shade200),
                  ),
                  color: const Color(0xFFE8F5E9),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isProfessional
                              ? 'Professional Details'
                              : 'Customer Details',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF008751),
                          ),
                        ),
                        const Divider(color: Colors.green),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          'Location',
                          '${currentProfile.lga}, ${currentProfile.state}',
                        ),
                        _buildDetailRow(
                          'State of Origin',
                          currentProfile.stateOfOrigin,
                        ),
                        if (isProfessional)
                          _buildDetailRow(
                            'Experience',
                            '${currentProfile.yearsOfExperience} years',
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Phone',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    _launchPhoneDialer(currentProfile.phone),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 16,
                                      color: Color(0xFF008751),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      currentProfile.phone,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF008751),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildDetailRow('Email', currentProfile.email),
                        _buildDetailRow(
                          'Account Type',
                          isProfessional
                              ? 'Professional Service Provider'
                              : 'Customer / Job Poster',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Professional Bio & Description ONLY for professionals
                if (isProfessional) ...[
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Professional Bio & Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            currentProfile.description.isNotEmpty
                                ? currentProfile.description
                                : 'No professional description provided yet.',
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.green.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Finished Job Statuses & Video Stories',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF008751),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isMyProfile)
                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color(0xFF008751),
                                  ),
                                  onSelected: (val) {
                                    if (val == 'image') {
                                      _addStatus(currentProfile, false);
                                    } else if (val == 'video') {
                                      _addStatus(currentProfile, true);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'image',
                                      child: Text('Add Image Status'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'video',
                                      child: Text('Add Video Status'),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          currentProfile.jobStatuses.isEmpty
                              ? const Text(
                                  'No finished job statuses or videos posted yet.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                )
                              : SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        currentProfile.jobStatuses.length,
                                    itemBuilder: (context, index) {
                                      final entry =
                                          currentProfile.jobStatuses[index];
                                      final isVideo = entry.startsWith(
                                        'video:',
                                      );
                                      final dataStr = entry.replaceFirst(
                                        RegExp(r'^(image:|video:)'),
                                        '',
                                      );

                                      ImageProvider? statusImg;
                                      if (dataStr.startsWith('data:image')) {
                                        try {
                                          statusImg = MemoryImage(
                                            base64Decode(
                                              dataStr.split(',').last,
                                            ),
                                          );
                                        } catch (_) {}
                                      } else if (File(dataStr).existsSync()) {
                                        statusImg = FileImage(File(dataStr));
                                      }

                                      return Container(
                                        margin: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        width: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFF008751),
                                            width: 2,
                                          ),
                                          color: Colors.black12,
                                          image: statusImg != null
                                              ? DecorationImage(
                                                  image: statusImg,
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            if (isVideo)
                                              const Icon(
                                                Icons.play_circle_fill,
                                                color: Colors.white,
                                                size: 36,
                                              ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  4.0,
                                                ),
                                                child: Text(
                                                  isVideo
                                                      ? 'Video Story'
                                                      : 'Completed',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    backgroundColor:
                                                        Colors.black45,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (isMyProfile) ...[
                  const SizedBox(height: 32),
                  SizedBox(
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
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
