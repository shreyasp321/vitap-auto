class TimeSlot {
  final String id;
  final String label;
  const TimeSlot(this.id, this.label);
}

/// 21 slots:
/// 1) Above 5 AM
/// 2) 5-6 AM ... 11 PM-12 AM (19 slots)
/// 3) Below 12 AM
const List<TimeSlot> kSlots = [
  TimeSlot("SLOT_ABOVE_5AM", "Above 5 AM"),

  TimeSlot("SLOT_05_06", "5 AM to 6 AM"),
  TimeSlot("SLOT_06_07", "6 AM to 7 AM"),
  TimeSlot("SLOT_07_08", "7 AM to 8 AM"),
  TimeSlot("SLOT_08_09", "8 AM to 9 AM"),
  TimeSlot("SLOT_09_10", "9 AM to 10 AM"),
  TimeSlot("SLOT_10_11", "10 AM to 11 AM"),
  TimeSlot("SLOT_11_12", "11 AM to 12 PM"),

  TimeSlot("SLOT_12_01", "12 PM to 1 PM"),
  TimeSlot("SLOT_01_02", "1 PM to 2 PM"),
  TimeSlot("SLOT_02_03", "2 PM to 3 PM"),
  TimeSlot("SLOT_03_04", "3 PM to 4 PM"),
  TimeSlot("SLOT_04_05", "4 PM to 5 PM"),

  TimeSlot("SLOT_05_06PM", "5 PM to 6 PM"),
  TimeSlot("SLOT_06_07PM", "6 PM to 7 PM"),
  TimeSlot("SLOT_07_08PM", "7 PM to 8 PM"),
  TimeSlot("SLOT_08_09PM", "8 PM to 9 PM"),
  TimeSlot("SLOT_09_10PM", "9 PM to 10 PM"),
  TimeSlot("SLOT_10_11PM", "10 PM to 11 PM"),
  TimeSlot("SLOT_11_12AM", "11 PM to 12 AM"),

  TimeSlot("SLOT_BELOW_12AM", "Below 12 AM"),
];