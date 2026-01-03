import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/mock_session.dart';
import '../services/user_profile_service.dart';
import 'signin_screen.dart';
import 'profile_screen.dart';
import 'poll_screen.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _profileService = UserProfileService();

  @override
  void initState() {
    super.initState();
    _goNext();
  }

  /// ✅ Web/Chrome sometimes needs a moment to restore session.
  /// This waits a bit for authStateChanges() before deciding user == null.
  Future<User?> _restoreUser() async {
    final current = FirebaseAuth.instance.currentUser;
    if (current != null) return current;

    try {
      return await FirebaseAuth.instance
          .authStateChanges()
          .firstWhere((u) => u != null)
          .timeout(const Duration(seconds: 2));
    } catch (_) {
      return FirebaseAuth.instance.currentUser;
    }
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 900));

    // keep daily reset logic
    MockSession.ensureDailyReset(DateTime.now());

    // ✅ use restored user (more reliable than currentUser immediately)
    final user = await _restoreUser();

    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacementNamed(context, SignInScreen.route);
      return;
    }

    // ✅ Read name from Firestore
    final name = await _profileService.getName(user.uid);
    if (!mounted) return;

    final cleanName = name?.trim();

    if (cleanName == null || cleanName.isEmpty) {
      Navigator.pushReplacementNamed(context, ProfileScreen.route);
      return;
    }

    // ✅ Cache locally so UI shows name everywhere
    MockSession.name = cleanName;
    MockSession.email = user.email;

    Navigator.pushReplacementNamed(context, PollScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    // simple splash
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}