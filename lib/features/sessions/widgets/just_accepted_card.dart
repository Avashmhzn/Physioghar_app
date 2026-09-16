import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';
import 'package:physioghar_therapist/features/sessions/presentation/sessions_screen.dart';
import 'package:physioghar_therapist/features/sessions/widgets/avatar_badge.dart';
import 'package:physioghar_therapist/features/sessions/widgets/patient_name_block.dart';
import 'package:physioghar_therapist/features/sessions/widgets/soft_pill.dart';

class JustAcceptedCard extends StatelessWidget {
  const JustAcceptedCard({
    super.key,
    required this.session,
    required this.onComplete,
  });

  final PhysioSession session;
  final void Function(PhysioSession session) onComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pinePale,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.pinePale),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SoftPill(
                label: 'JUST ACCEPTED',
                background: AppColors.pine,
                color: AppColors.white,
              ),
              const Spacer(),
              Text(
                'Session #PG-889',
                style: AppTypography.monoBadge(color: AppColors.pine),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarBadge(session: session, radius: 23),
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
                        color: AppColors.pine,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Tomorrow, ${session.time} • ${session.location}',
                      style: AppTypography.bodySmall(
                        color: AppColors.slateMid,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => onComplete(session),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pine,
                foregroundColor: AppColors.white,
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(Icons.check_box_outlined, size: 17),
              label: Text(
                'Mark as Completed & Open SOAP',
                style: AppTypography.buttonText(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
