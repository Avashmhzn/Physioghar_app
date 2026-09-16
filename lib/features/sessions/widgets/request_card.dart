import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/utils/date_formatter.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';
import 'package:physioghar_therapist/features/sessions/widgets/avatar_badge.dart';
import 'package:physioghar_therapist/features/sessions/widgets/info_strip.dart';
import 'package:physioghar_therapist/features/sessions/widgets/patient_name_block.dart';
import 'package:physioghar_therapist/features/sessions/widgets/session_shell.dart';
import 'package:physioghar_therapist/features/sessions/widgets/soft_pill.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.session,
    required this.onAccept,
    required this.onDecline,
  });

  final PhysioSession session;
  final void Function(PhysioSession session) onAccept;
  final void Function(PhysioSession session) onDecline;

  @override
  Widget build(BuildContext context) {
    return SessionShell(
      onTap: () => context.push('/sessions/${session.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarBadge(session: session, radius: 22),
              const SizedBox(width: 12),
              Expanded(child: PatientNameBlock(session: session)),
              SoftPill(
                label: 'PENDING',
                background: AppColors.sandPale,
                color: AppColors.sand,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            session.treatment,
            style: AppTypography.bodyMedium(
              color: AppColors.slate,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          InfoStrip(
            icon: Icons.schedule_outlined,
            text:
                '${DateFormatter.formatShortDate(session.date)} • ${session.time}',
            trailing: 'REQUESTED',
          ),
          const SizedBox(height: 8),
          InfoStrip(icon: Icons.location_on_outlined, text: session.location),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => onDecline(session),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                    minimumSize: const Size(0, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    'Decline',
                    style: AppTypography.buttonText(color: AppColors.danger),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => onAccept(session),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pine,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size(0, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text('Accept', style: AppTypography.buttonText()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
