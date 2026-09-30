import 'package:flutter/material.dart';

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
  final TextEditingController _stateOfOriginController =
      TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _ninController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String selectedLga = LagosData.localGovernments[0];
  String selectedProfession = 'Plumbing';
  bool _isLoading = false;

  final List<String> professions = [
    'Plumbing',
    'Electrical',
    'AC & Refrigeration',
    'Generator Repair',
    'Cleaning',
    'Carpentry',
    'Painting',
    'Appliance Repair',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile Onboarding')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to OgaFix!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008751),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Please fill out your verified profile details to activate your account.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
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
                    ? 'Please enter your full name'
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
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
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
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (val) =>
                          val == null || int.tryParse(val) == null
                          ? 'Enter valid age'
                          : null,
                    ),
                  ),
                ],
              ),
              if (widget.role == 'professional') ...[
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
                controller: _ninController,
                maxLength: 11,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'NIN Number (National Identification Number)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  helperText: 'Required for Level 3 Trust & Skill Verification',
                ),
                validator: (val) => val == null || val.length != 11
                    ? 'Enter valid 11-digit NIN'
                    : null,
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
                  helperText: 'Describe your profession, past experience, and technologies/tools used (max 1000 words).',
                ),
                validator: (val) => val == null || val.length < 20
                    ? 'Please provide at least 20 characters of description'
                    : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _isLoading = true);
                    try {
                      final profile = UserProfile(
                        uid: widget.uid,
                        email: widget.email,
                        phone: widget.phone,
                        role: widget.role,
                        fullName: _fullNameController.text.trim(),
                        state: LagosData.state,
                        lga: selectedLga,
                        stateOfOrigin: _stateOfOriginController.text.trim(),
                        age: int.parse(_ageController.text.trim()),
                        yearsOfExperience: widget.role == 'professional'
                            ? int.parse(_expController.text.trim())
                            : 0,
                        profession: widget.role == 'professional'
                            ? selectedProfession
                            : 'Customer',
                        ninNumber: _ninController.text.trim(),
                        description: _descController.text.trim(),
                        profileImageUrl: '',
                        verificationLevel: 3, // Verified with NIN & Phone
                        emailVerified: true,
                        phoneVerified: true,
                        ninVerified: true,
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
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Profile & Complete Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
