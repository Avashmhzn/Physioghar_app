import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_header.dart';
import '../domain/patient.dart';
import '../providers/patient_provider.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient header
            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.pinePale,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      patient.photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          patient.name
                              .split(' ')
                              .map((w) => w[0])
                              .take(2)
                              .join(),
                          style: AppTypography.headingSmall(
                            color: AppColors.pine,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(patient.name, style: AppTypography.headingSmall()),
                        const SizedBox(height: 4),
                        Text(
                          '${patient.age} years · ${patient.gender}',
                          style: AppTypography.bodyMedium(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Contact info
            SectionHeader(title: 'Contact Information'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: patient.phone,
                  ),
                  const Divider(height: 24),
                  _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: patient.email,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Medical info
            SectionHeader(title: 'Medical Information'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Condition', style: AppTypography.eyebrow()),
                  const SizedBox(height: 6),
                  Text(
                    patient.condition,
                    style: AppTypography.bodyLarge(fontWeight: FontWeight.w600),
                  ),
                  const Divider(height: 20),
                  Text('Last Session', style: AppTypography.eyebrow()),
                  const SizedBox(height: 6),
                  Text(
                    DateFormatter.formatFullDate(patient.lastSessionDate),
                    style: AppTypography.bodyMedium(),
                  ),
                  const Divider(height: 20),
                  Text('Treatment History', style: AppTypography.eyebrow()),
                  const SizedBox(height: 8),
                  ...patient.treatmentHistory.map(
                    (treatment) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.pine,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              treatment,
                              style: AppTypography.bodyMedium(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (patient.previousSessionInfo.isNotEmpty) ...[
                    const Divider(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.mist,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppColors.slateMid,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              patient.previousSessionInfo,
                              style: AppTypography.bodySmall(
                                color: AppColors.slateMid,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Notes section
            SectionHeader(
              title: 'Session Notes',
              subtitle: '${patient.notes.length} notes',
              trailing: IconButton(
                onPressed: () => _showAddNoteDialog(context, ref, patient),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.pine,
                  size: 28,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(height: 12),

            if (patient.notes.isEmpty)
              AppCard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.note_add_outlined,
                          size: 40,
                          color: AppColors.slateMute,
                        ),
                        const SizedBox(height: 12),
                        Text('No notes yet', style: AppTypography.bodyMedium()),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () =>
                              _showAddNoteDialog(context, ref, patient),
                          child: Text(AppStrings.get('add_note', lang)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...patient.notes.map(
                (note) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                note.title,
                                style: AppTypography.bodyLarge(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: AppColors.slateMid,
                              ),
                              onPressed: () => _showEditNoteDialog(
                                context,
                                ref,
                                patient,
                                note,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormatter.formatFullDate(note.createdAt),
                          style: AppTypography.eyebrow(),
                        ),
                        const SizedBox(height: 10),
                        Text(note.content, style: AppTypography.bodyMedium()),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.slateMid),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.eyebrow()),
            const SizedBox(height: 2),
            Text(value, style: AppTypography.bodyMedium()),
          ],
        ),
      ],
    );
  }
}
