import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:physioghar_therapist/data/mock_data.dart';
import 'package:physioghar_therapist/features/schedule/providers/schedule_provider.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';

class SessionNotifier extends StateNotifier<List<PhysioSession>> {
  SessionNotifier({this.onAccept, this.onReschedule})
    : super(MockData.sessions);

  final bool Function(PhysioSession session)? onAccept;
  final void Function(String sessionId, DateTime newDate, String newTime)?
  onReschedule;

  List<PhysioSession> byStatus(SessionStatus status) {
    return state.where((session) => session.status == status).toList();
  }

  bool acceptRequest(String sessionId) {
    PhysioSession? request;
    for (final session in state) {
      if (session.id == sessionId && session.status == SessionStatus.request) {
        request = session;
        break;
      }
    }
    if (request == null) return false;

    final acceptedSession = request.copyWith(status: SessionStatus.upcoming);
    if (onAccept?.call(acceptedSession) == false) return false;

    state = [
      for (final session in state)
        if (session.id == sessionId) acceptedSession else session,
    ];
    return true;
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

  bool markCompleted(String sessionId, {String? notes}) {
    final sessionIndex = state.indexWhere(
      (session) =>
          session.id == sessionId && session.status == SessionStatus.upcoming,
    );
    if (sessionIndex < 0) return false;

    state = [
      for (var index = 0; index < state.length; index++)
        if (index == sessionIndex)
          state[index].copyWith(
            status: SessionStatus.completed,
            notes:
                notes ??
                state[index].notes ??
                'Completed session. Patient tolerated exercises well.',
          )
        else
          state[index],
    ];
    return true;
  }

  void reschedule(String sessionId, DateTime newDate, String newTime) {
    state = [
      for (final session in state)
        if (session.id == sessionId)
          session.copyWith(date: newDate, time: newTime)
        else
          session,
    ];
    onReschedule?.call(sessionId, newDate, newTime);
  }
}

final sessionsProvider =
    StateNotifierProvider<SessionNotifier, List<PhysioSession>>((ref) {
      return SessionNotifier(
        onAccept: (session) {
          final didBook = ref
              .read(scheduleProvider.notifier)
              .bookSession(
                sessionId: session.id,
                date: session.date,
                time: session.time,
                patientName: session.patientName,
                treatment: session.treatment,
                location: session.location,
              );
          if (!didBook) return false;
          ref.read(selectedScheduleDateProvider.notifier).state = session.date;
          return true;
        },
        onReschedule: (sessionId, newDate, newTime) {
          ref
              .read(scheduleProvider.notifier)
              .rescheduleSession(sessionId, newDate, newTime);
          ref.read(selectedScheduleDateProvider.notifier).state = newDate;
        },
      );
    });

final requestSessionsProvider = Provider<List<PhysioSession>>((ref) {
  return ref
      .watch(sessionsProvider)
      .where((s) => s.status == SessionStatus.request)
      .toList();
});

final upcomingSessionsProvider = Provider<List<PhysioSession>>((ref) {
  return ref
      .watch(sessionsProvider)
      .where((s) => s.status == SessionStatus.upcoming)
      .toList();
});

final todaySessionsProvider = Provider<List<PhysioSession>>((ref) {
  final now = DateTime.now();
  final sessions = ref.watch(upcomingSessionsProvider).where((session) {
    return session.date.year == now.year &&
        session.date.month == now.month &&
        session.date.day == now.day;
  }).toList();

  sessions.sort((a, b) => a.time.compareTo(b.time));
  return sessions;
});

final completedSessionsProvider = Provider<List<PhysioSession>>((ref) {
  return ref
      .watch(sessionsProvider)
      .where((s) => s.status == SessionStatus.completed)
      .toList();
});

final cancelledSessionsProvider = Provider<List<PhysioSession>>((ref) {
  return ref
      .watch(sessionsProvider)
      .where((s) => s.status == SessionStatus.cancelled)
      .toList();
});
