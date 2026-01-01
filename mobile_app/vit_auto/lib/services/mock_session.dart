class MockSession {
  // Fake “logged in” state
  static String? email;
  static String? name;

  // Poll state (one vote per day)
  static String? selectedSlotId; // e.g. "SLOT_09_00"
  static String? selectedDateKey; // e.g. "2026-01-01"

  static bool get isSignedIn => email != null;
  static bool get hasName => (name != null && name!.trim().isNotEmpty);

  static void signOut() {
    email = null;
    name = null;
    selectedSlotId = null;
    selectedDateKey = null;
  }

  static String todayKey(DateTime now) {
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }

  // Daily reset logic (works offline)
  static void ensureDailyReset(DateTime now) {
    final key = todayKey(now);
    if (selectedDateKey != key) {
      selectedDateKey = key;
      selectedSlotId = null;
    }
  }
}
