import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/utils/date_formatter.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';
import 'package:physioghar_therapist/features/sessions/providers/session_provider.dart';

class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref
        .watch(sessionsProvider)
        .cast<PhysioSession?>()
        .firstWhere((item) => item?.id == sessionId, orElse: () => null);

    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Session Details')),
        body: Center(
          child: Text('Session not found', style: AppTypography.bodyMedium()),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        title: const Text('Session Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.pinePale,
                  backgroundImage: session.photoUrl == null
                      ? null
                      : NetworkImage(session.photoUrl!),
                  child: session.photoUrl == null
                      ? const Icon(
                          Icons.person_outline,
                          color: AppColors.pine,
                          size: 34,
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  session.patientName,
                  style: AppTypography.headingSmall(),
                  textAlign: TextAlign.center,
                ),
                if (session.age != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${session.age} years old',
                    style: AppTypography.bodySmall(),
                  ),
                ],
                const SizedBox(height: 12),
                _StatusPill(status: session.status),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _DetailSection(
            title: 'Appointment',
            children: [
              _DetailRow(
                icon: Icons.calendar_today_outlined,
                label: 'Date',
                value: DateFormatter.formatFullDate(session.date),
              ),
              _DetailRow(
                icon: Icons.access_time_outlined,
                label: 'Time',
                value: session.time,
              ),
              _DetailRow(
                icon: Icons.location_on_outlined,
                label: 'Location',
                value: session.location,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _DetailSection(
            title: 'Treatment',
            children: [
              Text(
                session.treatment,
                style: AppTypography.bodyLarge(
                  color: AppColors.slate,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (session.notes != null && session.notes!.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  'Notes',
                  style: AppTypography.bodySmall(
                    color: AppColors.slateMid,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(session.notes!, style: AppTypography.bodyMedium()),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.headingSmall(color: AppColors.slate),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: AppColors.pine),
          const SizedBox(width: 10),
          SizedBox(
            width: 68,
            child: Text(label, style: AppTypography.bodySmall()),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium(
                color: AppColors.slate,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final SessionStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      SessionStatus.request => 'REQUESTED',
      SessionStatus.upcoming => 'CONFIRMED',
      SessionStatus.completed => 'COMPLETED',
      SessionStatus.cancelled => 'CANCELLED',
    };
    final color = status == SessionStatus.cancelled
        ? AppColors.danger
        : AppColors.pine;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.caption(color: color, fontWeight: FontWeight.w800),
      ),
    );
  }
}
