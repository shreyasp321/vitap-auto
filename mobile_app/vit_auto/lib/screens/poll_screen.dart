import 'package:flutter/material.dart';
import '../services/mock_session.dart';
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
  @override
  void initState() {
    super.initState();
    MockSession.ensureDailyReset(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final name = MockSession.name ?? "Student";
    final dateKey = MockSession.selectedDateKey ?? MockSession.todayKey(DateTime.now());
    final selected = MockSession.selectedSlotId;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Demand"),
        actions: [
          IconButton(
            tooltip: "Sign out",
            onPressed: () {
              MockSession.signOut();
              Navigator.pushNamedAndRemoveUntil(context, SignInScreen.route, (_) => false);
            },
            icon: const Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hi, $name 👋", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text("Pick your expected leaving time for today ($dateKey).",
                  style: const TextStyle(color: Color(0xFF6B7280))),
              const SizedBox(height: 16),

              TimeSlotGrid(
                selectedId: selected,
                onSelect: (TimeSlot slot) {
                  setState(() {
                    MockSession.selectedSlotId = slot.id; // one per day
                  });
                },
              ),

              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    Icon(
                      selected == null ? Icons.lock_outline : Icons.lock_open_rounded,
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
                    : () => Navigator.pushNamed(context, ChatScreen.route),
              ),

              const SizedBox(height: 10),
              Text(
                "Daily reset: At 12:00 AM your selection clears automatically (date key based).",
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
