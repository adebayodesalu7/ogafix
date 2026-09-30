import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'auth/profile_onboarding_screen.dart';
import 'customer/customer_home_screen.dart';
import 'professional/professional_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if profile exists in Firestore
      final profile = await _authService.getUserProfile(user.uid);
      if (!mounted) return;

      if (profile != null) {
        if (profile.role == 'professional') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfessionalDashboardScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CustomerHomeScreen()),
          );
        }
      } else {
        // Profile missing - force onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileOnboardingScreen(
              uid: user.uid,
              email: user.email ?? '',
              phone: user.phoneNumber ?? '',
              role: 'customer',
            ),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008751), // Nigerian Green brand color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.handyman_rounded,
                size: 64,
                color: Color(0xFF008751),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'FindAPro',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find Someone Who Can',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
