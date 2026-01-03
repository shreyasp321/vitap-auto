import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firebase_auth_service.dart';
import '../widgets/primary_button.dart';
import 'profile_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String route = '/signin';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();

  bool _hidePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _onEmailSignInPressed() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password');
      return;
    }

    if (!email.endsWith('@vitapstudent.ac.in')) {
      _showError('Only VIT-AP student emails allowed: name@vitapstudent.ac.in');
      return;
    }

    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    setState(() => _loading = true);

    try {
      final user = await _authService.signInWithEmailPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacementNamed(context, ProfileScreen.route);
      } else {
        _showError('Login failed. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showError(e.message ?? e.code);
    } catch (e) {
      if (!mounted) return;
      _showError('Login failed: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onGoogleSignInPressed() async {
    setState(() => _loading = true);

    try {
      final user = await _authService.signInWithGoogle();

      if (!mounted) return;

      if (user != null) {
        // Optional: enforce domain after Google sign-in too
        final email = (user.email ?? '').toLowerCase();
        if (!email.endsWith('@vitapstudent.ac.in')) {
          await _authService.signOut();
          _showError('Please use your VIT-AP student Google account.');
          return;
        }

        Navigator.pushReplacementNamed(context, ProfileScreen.route);
      } else {
        _showError('Google sign-in cancelled');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showError(e.message ?? e.code);
    } catch (e) {
      if (!mounted) return;
      _showError('Google sign-in failed: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Welcome to VIT Auto',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sign in using your VIT-AP student email',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(0.04),
                ),
                child: const Center(child: Text('🛺', style: TextStyle(fontSize: 64))),
              ),
              const SizedBox(height: 24),

              const Text('College Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'name@vitapstudent.ac.in',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),

              const SizedBox(height: 16),

              const Text('Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _hidePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Min 6 characters',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _hidePassword = !_hidePassword),
                    icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),

              const SizedBox(height: 18),

              PrimaryButton(
                text: _loading ? 'Signing in...' : 'Enter Auto',
                onPressed: _loading ? null : _onEmailSignInPressed,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.black.withOpacity(0.2))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider(color: Colors.black.withOpacity(0.2))),
                ],
              ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: _loading ? null : _onGoogleSignInPressed,
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Only @vitapstudent.ac.in emails are allowed.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}