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
            status: slot.status == SlotStatus.open
                ? SlotStatus.blocked
                : slot.status == SlotStatus.blocked
                ? SlotStatus.open
                : slot.status,
          )
        else
          slot,
    ];
  }

  void blockSlot(String slotId) {
    state = [
      for (final slot in state)
        if (slot.id == slotId)
          slot.copyWith(status: SlotStatus.blocked)
        else
          slot,
    ];
  }

  void unblockSlot(String slotId) {
    state = [
      for (final slot in state)
        if (slot.id == slotId) slot.copyWith(status: SlotStatus.open) else slot,
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

  void bookSession({
    required String sessionId,
    required DateTime date,
    required String time,
    required String patientName,
    required String treatment,
    required String location,
  }) {
    final existingSessionIndex = state.indexWhere(
      (slot) => slot.sessionId == sessionId,
    );
    if (existingSessionIndex >= 0) return;

    final openSlotIndex = state.indexWhere(
      (slot) =>
          slot.status == SlotStatus.open &&
          slot.date.year == date.year &&
          slot.date.month == date.month &&
          slot.date.day == date.day &&
          slot.time == time,
    );

    if (openSlotIndex >= 0) {
      state = [
        for (var index = 0; index < state.length; index++)
          if (index == openSlotIndex)
            state[index].copyWith(
              date: date,
              status: SlotStatus.booked,
              sessionId: sessionId,
              patientName: patientName,
              treatment: treatment,
              location: location,
            )
          else
            state[index],
      ];
      return;
    }

    state = [
      ...state,
      AvailabilitySlot(
        id: 'session-$sessionId',
        date: date,
        time: time,
        status: SlotStatus.booked,
        sessionId: sessionId,
        patientName: patientName,
        treatment: treatment,
        location: location,
      ),
    ];
  }

  void rescheduleSession(String sessionId, DateTime newDate, String newTime) {
    state = [
      for (final slot in state)
        if (slot.sessionId == sessionId)
          slot.copyWith(date: newDate, time: newTime)
        else
          slot,
    ];
  }
}

final scheduleProvider =
    StateNotifierProvider<ScheduleNotifier, List<AvailabilitySlot>>((ref) {
      return ScheduleNotifier();
    });

final selectedScheduleDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);
