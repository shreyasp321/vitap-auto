import 'package:flutter/material.dart';
import '../utils/time_slots.dart';

class TimeSlotGrid extends StatelessWidget {
  final String? selectedId;
  final Map<String, int> voteCounts;
  final Future<void> Function(TimeSlot slot) onSelect;
  final void Function(TimeSlot slot) onEnterChat;

  const TimeSlotGrid({
    super.key,
    required this.selectedId,
    required this.voteCounts,
    required this.onSelect,
    required this.onEnterChat,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: kSlots.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // looks better for long labels
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final slot = kSlots[index];
        final isSelected = selectedId == slot.id;
        final count = voteCounts[slot.id] ?? 0;

        return GestureDetector(
          onTap: () => onSelect(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : const Color(0xFFE5E7EB),
                width: isSelected ? 2 : 1,
              ),
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                  : Colors.white,
            ),
            child: Stack(
              children: [
                // Top-right vote count badge
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      color: Colors.white,
                    ),
                    child: Text(
                      "$count",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                // Slot label
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    slot.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                // Enter chat button inside tile (bottom-right)
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: isSelected ? () => onEnterChat(slot) : null,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: isSelected ? 1.0 : 0.45,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : const Color(0xFFF3F4F6),
                        ),
                        child: Text(
                          "Enter Chat",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: isSelected ? Colors.white : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}