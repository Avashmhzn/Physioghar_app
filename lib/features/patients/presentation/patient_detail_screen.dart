import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/localization/language_provider.dart';
import 'package:physioghar_therapist/features/patients/domain/patient.dart';
import 'package:physioghar_therapist/features/patients/providers/patient_provider.dart';
import 'package:physioghar_therapist/features/patients/widgets/patient_details_widget.dart';

class PatientDetailScreen extends ConsumerWidget {
  const PatientDetailScreen({super.key, required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final patients = ref.watch(patientsProvider);
    final patient = patients.firstWhere((p) => p.id == patientId);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Patient Details', style: AppTypography.headingSmall()),
      ),
      body: PatientDetailsWidget(
        patient: patient,
        language: lang,
        onAddNote: () => _showAddNoteDialog(context, ref, patient),
        onEditNote: (note) => _showEditNoteDialog(context, ref, patient, note),
      ),
    );
  }

  void _showAddNoteDialog(
    BuildContext context,
    WidgetRef ref,
    Patient patient,
  ) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Note', style: AppTypography.headingSmall()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., Session Note',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  hintText: 'Session details...',
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTypography.bodyMedium(color: AppColors.slateMid),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                final note = PatientNote(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  content: contentController.text,
                  createdAt: DateTime.now(),
                );
                ref.read(patientsProvider.notifier).addNote(patient.id, note);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 40),
              shape: const StadiumBorder(),
            ),
            child: Text('Add', style: AppTypography.buttonText()),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(
    BuildContext context,
    WidgetRef ref,
    Patient patient,
    PatientNote note,
  ) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Note', style: AppTypography.headingSmall()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTypography.bodyMedium(color: AppColors.slateMid),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                final updatedNote = note.copyWith(
                  title: titleController.text,
                  content: contentController.text,
                );
                ref
                    .read(patientsProvider.notifier)
                    .editNote(patient.id, updatedNote);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 40),
              shape: const StadiumBorder(),
            ),
            child: Text('Save', style: AppTypography.buttonText()),
          ),
        ],
      ),
    );
  }
}
