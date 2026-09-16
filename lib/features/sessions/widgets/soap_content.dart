import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';

class SoapContent extends StatelessWidget {
  const SoapContent({super.key, required this.session});

  final PhysioSession session;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.note_alt_outlined,
              size: 16,
              color: AppColors.pine,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                'Therapist Clinical Remarks:',
                style: AppTypography.caption(
                  color: AppColors.pine,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              'Session 6/10',
              style: AppTypography.monoBadge(color: AppColors.slate),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '“${session.notes ?? 'Patient showed 30% improved cervical extension without radiating numbness. Advised scapular retractions 3x daily and ergonomic screen elevation.'}”',
          style: AppTypography.bodyMedium(color: AppColors.slate)
              .copyWith(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Next follow-up: Monday 10:00 AM',
                style: AppTypography.metricLabel(color: AppColors.slate),
              ),
            ),
            Text(
              'Edit SOAP  ↗',
              style: AppTypography.caption(
                color: AppColors.pine,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
