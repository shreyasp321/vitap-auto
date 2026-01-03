import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class PollService {
  final _db = FirebaseFirestore.instance;

Stream<Map<String, String>> watchVotes(String dateKey) {
  final docRef = _db.collection('polls').doc(dateKey);

  return docRef.snapshots().map((doc) {
    if (!doc.exists) return {};

    final data = doc.data();
    final votes = data?['votes'];

    if (votes is Map) {
      return votes.map((k, v) => MapEntry(k.toString(), v.toString()));
    }

    return {};
  });
}
  /// Save or update a user's vote for today
  Future<void> saveVote({
    required String dateKey,
    required String uid,
    required String slotId,
  }) async {
    final docRef = _db.collection('polls').doc(dateKey);

    await docRef.set({
      'votes': {
        uid: slotId,
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Get all votes for a day
  Future<Map<String, String>> getVotes(String dateKey) async {
    final doc = await _db.collection('polls').doc(dateKey).get();

    if (!doc.exists) return {};

    final data = doc.data();
    final votes = data?['votes'];

    if (votes is Map) {
      return votes.map((k, v) => MapEntry(k.toString(), v.toString()));
    }

    return {};
  }

  /// Get this user's vote (if any)
  Future<String?> getUserVote({
    required String dateKey,
    required String uid,
  }) async {
    final votes = await getVotes(dateKey);
    return votes[uid];
  }
}