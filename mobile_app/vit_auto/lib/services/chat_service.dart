import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final _db = FirebaseFirestore.instance;

  String roomId({required String dateKey, required String slotId}) {
    return '${dateKey}__${slotId}';
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchMessages({
    required String dateKey,
    required String slotId,
  }) {
    final rid = roomId(dateKey: dateKey, slotId: slotId);
    return _db
        .collection('chats')
        .doc(rid)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> sendMessage({
    required String dateKey,
    required String slotId,
    required String uid,
    required String name,
    required String text,
  }) async {
    final rid = roomId(dateKey: dateKey, slotId: slotId);

    // Ensure room doc exists (optional but nice)
    await _db.collection('chats').doc(rid).set({
      'dateKey': dateKey,
      'slotId': slotId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _db.collection('chats').doc(rid).collection('messages').add({
      'uid': uid,
      'name': name,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}