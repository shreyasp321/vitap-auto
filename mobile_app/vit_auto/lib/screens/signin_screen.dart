import 'package:flutter/material.dart';
import '../services/mock_session.dart';
import '../widgets/primary_button.dart';
import 'profile_screen.dart';

class SignInScreen extends StatefulWidget {
  static const route = '/signin';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  bool otpSent = false;

  bool get emailValid =>
      emailCtrl.text.trim().toLowerCase().endsWith('@vitap.ac.in');

  @override
  void dispose() {
    emailCtrl.dispose();
    otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign in")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Use your VIT-AP email",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text("We’ll send an OTP (UI only for now).",
                  style: TextStyle(color: Color(0xFF6B7280))),
              const SizedBox(height: 16),

              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "VIT-AP Email",
                  hintText: "yourname@vitap.ac.in",
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              if (otpSent) ...[
                TextField(
                  controller: otpCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "OTP",
                    hintText: "Enter 6-digit OTP",
                  ),
                ),
                const SizedBox(height: 12),
              ],

              const Spacer(),

              PrimaryButton(
                text: otpSent ? "Verify & Continue" : "Send OTP",
                onPressed: !emailValid
                    ? null
                    : () {
                        if (!otpSent) {
                          setState(() => otpSent = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("OTP sent (mock).")),
                          );
                        } else {
                          // mock login success
                          MockSession.email = emailCtrl.text.trim().toLowerCase();
                          Navigator.pushReplacementNamed(context, ProfileScreen.route);
                        }
                      },
              ),
              const SizedBox(height: 10),

              if (!emailValid)
                const Text("Email must end with @vitap.ac.in",
                    style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
