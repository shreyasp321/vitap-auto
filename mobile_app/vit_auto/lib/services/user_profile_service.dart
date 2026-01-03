import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveName({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String?> getName(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data();
    final name = data?['name'];
    if (name is String && name.trim().isNotEmpty) return name.trim();
    return null;
  }

  Future<bool> hasName(String uid) async {
    final name = await getName(uid);
    return name != null;
  }
}