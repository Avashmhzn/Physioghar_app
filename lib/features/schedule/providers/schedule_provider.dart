import 'package:flutter_riverpod/legacy.dart';
import 'package:physioghar_therapist/data/mock_data.dart';
import 'package:physioghar_therapist/features/schedule/domain/availability_slot.dart';

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
    final existingSlotIndex = state.indexWhere(
      (slot) => _isSameSlot(slot.date, slot.time, date, time),
    );
    if (existingSlotIndex >= 0) {
      if (state[existingSlotIndex].status != SlotStatus.blocked) return;

      state = [
        for (var index = 0; index < state.length; index++)
          if (index == existingSlotIndex)
            state[index].copyWith(status: SlotStatus.open)
          else
            state[index],
      ];
      return;
    }

    final newSlot = AvailabilitySlot(
      id: '${date.toIso8601String()}-$time-${DateTime.now().microsecondsSinceEpoch}',
      date: date,
      time: time,
      status: SlotStatus.open,
    );
    state = [...state, newSlot];
  }

  bool bookSession({
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
    if (existingSessionIndex >= 0) return true;

    final occupiedSlot = state.any(
      (slot) =>
          _isSameSlot(slot.date, slot.time, date, time) &&
          slot.status != SlotStatus.open,
    );
    if (occupiedSlot) return false;

    final openSlotIndex = state.indexWhere(
      (slot) =>
          slot.status == SlotStatus.open &&
          _isSameSlot(slot.date, slot.time, date, time),
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
      return true;
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
    return true;
  }

  void rescheduleSession(String sessionId, DateTime newDate, String newTime) {
    final bookedSlotIndex = state.indexWhere(
      (slot) => slot.sessionId == sessionId,
    );
    if (bookedSlotIndex < 0) return;

    final destinationIsOccupied = state.any(
      (slot) =>
          slot.status != SlotStatus.open &&
          slot.sessionId != sessionId &&
          _isSameSlot(slot.date, slot.time, newDate, newTime),
    );
    if (destinationIsOccupied) return;

    final destinationOpenIndex = state.indexWhere(
      (slot) =>
          slot.status == SlotStatus.open &&
          _isSameSlot(slot.date, slot.time, newDate, newTime),
    );
    final bookedSlot = state[bookedSlotIndex];

    if (destinationOpenIndex < 0) {
      state = [
        for (var index = 0; index < state.length; index++)
          if (index == bookedSlotIndex)
            bookedSlot.copyWith(date: newDate, time: newTime)
          else
            state[index],
      ];
      return;
    }

    state = [
      for (var index = 0; index < state.length; index++)
        if (index == bookedSlotIndex)
          AvailabilitySlot(
            id: bookedSlot.id,
            date: bookedSlot.date,
            time: bookedSlot.time,
            status: SlotStatus.open,
          )
        else if (index == destinationOpenIndex)
          state[index].copyWith(
            status: SlotStatus.booked,
            sessionId: bookedSlot.sessionId,
            patientName: bookedSlot.patientName,
            treatment: bookedSlot.treatment,
            location: bookedSlot.location,
          )
        else
          state[index],
    ];
  }
}

bool _isSameSlot(
  DateTime firstDate,
  String firstTime,
  DateTime secondDate,
  String secondTime,
) {
  return firstDate.year == secondDate.year &&
      firstDate.month == secondDate.month &&
      firstDate.day == secondDate.day &&
      _normalizeTime(firstTime) == _normalizeTime(secondTime);
}

String _normalizeTime(String time) {
  return time
      .trim()
      .toUpperCase()
      .replaceAll(' ', '')
      .replaceFirst(RegExp(r'^0(?=\d:)'), '');
}

final scheduleProvider =
    StateNotifierProvider<ScheduleNotifier, List<AvailabilitySlot>>((ref) {
      return ScheduleNotifier();
    });

final selectedScheduleDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);
