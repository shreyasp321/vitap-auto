class TimeSlot {
  final String id;
  final String label;
  const TimeSlot(this.id, this.label);
}

// Example: 7 AM to 5 PM => 11 hours.
// You want 21 slots, so use 30-min blocks.
// 7:00 to 17:00 (10 hours) = 20 slots, add 17:00 = 21 slots.
const List<TimeSlot> kSlots = [
  TimeSlot("SLOT_07_00", "07:00"),
  TimeSlot("SLOT_07_30", "07:30"),
  TimeSlot("SLOT_08_00", "08:00"),
  TimeSlot("SLOT_08_30", "08:30"),
  TimeSlot("SLOT_09_00", "09:00"),
  TimeSlot("SLOT_09_30", "09:30"),
  TimeSlot("SLOT_10_00", "10:00"),
  TimeSlot("SLOT_10_30", "10:30"),
  TimeSlot("SLOT_11_00", "11:00"),
  TimeSlot("SLOT_11_30", "11:30"),
  TimeSlot("SLOT_12_00", "12:00"),
  TimeSlot("SLOT_12_30", "12:30"),
  TimeSlot("SLOT_13_00", "13:00"),
  TimeSlot("SLOT_13_30", "13:30"),
  TimeSlot("SLOT_14_00", "14:00"),
  TimeSlot("SLOT_14_30", "14:30"),
  TimeSlot("SLOT_15_00", "15:00"),
  TimeSlot("SLOT_15_30", "15:30"),
  TimeSlot("SLOT_16_00", "16:00"),
  TimeSlot("SLOT_16_30", "16:30"),
  TimeSlot("SLOT_17_00", "17:00"),
];
