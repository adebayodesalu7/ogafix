import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ogafix/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint('Firebase initialization timeout or error: $e');
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
