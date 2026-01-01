import 'package:flutter/material.dart';
import '../services/mock_session.dart';
import '../widgets/primary_button.dart';
import 'poll_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const route = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameCtrl = TextEditingController();

  bool get nameOk => nameCtrl.text.trim().length >= 2;

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = MockSession.email ?? "unknown@vitap.ac.in";

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(email, style: const TextStyle(color: Color(0xFF6B7280))),
              const SizedBox(height: 10),
              const Text("What should we call you?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),

              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "e.g., Akhil",
                ),
                onChanged: (_) => setState(() {}),
              ),

              const Spacer(),

              PrimaryButton(
                text: "Continue",
                onPressed: !nameOk
                    ? null
                    : () {
                        MockSession.name = nameCtrl.text.trim();
                        Navigator.pushReplacementNamed(context, PollScreen.route);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
