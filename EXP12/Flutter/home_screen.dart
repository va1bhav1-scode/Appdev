import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NeoAuthApp());
}

class NeoAuthApp extends StatelessWidget {
  const NeoAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NeoAuth App",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: const SplashScreen(),

      // ✅ Register Routes Here
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
