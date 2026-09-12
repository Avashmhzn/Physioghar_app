import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../data/mock_data.dart';
import '../domain/session.dart';

class SessionNotifier extends StateNotifier<List<PhysioSession>> {
  SessionNotifier() : super(MockData.sessions);

  List<PhysioSession> byStatus(SessionStatus status) {
    return state.where((session) => session.status == status).toList();
  }

  void acceptRequest(String sessionId) {
    state = [
      for (final session in state)
        if (session.id == sessionId)
          session.copyWith(status: SessionStatus.upcoming)
        else
          session,
    ];
  }

  void declineRequest(String sessionId) {
    state = [
      for (final session in state)
        if (session.id == sessionId)
          session.copyWith(status: SessionStatus.cancelled)
        else
          session,
    ];
  }

  void markCompleted(String sessionId) {
    state = [
      for (final session in state)
        if (session.id == sessionId)
          session.copyWith(
            status: SessionStatus.completed,
            notes: session.notes ?? 'Completed session. Patient tolerated exercises well.',
          )
        else
          session,
    ];
  }

  void reschedule(String sessionId, DateTime newDate, String newTime) {
    state = [
      for (final session in state)
        if (session.id == sessionId)
          session.copyWith(date: newDate, time: newTime)
        else
          session,
    ];
  }
}

final sessionsProvider = StateNotifierProvider<SessionNotifier, List<PhysioSession>>((ref) {
  return SessionNotifier();
});

final requestSessionsProvider = Provider<List<PhysioSession>>((ref) {
  return ref.watch(sessionsProvider).where((s) => s.status == SessionStatus.request).toList();
});

final upcomingSessionsProvider = Provider<List<PhysioSession>>((ref) {
  return ref.watch(sessionsProvider).where((s) => s.status == SessionStatus.upcoming).toList();
});

final completedSessionsProvider = Provider<List<PhysioSession>>((ref) {
  return ref.watch(sessionsProvider).where((s) => s.status == SessionStatus.completed).toList();
});

final cancelledSessionsProvider = Provider<List<PhysioSession>>((ref) {
  return ref.watch(sessionsProvider).where((s) => s.status == SessionStatus.cancelled).toList();
});
