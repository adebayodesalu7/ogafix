import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../customer/customer_home_screen.dart';
import '../professional/professional_dashboard_screen.dart';
import 'profile_onboarding_screen.dart';

class AuthScreen extends StatefulWidget {
  final String role; // 'customer' or 'professional'
  const AuthScreen({super.key, required this.role});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _identifierController =
      TextEditingController(); // Email or Phone
  final TextEditingController _passwordController =
      TextEditingController(); // For email login/signup
  final TextEditingController _otpController = TextEditingController();

  bool _isSignUp = true;
  bool _isPhoneInput = false;
  bool _otpSent = false;
  bool _isLoading = false;
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          _isSignUp
              ? 'FindAPro Signup (${widget.role})'
              : 'FindAPro Sign In (${widget.role})',
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Low-opacity Green Leaf / Curved Graphic Accent
          Positioned(
            top: -50,
            right: -50,
            child: Opacity(
              opacity: 0.12,
              child: Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  color: Color(0xFF008751),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(150),
                    topLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF008751).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF008751).withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.handyman_rounded,
                      size: 48,
                      color: Color(0xFF008751),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _isSignUp
                      ? 'Create Your Account'
                      : 'Welcome Back to FindAPro',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sign up or sign in using Email, Phone Number, or Google Sign-In.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _identifierController,
                  decoration: InputDecoration(
                    labelText: 'Email Address or Phone Number (+234...)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF008751),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _isPhoneInput =
                          double.tryParse(val.replaceAll('+', '')) != null ||
                          val.startsWith('+') ||
                          val.length >= 10 && !val.contains('@');
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (!_isPhoneInput) ...[
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password (min 6 chars)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF008751),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (_isPhoneInput && _otpSent) ...[
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'Enter 6-Digit OTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.sms_outlined,
                        color: Color(0xFF008751),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008751),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _otpSent
                                ? 'Verify OTP & Continue'
                                : (_isSignUp ? 'Continue Signup' : 'Sign In'),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                // Google Sign-In Button (for both service seller and service finder)
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  icon: const Icon(
                    Icons.g_mobiledata,
                    size: 32,
                    color: Color(0xFF008751),
                  ),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.grey, width: 1.5),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(
                    _isSignUp
                        ? 'Already have an account? Sign In'
                        : "Don't have an account? Sign Up",
                    style: const TextStyle(color: Color(0xFF008751)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final result = await _authService.signInWithGoogle();
      final userCred = result['userCred'] as UserCredential?;
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (userCred?.user != null) {
        final profile = await _authService.getUserProfile(userCred!.user!.uid);
        if (!mounted) return;

        if (profile != null) {
          _navigateHome(profile.role);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileOnboardingScreen(
                uid: userCred.user!.uid,
                email: userCred.user!.email ?? '',
                phone: userCred.user!.phoneNumber ?? '',
                role: widget.role,
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Google Sign-In failed: $e')));
    }
  }

  Future<void> _handleSubmit() async {
    final identifier = _identifierController.text.trim();
    if (identifier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email or phone number.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isPhoneInput) {
        // Phone Authentication flow
        if (!_otpSent) {
          final formattedPhone = identifier.startsWith('+')
              ? identifier
              : '+234${identifier.startsWith('0') ? identifier.substring(1) : identifier}';

          final existing = await _authService.checkExistingUser(
            phone: formattedPhone,
          );
          if (_isSignUp && existing['phoneExists']!) {
            setState(() => _isLoading = false);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'This phone number is already registered. Please sign in instead.',
                ),
              ),
            );
            return;
          }

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
                  content: Text('OTP sent successfully to your phone!'),
                ),
              );
            },
            onError: (err) {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Phone Auth Error: $err')));
            },
          );
        } else {
          final userCred = await _authService.signInWithOTP(
            verificationId: _verificationId!,
            smsCode: _otpController.text.trim(),
          );

          if (!mounted) return;
          setState(() => _isLoading = false);

          if (userCred?.user != null) {
            if (_isSignUp) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileOnboardingScreen(
                    uid: userCred!.user!.uid,
                    email: '',
                    phone: identifier,
                    role: widget.role,
                  ),
                ),
              );
            } else {
              _navigateHome(widget.role);
            }
          }
        }
      } else {
        final password = _passwordController.text.trim();
        if (password.length < 6) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password must be at least 6 characters.'),
            ),
          );
          return;
        }

        final existing = await _authService.checkExistingUser(
          email: identifier,
        );
        if (_isSignUp && existing['emailExists']!) {
          setState(() => _isLoading = false);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'This email address is already registered. Please sign in instead.',
              ),
            ),
          );
          return;
        }

        if (_isSignUp) {
          final userCred = await _authService.signUpWithEmail(
            email: identifier,
            password: password,
          );
          if (!mounted) return;
          setState(() => _isLoading = false);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileOnboardingScreen(
                uid: userCred.user!.uid,
                email: identifier,
                phone: '',
                role: widget.role,
              ),
            ),
          );
        } else {
          await _authService.signInWithEmail(
            email: identifier,
            password: password,
          );
          if (!mounted) return;
          setState(() => _isLoading = false);
          _navigateHome(widget.role);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Authentication error: $e')));
    }
  }

  void _navigateHome(String role) {
    if (role == 'customer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CustomerHomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfessionalDashboardScreen(),
        ),
      );
    }
  }
}
