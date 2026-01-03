import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/ai_auto_service.dart';
import '../services/mock_session.dart';

class SupportAiScreen extends StatefulWidget {
  static const route = '/ai-support';
  const SupportAiScreen({super.key});

  @override
  State<SupportAiScreen> createState() => _SupportAiScreenState();
}

class _SupportAiScreenState extends State<SupportAiScreen> {
  final _msgCtrl = TextEditingController();
  final _aiService = AiAutoService();
  bool _loading = false;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _messagesRef =>
      FirebaseFirestore.instance
          .collection('support_chats')
          .doc(_uid)
          .collection('messages');

  Future<void> _sendUserMessage() async {
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
      const SnackBar(content: Text("Type something first 🙂")),
    );
    return;
  }

  final name = MockSession.name ?? "Student";

  try {
    // Save user message
    await _messagesRef.add({
      'uid': user.uid,
      'name': name,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _msgCtrl.clear();

    // Ask AI + save reply
    await _askAiReply(text, name);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Send failed: $e")),
    );
  }
}

  Future<void> _askAiReply(String userText, String userName) async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final reply = await _aiService.ask(
        userName: userName,
        message: userText,
      );

      await _messagesRef.add({
        'uid': 'AI_AUTO',
        'name': 'AI Help',
        'text': reply,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("AI Help error: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please sign in first.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                Text(
                    "AI Help",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2),
                Text(
                    "Ask anything. Get instant help.",
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                ],
            ),
            ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _messagesRef.orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Text("Ask me anything about VIT Auto 🛺"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data();
                    final name = (data['name'] ?? '').toString();
                    final text = (data['text'] ?? '').toString();
                    final uid = (data['uid'] ?? '').toString();
                    final isAi = uid == 'AI_AUTO';

                    return Align(
                      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 320),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
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

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      decoration: const InputDecoration(
                        hintText: "Describe your issue...",
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _sendUserMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _loading ? null : () async => _sendUserMessage(),
                    icon: Icon(_loading ? Icons.hourglass_top : Icons.send_rounded),
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