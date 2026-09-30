import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ogafix/screens/admin/admin_dashboard_screen.dart';
import 'package:ogafix/screens/auth/phone_auth_screen.dart';
import 'package:ogafix/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  runApp(const OgaFixApp());
}

class OgaFixApp extends StatelessWidget {
  const OgaFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OgaFix - Find Someone Who Can',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF008751), // Nigerian Green primary accent
          primary: const Color(0xFF008751),
          secondary: const Color(0xFF1D1D1D),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1D1D1D),
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.handyman_rounded,
                size: 80,
                color: Color(0xFF008751),
              ),
              const SizedBox(height: 16),
              const Text(
                'OgaFix',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1D1D),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find Someone Who Can. Trusted local services in Lagos.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PhoneAuthScreen(role: 'customer'),
                    ),
                  );
                },
                icon: const Icon(Icons.person),
                label: const Text('Continue as Customer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008751),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PhoneAuthScreen(role: 'professional'),
                    ),
                  );
                },
                icon: const Icon(Icons.work),
                label: const Text('Continue as Professional / Artisan'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF008751),
                  side: const BorderSide(color: Color(0xFF008751)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminDashboardScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.grey,
                ),
                label: const Text(
                  'Admin Portal',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
