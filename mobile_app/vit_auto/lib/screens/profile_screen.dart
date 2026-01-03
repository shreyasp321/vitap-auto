import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/mock_session.dart';
import '../services/user_profile_service.dart';
import '../widgets/primary_button.dart';
import 'poll_screen.dart';
import 'signin_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const route = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final UserProfileService _profileService = UserProfileService();

  bool _checking = true;
  bool _saving = false;

  bool get nameOk => nameCtrl.text.trim().length >= 2;

  @override
  void initState() {
    super.initState();
    _loadExistingName();
  }

  Future<void> _loadExistingName() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, SignInScreen.route);
      return;
    }

    try {
      final existingName = await _profileService.getName(user.uid);

      if (!mounted) return;

      // ✅ If name already exists, skip profile
      if (existingName != null) {
        MockSession.name = existingName;
        MockSession.email = user.email;

        Navigator.pushReplacementNamed(context, PollScreen.route);
        return;
      }
    } catch (_) {
      // ignore: if it fails, user can still enter name manually
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _onContinue() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final name = nameCtrl.text.trim();
    setState(() => _saving = true);

    try {
      await _profileService.saveName(
        uid: user.uid,
        name: name,
        email: user.email ?? '',
      );

      // ✅ cache locally so UI shows name immediately
      MockSession.name = name;
      MockSession.email = user.email;

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, PollScreen.route);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email =
        FirebaseAuth.instance.currentUser?.email ?? 'unknown@vitapstudent.ac.in';

    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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

              const Text(
                "What should we call you?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
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
                text: _saving ? "Saving..." : "Continue",
                onPressed: (!nameOk || _saving) ? null : _onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}