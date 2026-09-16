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

class CancelledCard extends StatelessWidget {
  const CancelledCard({super.key, required this.session});

  final PhysioSession session;

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
                label: 'CANCELLED',
                background: AppColors.mist,
                color: AppColors.danger,
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
          const SizedBox(height: 8),
          InfoStrip(
            icon: Icons.schedule_outlined,
            text:
                '${DateFormatter.formatShortDate(session.date)} • ${session.time}',
          ),
          const SizedBox(height: 8),
          InfoStrip(icon: Icons.location_on_outlined, text: session.location),
        ],
      ),
    );
  }
}
