import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:physioghar_therapist/data/mock_data.dart';
import 'package:physioghar_therapist/features/patients/domain/patient.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';
import 'package:physioghar_therapist/features/sessions/providers/session_provider.dart';

class PatientNotifier extends StateNotifier<List<Patient>> {
  PatientNotifier() : super(MockData.patients) {
    syncSessions(MockData.sessions);
  }

  void syncSessions(List<PhysioSession> sessions) {
    for (final session in sessions) {
      _addFromSession(session);
    }
  }

  void _addFromSession(PhysioSession session) {
    if (state.any((patient) => patient.name == session.patientName)) return;

    state = [
      ...state,
      Patient(
        id: session.id,
        name: session.patientName,
        age: session.age ?? 0,
        gender: 'Not specified',
        phone: 'Not available',
        email: 'Not available',
        condition: session.treatment,
        lastSessionDate: session.date,
        treatmentHistory: [session.treatment],
        previousSessionInfo: 'New patient from ${session.location}.',
        notes: const [],
        photoUrl: session.photoUrl ?? 'https://i.pravatar.cc/150?img=12',
      ),
    ];
  }

  void addNote(String patientId, PatientNote note) {
    state = [
      for (final patient in state)
        if (patient.id == patientId)
          patient.copyWith(notes: [...patient.notes, note])
        else
          patient,
    ];
  }

  void editNote(String patientId, PatientNote updatedNote) {
    state = [
      for (final patient in state)
        if (patient.id == patientId)
          patient.copyWith(
            notes: [
              for (final note in patient.notes)
                if (note.id == updatedNote.id) updatedNote else note,
            ],
          )
        else
          patient,
    ];
  }
}

final patientsProvider = StateNotifierProvider<PatientNotifier, List<Patient>>((
  ref,
) {
  final notifier = PatientNotifier();
  final sessions = ref.read(sessionsProvider);
  notifier.syncSessions(sessions);
  ref.listen<List<PhysioSession>>(sessionsProvider, (_, next) {
    notifier.syncSessions(next);
  });
  return notifier;
});

final patientSearchProvider = StateProvider<String>((ref) => '');

final filteredPatientsProvider = Provider<List<Patient>>((ref) {
  final patients = ref.watch(patientsProvider);
  final search = ref.watch(patientSearchProvider).toLowerCase().trim();
  if (search.isEmpty) return patients;
  return patients.where((patient) {
    return patient.name.toLowerCase().contains(search) ||
        patient.condition.toLowerCase().contains(search);
  }).toList();
});
