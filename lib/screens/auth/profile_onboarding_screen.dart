import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_profile_model.dart';
import '../../services/auth_service.dart';
import '../../utils/lagos_lgas.dart';
import '../customer/customer_home_screen.dart';
import '../professional/professional_dashboard_screen.dart';

class ProfileOnboardingScreen extends StatefulWidget {
  final String uid;
  final String email;
  final String phone;
  final String role;

  const ProfileOnboardingScreen({
    super.key,
    required this.uid,
    required this.email,
    required this.phone,
    required this.role,
  });

  @override
  State<ProfileOnboardingScreen> createState() =>
      _ProfileOnboardingScreenState();
}

class _ProfileOnboardingScreenState extends State<ProfileOnboardingScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _stateOfOriginController =
      TextEditingController();
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _ninController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String selectedLga = LagosData.localGovernments[0];
  String selectedProfession = 'Plumbing';
  bool _isLoading = false;
  File? _profileImageFile;

  final List<String> professions = [
    'Plumbing',
    'Electrical',
    'AC & Refrigeration',
    'Generator Repair',
    'Cleaning',
    'Carpentry',
    'Painting',
    'Appliance Repair',
    'Web Designer',
    'App Developer',
  ];

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phone;
    _emailController.text =
        (widget.email.contains('@ogafix.ng') && widget.phone.isNotEmpty)
        ? ''
        : widget.email;
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: const Color(0xFF008751),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to OgaFix Onboarding!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008751),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Please fill in your profile details to start connecting on OgaFix.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              // Profile Avatar Placeholder
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: const Color(0xFF008751)
                          .withValues(alpha: 0.2),
                      backgroundImage: _profileImageFile != null
                          ? FileImage(_profileImageFile!)
                          : null,
                      child: _profileImageFile == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Color(0xFF008751),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickProfileImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF008751),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Optional NIN Number Field (No blocking validation)
              TextFormField(
                controller: _ninController,
                maxLength: 11,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'NIN Number (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.verified_user,
                    color: Color(0xFF008751),
                  ),
                ),
                validator: (val) => null, // Optional, never blocks
              ),
              const SizedBox(height: 12),
              // Full Name Field (Manual input)
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter full name'
                    : null,
              ),
              const SizedBox(height: 16),
              // Email Field (Always collected)
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (val) => val == null || !val.contains('@')
                    ? 'Enter valid email address'
                    : null,
              ),
              const SizedBox(height: 16),
              // Phone Field (Always collected)
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (val) => val == null || val.length < 10
                    ? 'Enter valid phone number'
                    : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Lagos Local Government Area (LGA)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedLga,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: LagosData.localGovernments.map((lga) {
                  return DropdownMenuItem(value: lga, child: Text(lga));
                }).toList(),
                onChanged: (val) =>
                    setState(() => selectedLga = val ?? selectedLga),
              ),
              if (widget.role == 'professional') ...[
                const SizedBox(height: 16),
                const Text(
                  'Profession / Trade',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedProfession,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: professions.map((prof) {
                    return DropdownMenuItem(value: prof, child: Text(prof));
                  }).toList(),
                  onChanged: (val) => setState(
                    () => selectedProfession = val ?? selectedProfession,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _expController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Years of Experience',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (val) => val == null || int.tryParse(val) == null
                      ? 'Enter years of experience'
                      : null,
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _stateOfOriginController,
                decoration: InputDecoration(
                  labelText: 'State of Origin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 5,
                maxLength: 1000,
                decoration: InputDecoration(
                  labelText: 'Professional Description & Experience (Bio)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  helperText: 'Describe your background and technologies used (max 1000 words).',
                ),
                validator: (val) => val == null || val.length < 20
                    ? 'Please provide at least 20 characters'
                    : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _isLoading = true);
                    try {
                      String base64Avatar = '';
                      if (_profileImageFile != null) {
                        final bytes = await _profileImageFile!.readAsBytes();
                        base64Avatar =
                            'data:image/jpeg;base64,${base64Encode(bytes)}';
                      }

                      final profile = UserProfile(
                        uid: widget.uid,
                        email: _emailController.text.trim(),
                        phone: _phoneController.text.trim(),
                        role: widget.role,
                        fullName: _fullNameController.text.trim(),
                        state: LagosData.state,
                        lga: selectedLga,
                        stateOfOrigin: _stateOfOriginController.text.trim(),
                        yearsOfExperience: widget.role == 'professional'
                            ? int.parse(_expController.text.trim())
                            : 0,
                        profession: widget.role == 'professional'
                            ? selectedProfession
                            : 'Customer',
                        ninNumber: _ninController.text.trim(),
                        description: _descController.text.trim(),
                        profileImageUrl: base64Avatar,
                        jobStatuses: [],
                        verificationLevel:
                            _ninController.text.trim().length == 11 ? 3 : 2,
                        emailVerified: true,
                        phoneVerified: true,
                        ninVerified: _ninController.text.trim().length == 11,
                      );

                      await _authService.saveCompleteUserProfile(profile);

                      if (!mounted) return;
                      setState(() => _isLoading = false);

                      if (widget.role == 'customer') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomerHomeScreen(),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ProfessionalDashboardScreen(),
                          ),
                        );
                      }
                    } catch (e) {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error saving profile: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008751),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Profile & Complete Onboarding'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
