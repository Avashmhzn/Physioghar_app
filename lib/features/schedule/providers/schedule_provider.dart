import 'package:flutter_riverpod/legacy.dart';
import '../../../data/mock_data.dart';
import '../domain/availability_slot.dart';

class ScheduleNotifier extends StateNotifier<List<AvailabilitySlot>> {
  ScheduleNotifier() : super(MockData.availabilitySlots());

  void toggleSlot(String slotId) {
    state = [
      for (final slot in state)
        if (slot.id == slotId)
          slot.copyWith(
            status: slot.status == SlotStatus.open ? SlotStatus.blocked :
                slot.status == SlotStatus.blocked ? SlotStatus.open : slot.status,
          )
        else
          slot,
    ];
  }

  void blockSlot(String slotId) {
    state = [
      for (final slot in state)
        if (slot.id == slotId) slot.copyWith(status: SlotStatus.blocked) else slot,
    ];
  }

  void unblockSlot(String slotId) {
    state = [
      for (final slot in state)
        if (slot.id == slotId)
          slot.copyWith(status: SlotStatus.open)
        else
          slot,
    ];
  }

  void addSlot(DateTime date, String time) {
    final newSlot = AvailabilitySlot(
      id: '${date.toIso8601String()}-$time-${DateTime.now().microsecondsSinceEpoch}',
      date: date,
      time: time,
      status: SlotStatus.open,
    );
    state = [...state, newSlot];
  }
}

final scheduleProvider = StateNotifierProvider<ScheduleNotifier, List<AvailabilitySlot>>((ref) {
  return ScheduleNotifier();
});

final selectedScheduleDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
