import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';
import 'package:physioghar_therapist/features/sessions/presentation/sessions_screen.dart';
import 'package:physioghar_therapist/features/sessions/widgets/avatar_badge.dart';
import 'package:physioghar_therapist/features/sessions/widgets/info_strip.dart';
import 'package:physioghar_therapist/features/sessions/widgets/just_accepted_card.dart';
import 'package:physioghar_therapist/features/sessions/widgets/patient_name_block.dart';
import 'package:physioghar_therapist/features/sessions/widgets/session_shell.dart';
import 'package:physioghar_therapist/features/sessions/widgets/soft_pill.dart';

class UpcomingCard extends StatelessWidget {
  const UpcomingCard({
    super.key,
    required this.session,
    required this.isJustAccepted,
    required this.onReschedule,
    required this.onComplete,
  });

  final PhysioSession session;
  final bool isJustAccepted;
  final void Function(PhysioSession session) onReschedule;
  final void Function(PhysioSession session) onComplete;

  @override
  Widget build(BuildContext context) {
    if (isJustAccepted) {
      return JustAcceptedCard(session: session, onComplete: onComplete);
    }

    return SessionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarBadge(session: session, radius: 22),
              const SizedBox(width: 12),
              Expanded(child: PatientNameBlock(session: session)),
              SoftPill(
                label: sessionProgress(session),
                background: AppColors.pinePale,
                color: AppColors.pine,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            treatmentPreview(session),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium(
              color: AppColors.slate,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 11),
          InfoStrip(
            icon: Icons.schedule_outlined,
            text: scheduleLine(session),
            trailing: 'CONFIRMED',
            trailingColor: AppColors.sand,
          ),
          const SizedBox(height: 8),
          InfoStrip(icon: Icons.warning_amber_rounded, text: session.location),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.healing_outlined,
                  size: 17,
                  color: AppColors.pine,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    clinicalMetric(session),
                    style: AppTypography.bodySmall(
                      color: AppColors.slate,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  clinicalGoal(session),
                  textAlign: TextAlign.right,
                  style: AppTypography.caption(
                    color: AppColors.pine,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onReschedule(session),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    foregroundColor: AppColors.slate,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.event_repeat_outlined, size: 17),
                  label: Text(
                    'Reschedule',
                    style: AppTypography.buttonText(color: AppColors.slate),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => onComplete(session),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    backgroundColor: AppColors.pine,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 17),
                  label: Text(
                    'Mark Completed',
                    style: AppTypography.buttonText(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
