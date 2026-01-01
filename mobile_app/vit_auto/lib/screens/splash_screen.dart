import 'package:flutter/material.dart';
import '../services/mock_session.dart';
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
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 900), () {
      MockSession.ensureDailyReset(DateTime.now());

      if (!MockSession.isSignedIn) {
        Navigator.pushReplacementNamed(context, SignInScreen.route);
      } else if (!MockSession.hasName) {
        Navigator.pushReplacementNamed(context, ProfileScreen.route);
      } else {
        Navigator.pushReplacementNamed(context, PollScreen.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.directions_car_rounded, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 14),
            const Text("VIT Auto", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text("Know the rush. Pick your time.", style: TextStyle(color: Color(0xFF6B7280))),
            const SizedBox(height: 18),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
