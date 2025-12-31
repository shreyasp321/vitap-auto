import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // ✅ NEW IMPORT

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIT Auto', // ✅ CHANGED TITLE
      debugShowCheckedModeBanner: false, // ✅ REMOVE DEBUG BANNER
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: SplashScreen(), // ✅ CHANGED HOME SCREEN
    );
  }
}