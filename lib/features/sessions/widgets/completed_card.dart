import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';
import 'package:physioghar_therapist/features/sessions/presentation/sessions_screen.dart';
import 'package:physioghar_therapist/features/sessions/widgets/avatar_badge.dart';
import 'package:physioghar_therapist/features/sessions/widgets/outcome_content.dart';
import 'package:physioghar_therapist/features/sessions/widgets/patient_name_block.dart';
import 'package:physioghar_therapist/features/sessions/widgets/session_shell.dart';
import 'package:physioghar_therapist/features/sessions/widgets/soap_content.dart';
import 'package:physioghar_therapist/features/sessions/widgets/soft_pill.dart';

class CompletedCard extends StatelessWidget {
  const CompletedCard({super.key, required this.session});

  final PhysioSession session;

  @override
  Widget build(BuildContext context) {
    final compactOutcome =
        session.id.startsWith('req-') ||
        session.treatment.toLowerCase().contains('knee');

    return SessionShell(
      onTap: () => context.push('/sessions/${session.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarBadge(session: session, radius: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PatientNameBlock(session: session),
                    const SizedBox(height: 2),
                    Text(
                      treatmentPreview(session),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall(
                        color: AppColors.slate,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SoftPill(
                label: compactOutcome ? 'COMPLETED' : 'PAID • NPR 1,500',
                background: AppColors.pinePale,
                color: AppColors.pine,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              compactOutcome ? '' : 'Yesterday, 5:15 PM',
              style: AppTypography.metricLabel(color: AppColors.slateMid),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius: BorderRadius.circular(12),
            ),
            child: compactOutcome
                ? OutcomeContent(session: session)
                : SoapContent(session: session),
          ),
        ],
      ),
    );
  }
}
