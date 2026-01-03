import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/ai_auto_service.dart';
import '../services/chat_service.dart';
import '../services/mock_session.dart';
import '../services/user_profile_service.dart';

class ChatScreen extends StatefulWidget {
  static const route = '/chat';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatService = ChatService();
  final _aiService = AiAutoService();
  final _profileService = UserProfileService();
  final _msgCtrl = TextEditingController();

  bool _aiLoading = false;

  late String _dateKey;
  late String _slotId;

  String? _myName; // ✅ from Firestore

  /// 🔑 Unique chat room per date + slot
  String get _roomId => "${_dateKey}__${_slotId}";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    _dateKey = (args?['dateKey'] as String?) ?? MockSession.todayKey(DateTime.now());
    _slotId = (args?['slotId'] as String?) ?? (MockSession.selectedSlotId ?? '');

    // ✅ Load name once when screen opens
    _loadMyName();
  }

  Future<void> _loadMyName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final name = await _profileService.getName(user.uid);
      if (!mounted) return;

      setState(() {
        _myName = (name != null && name.trim().isNotEmpty) ? name.trim() : null;
      });

      // optional: keep local cache too
      if (_myName != null) MockSession.name = _myName;
      MockSession.email = user.email;
    } catch (_) {
      // ignore silently (fallback will work)
    }
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  // ---------------- SEND NORMAL MESSAGE ----------------
  Future<void> _send() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not signed in. Please sign in again.")),
      );
      return;
    }

    final text = _msgCtrl.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Type a message first 🙂")),
      );
      return;
    }

    // ✅ Prefer Firestore name, fallback to MockSession, then Student
    final name = _myName ?? MockSession.name ?? "Student";

    try {
      await _chatService.sendMessage(
        dateKey: _dateKey,
        slotId: _slotId,
        uid: user.uid,
        name: name,
        text: text,
      );
      _msgCtrl.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chat send failed: $e")),
      );
    }
  }

  // ---------------- AI AUTO ----------------
  Future<void> _askAiAuto() async {
    if (_aiLoading) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _aiLoading = true);

    try {
      final prompt = _msgCtrl.text.trim().isEmpty
          ? "Give advice about today's departure rush"
          : _msgCtrl.text.trim();

      // ✅ Prefer Firestore name here too
      final userName = _myName ?? MockSession.name ?? "Student";

      final reply = await _aiService.ask(
        userName: userName,
        message: prompt,
      );

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(_roomId)
          .collection('messages')
          .add({
        'uid': 'AI_AUTO',
        'name': 'AI Auto',
        'text': reply,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _msgCtrl.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("AI Auto error: $e")),
      );
    } finally {
      if (mounted) setState(() => _aiLoading = false);
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Slot $_slotId",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              "Today: $_dateKey",
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ---------------- MESSAGES ----------------
          Expanded(
            child: StreamBuilder(
              stream: _chatService.watchMessages(dateKey: _dateKey, slotId: _slotId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(child: Text("No messages yet. Say hi 👋"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data();
                    final name = data['name']?.toString() ?? "Unknown";
                    final text = data['text']?.toString() ?? "";

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text(text),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ---------------- INPUT BAR ----------------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 🤖 AI AUTO BUTTON
                  TextButton(
                    onPressed: _aiLoading ? null : _askAiAuto,
                    child: Text(_aiLoading ? "AI..." : "AI Auto"),
                  ),

                  IconButton(
                    onPressed: _send,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}