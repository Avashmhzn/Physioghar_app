import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/localization/app_strings.dart';
import 'package:physioghar_therapist/core/utils/date_formatter.dart';
import 'package:physioghar_therapist/core/widgets/app_card.dart';
import 'package:physioghar_therapist/core/widgets/section_header.dart';
import 'package:physioghar_therapist/features/patients/domain/patient.dart';
import 'package:physioghar_therapist/features/patients/widgets/info_row.dart';

class PatientDetailsWidget extends StatelessWidget {
  const PatientDetailsWidget({
    super.key,
    required this.patient,
    required this.language,
    required this.onAddNote,
    required this.onEditNote,
  });

  final Patient patient;
  final AppLanguage language;
  final VoidCallback onAddNote;
  final void Function(PatientNote note) onEditNote;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                            .map((word) => word[0])
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
          SectionHeader(title: 'Contact Information'),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: patient.phone,
                ),
                const Divider(height: 24),
                InfoRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: patient.email,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
          SectionHeader(
            title: 'Session Notes',
            subtitle: '${patient.notes.length} notes',
            trailing: IconButton(
              onPressed: onAddNote,
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
                      const Icon(
                        Icons.note_add_outlined,
                        size: 40,
                        color: AppColors.slateMute,
                      ),
                      const SizedBox(height: 12),
                      Text('No notes yet', style: AppTypography.bodyMedium()),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: onAddNote,
                        child: Text(AppStrings.get('add_note', language)),
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
                            onPressed: () => onEditNote(note),
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
    );
  }
}


