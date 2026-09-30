import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../utils/lagos_lgas.dart';
import '../customer/customer_home_screen.dart';
import '../professional/professional_dashboard_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  final String role; // 'customer' or 'professional'
  const PhoneAuthScreen({super.key, required this.role});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  String selectedState = LagosData.state;
  String selectedLga = LagosData.localGovernments[0];

  bool _otpSent = false;
  bool _isLoading = false;
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.role == 'customer'
              ? 'Customer Signup & Login'
              : 'Professional Onboarding & Signup',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.verified_user, size: 64, color: Color(0xFF008751)),
            const SizedBox(height: 16),
            Text(
              _otpSent
                  ? 'Enter 6-digit SMS OTP'
                  : 'Create Account / Sign In with Phone',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _otpSent
                  ? 'Enter code sent to +234 ${_phoneController.text}'
                  : 'Realtime Firebase Authentication for OgaFix Marketplace',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            if (!_otpSent) ...[
              const Text(
                'Select Lagos LGA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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
                const SizedBox(height: 8),
                TextField(
                  controller: _professionController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Master Plumber, Electrician',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                'Phone Number (+234)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixText: '+234 ',
                  hintText: '8012345678',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final phone = _phoneController.text.trim();
                  if (phone.length < 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a valid Nigerian phone number.',
                        ),
                      ),
                    );
                    return;
                  }
                  setState(() => _isLoading = true);
                  final formattedPhone =
                      '+234${phone.startsWith('0') ? phone.substring(1) : phone}';

                  await _authService.verifyPhoneNumber(
                    phoneNumber: formattedPhone,
                    onCodeSent: (verId) {
                      setState(() {
                        _verificationId = verId;
                        _otpSent = true;
                        _isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'OTP sent successfully via Firebase Auth!',
                          ),
                        ),
                      );
                    },
                    onError: (err) {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Error: $err')));
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008751),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Send Realtime OTP'),
              ),
            ] else ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: '123456',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_verificationId == null ||
                      _otpController.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid 6-digit OTP code.'),
                      ),
                    );
                    return;
                  }
                  setState(() => _isLoading = true);
                  try {
                    final userCred = await _authService.signInWithOTP(
                      verificationId: _verificationId!,
                      smsCode: _otpController.text.trim(),
                    );

                    if (userCred?.user != null) {
                      await _authService.saveUserProfile(
                        uid: userCred!.user!.uid,
                        phone: _phoneController.text.trim(),
                        role: widget.role,
                        state: selectedState,
                        lga: selectedLga,
                        profession: widget.role == 'professional'
                            ? _professionController.text.trim()
                            : null,
                      );
                    }

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
                      SnackBar(content: Text('Authentication failed: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008751),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Verify & Register in Firestore'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
