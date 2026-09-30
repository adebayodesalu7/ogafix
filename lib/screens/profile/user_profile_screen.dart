import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_profile_model.dart';
import '../../services/auth_service.dart';

class UserProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const UserProfileScreen({super.key, required this.profile});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthService _authService = AuthService();
  late UserProfile _currentProfile;
  File? _imageFile;
  bool _isUploading = false;

  final List<String> _jobStatuses = [
    'https://images.unsplash.com/photo-1581092160607-ee22621dd758',
    'https://images.unsplash.com/photo-1581092335397-9583fe92d232',
    'https://images.unsplash.com/photo-1621905251189-08b45d6a269e',
  ];

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.profile;
  }

  Future<void> _pickAndChangeImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isUploading = true;
      });

      await Future.delayed(const Duration(seconds: 1));
      
      final updated = UserProfile(
        uid: _currentProfile.uid,
        email: _currentProfile.email,
        phone: _currentProfile.phone,
        role: _currentProfile.role,
        fullName: _currentProfile.fullName,
        state: _currentProfile.state,
        lga: _currentProfile.lga,
        stateOfOrigin: _currentProfile.stateOfOrigin,
        age: _currentProfile.age,
        yearsOfExperience: _currentProfile.yearsOfExperience,
        profession: _currentProfile.profession,
        ninNumber: _currentProfile.ninNumber,
        description: _currentProfile.description,
        profileImageUrl: pickedFile.path,
        verificationLevel: _currentProfile.verificationLevel,
        emailVerified: _currentProfile.emailVerified,
        phoneVerified: _currentProfile.phoneVerified,
        ninVerified: _currentProfile.ninVerified,
      );

      await _authService.saveCompleteUserProfile(updated);
      setState(() {
        _currentProfile = updated;
        _isUploading = false;
      });
    }
  }

  void _showFullScreenImage() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: _imageFile != null
                  ? Image.file(_imageFile!)
                  : (_currentProfile.profileImageUrl.isNotEmpty && !_currentProfile.profileImageUrl.startsWith('http'))
                      ? Image.file(File(_currentProfile.profileImageUrl))
                      : Image.network('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('${_currentProfile.fullName} Profile'),
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
                  onTap: _showFullScreenImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xFF008751).withValues(alpha: 0.2),
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (_currentProfile.profileImageUrl.isNotEmpty && !_currentProfile.profileImageUrl.startsWith('http'))
                            ? FileImage(File(_currentProfile.profileImageUrl)) as ImageProvider
                            : const NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
                    child: _isUploading ? const CircularProgressIndicator(color: Colors.white) : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _pickAndChangeImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF008751),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _currentProfile.fullName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _currentProfile.profession,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF008751),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Chip(
              avatar: const Icon(Icons.verified, color: Colors.white, size: 16),
              label: Text(
                'Verification Level ${_currentProfile.verificationLevel} (NIN & Phone Verified)',
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
                    const Text(
                      'Professional & Personal Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF008751),
                      ),
                    ),
                    const Divider(color: Colors.green),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Location',
                      '${_currentProfile.lga}, ${_currentProfile.state}',
                    ),
                    _buildDetailRow('State of Origin', _currentProfile.stateOfOrigin),
                    _buildDetailRow('Age', '${_currentProfile.age} years'),
                    _buildDetailRow(
                      'Experience',
                      '${_currentProfile.yearsOfExperience} years',
                    ),
                    _buildDetailRow('Phone', _currentProfile.phone),
                    _buildDetailRow('Email', _currentProfile.email),
                    _buildDetailRow(
                      'NIN Status',
                      _currentProfile.ninNumber.isNotEmpty
                          ? 'Verified (11-digit)'
                          : 'Pending',
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
                      _currentProfile.description.isNotEmpty
                          ? _currentProfile.description
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Finished Job Statuses & Stories',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF008751)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _jobStatuses.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF008751), width: 2),
                              image: DecorationImage(
                                image: NetworkImage(_jobStatuses[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  'Completed',
                                  style: TextStyle(color: Colors.white, fontSize: 10, backgroundColor: Colors.black45),
                                ),
                              ),
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
        ),
      ),
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
