import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';

class OutcomeContent extends StatelessWidget {
  const OutcomeContent({super.key, required this.session});

  final PhysioSession session;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Outcome Assessment:',
                style: AppTypography.caption(
                  color: AppColors.pine,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              'Discharged Phase 1',
              style: AppTypography.monoBadge(color: AppColors.slate),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Text(
          session.notes ?? 'Isometric wall sits tolerated 45s with zero patellar tendon tenderness. Graduated to concentric step-ups.',
          style: AppTypography.bodyMedium(
            color: AppColors.slate,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
