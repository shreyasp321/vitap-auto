import 'dart:async';
import 'support_ai_screen.dart'; // only if you want AI Help here too (optional)
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'support_ai_screen.dart';
import '../services/mock_session.dart';
import '../services/poll_service.dart';
import '../widgets/time_slot_grid.dart';
import '../widgets/primary_button.dart';
import '../utils/time_slots.dart';
import 'chat_screen.dart';
import 'signin_screen.dart';

class PollScreen extends StatefulWidget {
  static const route = '/poll';
  const PollScreen({super.key});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  final PollService _pollService = PollService();

  StreamSubscription<Map<String, String>>? _sub;
  Map<String, int> _slotCounts = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _startLivePoll();
  }

  void _startLivePoll() {
    MockSession.ensureDailyReset(DateTime.now());

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final dateKey = MockSession.todayKey(DateTime.now());

    // Cancel existing subscription if any
    _sub?.cancel();

    // Start live listener
    _sub = _pollService.watchVotes(dateKey).listen((votes) {
      // Count votes per slot
      final Map<String, int> counts = {};
      for (final slotId in votes.values) {
        counts[slotId] = (counts[slotId] ?? 0) + 1;
      }

      // My selection from cloud
      final myVote = votes[user.uid];

      if (!mounted) return;

      setState(() {
        _slotCounts = counts;
        MockSession.selectedSlotId = myVote;
        _loading = false;
      });
    });
  }

  Future<void> _onSelectSlot(TimeSlot slot) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final dateKey = MockSession.todayKey(DateTime.now());

    await _pollService.saveVote(
      dateKey: dateKey,
      uid: user.uid,
      slotId: slot.id,
    );
    // No need to reload manually — listener updates automatically ✅
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    MockSession.signOut();

    await _sub?.cancel();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.route,
      (_) => false,
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = MockSession.selectedSlotId;
    final dateKey = MockSession.todayKey(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Demand"),
        actions: [
          IconButton(
            tooltip: "Sign out",
            onPressed: _signOut,
            icon: const Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pick your expected leaving time",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Today ($dateKey)",
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 16),

                    TimeSlotGrid(
                      selectedId: selected,
                      voteCounts: _slotCounts,
                      onSelect: _onSelectSlot,
                      onEnterChat: (slot) {
                        Navigator.pushNamed(
                          context,
                          ChatScreen.route,
                          arguments: {
                            'dateKey': MockSession.todayKey(DateTime.now()),
                            'slotId': slot.id,
                          },
                        );
                      },
                    ),


const SizedBox(height: 14),

                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, SupportAiScreen.route),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.smart_toy_rounded, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "support",
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected == null
                                ? Icons.lock_outline
                                : Icons.lock_open_rounded,
                            color: selected == null ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              selected == null
                                  ? "Chat is locked. Vote once to enter chat."
                                  : "Chat unlocked. You can now enter the chat.",
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    PrimaryButton(
                      text: "Enter Chat",
                      onPressed: (selected == null)
                          ? null
                          : () => Navigator.pushNamed(
                                context,
                                ChatScreen.route,
                                arguments: {
                                  'dateKey': MockSession.todayKey(DateTime.now()),
                                  'slotId': selected,
                                },
                              ),
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      "Daily reset happens automatically at 12:00 AM.",
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}