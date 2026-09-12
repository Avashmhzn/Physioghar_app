import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../data/mock_data.dart';
import '../domain/patient.dart';

class PatientNotifier extends StateNotifier<List<Patient>> {
  PatientNotifier() : super(MockData.patients);

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

final patientsProvider = StateNotifierProvider<PatientNotifier, List<Patient>>((ref) {
  return PatientNotifier();
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
