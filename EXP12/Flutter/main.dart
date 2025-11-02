import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';

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
      theme: AppTheme.appTheme.copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black,
          ), // ✅ Make typing text visible
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
