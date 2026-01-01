import 'package:flutter/material.dart';
import '../utils/time_slots.dart';

class TimeSlotGrid extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<TimeSlot> onSelect;

  const TimeSlotGrid({super.key, required this.selectedId, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kSlots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, i) {
        final slot = kSlots[i];
        final selected = slot.id == selectedId;

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onSelect(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? Theme.of(context).colorScheme.primary : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: selected ? Colors.transparent : const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Center(
              child: Text(
                slot.label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : const Color(0xFF111827),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
