import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ogafix/screens/splash_screen.dart';

final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
  ThemeMode.light,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 5));
  } catch (_) {}
  runApp(const OgaFixApp());
}

class OgaFixApp extends StatelessWidget {
  const OgaFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'FindAPro - Find Someone Who Can',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(
                0xFF008751,
              ), // Nigerian Green primary accent
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
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF008751),
              brightness: Brightness.dark,
              primary: const Color(0xFF008751),
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
