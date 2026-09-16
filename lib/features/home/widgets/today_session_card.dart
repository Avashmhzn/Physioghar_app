import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/utils/date_formatter.dart';
import 'package:physioghar_therapist/core/widgets/app_card.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';

class TodaySessionCard extends StatelessWidget {
  const TodaySessionCard({super.key, required this.session});

  final PhysioSession session;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push('/sessions/${session.id}'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.pinePale,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: session.photoUrl == null || session.photoUrl!.isEmpty
                    ? const Icon(
                        Icons.person_outline,
                        color: AppColors.pine,
                        size: 24,
                      )
                    : Image.network(
                        session.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.person_outline,
                              color: AppColors.pine,
                              size: 24,
                            ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.age == null
                          ? session.patientName
                          : '${session.patientName}, ${session.age}',
                      style: AppTypography.bodyLarge(
                        color: AppColors.slate,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      session.treatment,
                      style: AppTypography.bodySmall(color: AppColors.slateMid),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: session.location.toLowerCase().contains('home')
                          ? AppColors.sandPale
                          : AppColors.mist,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      session.location.toLowerCase().contains('home')
                          ? 'Home Visit'
                          : 'Clinic',
                      style: AppTypography.caption(
                        color: session.location.toLowerCase().contains('home')
                            ? AppColors.sand
                            : AppColors.slateMid,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Confirmed',
                    style: AppTypography.caption(
                      color: AppColors.pine,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.event_outlined,
                  size: 15,
                  color: AppColors.sage,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _homeSessionDateLabel(session.date),
                    style: AppTypography.bodySmall(
                      color: AppColors.slate,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.access_time_outlined,
                  size: 15,
                  color: AppColors.sage,
                ),
                const SizedBox(width: 6),
                Text(
                  session.time,
                  style: AppTypography.bodySmall(
                    color: AppColors.slate,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(
                  session.location.toLowerCase().contains('home')
                      ? Icons.location_on_outlined
                      : Icons.business_outlined,
                  size: 15,
                  color: AppColors.sage,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    session.location,
                    style: AppTypography.bodySmall(color: AppColors.slateMid),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Session started')),
                  ),
                  icon: const Icon(Icons.play_circle_outline, size: 17),
                  label: const Text('Start Session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pine,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Patient contact is unavailable in demo mode',
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.phone_outlined, size: 16),
                  label: const Text('Call Patient'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.slate,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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

String _homeSessionDateLabel(DateTime date) {
  final today = DateTime.now();
  final sessionDay = DateTime(date.year, date.month, date.day);
  final todayDay = DateTime(today.year, today.month, today.day);
  final difference = sessionDay.difference(todayDay).inDays;

  if (difference == 0) return 'Today';
  if (difference == 1) return 'Tomorrow';
  return DateFormatter.formatShortDate(date);
}
