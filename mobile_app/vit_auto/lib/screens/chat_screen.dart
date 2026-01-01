import 'package:flutter/material.dart';
import '../services/mock_session.dart';

class ChatScreen extends StatefulWidget {
  static const route = '/chat';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgCtrl = TextEditingController();
  final List<String> messages = [
    "System: This is a mock chat (offline).",
    "Tip: In Firebase step, messages will be realtime.",
  ];

  @override
  void dispose() {
    msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = MockSession.name ?? "Student";

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(14),
                itemCount: messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final text = messages[i];
                  final isMine = text.startsWith("$name:");
                  return Align(
                    alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      constraints: const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        color: isMine ? Theme.of(context).colorScheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: isMine ? null : Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: isMine ? Colors.white : const Color(0xFF111827),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgCtrl,
                      decoration: const InputDecoration(hintText: "Type a message (mock)"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    onPressed: () {
                      final msg = msgCtrl.text.trim();
                      if (msg.isEmpty) return;
                      setState(() {
                        messages.add("$name: $msg");
                      });
                      msgCtrl.clear();
                    },
                    icon: const Icon(Icons.send_rounded),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
