import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in, and if user doesn't exist -> create account automatically
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        final cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return cred.user;
      }
      rethrow;
    }
  }

  /// Google Sign-In
  /// Web (Chrome): Firebase popup works best and avoids google_sign_in breaking changes.
  Future<User?> signInWithGoogle() async {
    if (!kIsWeb) {
      throw UnsupportedError(
        'Google sign-in for Android/iOS not added yet. (Web popup is enabled.)',
      );
    }

    final provider = GoogleAuthProvider()
      ..addScope('email')
      ..addScope('profile');

    final cred = await _auth.signInWithPopup(provider);
    return cred.user;
  }

  Future<void> signOut() => _auth.signOut();

  User? get currentUser => _auth.currentUser;
}