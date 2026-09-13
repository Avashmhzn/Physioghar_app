import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../sessions/domain/session.dart';
import '../../sessions/providers/session_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final profile = ref.watch(therapistProfileProvider);
    final isAvailable = ref.watch(availabilityProvider);
    final isHomeVisitsActive = ref.watch(homeVisitsProvider);
    final todaySessions = ref.watch(upcomingSessionsProvider);
    final requests = ref.watch(requestSessionsProvider);
    final completed = ref.watch(completedSessionsProvider);

    final now = DateTime.now(); // added

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // TOP HEADER
              // ============================================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.pine,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.local_hospital_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // PhysioGhar
                  Text(
                    'PhysioGhar',
                    style: AppTypography.headingSmall(color: AppColors.pine),
                  ),

                  const SizedBox(width: 8),

                  // THERAPIST badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8EBD9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'THERAPIST',
                      style: AppTypography.bodySmall(
                        color: AppColors.pine,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Small profile image
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border, width: 1),
                      image: DecorationImage(
                        image: NetworkImage(profile.profilePicUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ============================================================
              // DATE + LARGE THERAPIST IMAGE
              // ============================================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date (now dynamic)
                        Text(
                          DateFormatter.formatHomeHeaderDate(now).toUpperCase(),
                          style: AppTypography.eyebrowMono(
                            color: AppColors.pineLight,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Greeting
                        Text(
                          'Namaste, ${profile.name}',
                          style: AppTypography.headingLarge(
                            color: AppColors.pine,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Profession
                        Text(
                          profile.specialization,
                          style: AppTypography.bodyLarge(
                            color: AppColors.inkMid,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Large therapist image
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFFD8E4DF),
                        width: 3,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(profile.profilePicUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // HOME VISITS ACTIVE CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isHomeVisitsActive ? AppColors.white : AppColors.mist,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isHomeVisitsActive
                        ? AppColors.border
                        : AppColors.border.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isHomeVisitsActive
                                ? 'Available for Home Visits'
                                : 'Off-Duty(Rest Mode)',
                            style: AppTypography.cardTitle(
                              color: isHomeVisitsActive
                                  ? AppColors.ink
                                  : AppColors.inkMid,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isHomeVisitsActive
                                ? 'Accepting Kathmandu valley appointments'
                                : 'Not accepting Kathmandu valley appointments',
                            style: AppTypography.bodyMedium(
                              color: isHomeVisitsActive
                                  ? AppColors.inkMid
                                  : AppColors.inkMute,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () =>
                          ref.read(homeVisitsProvider.notifier).toggle(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 50,
                        height: 28,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isHomeVisitsActive
                              ? AppColors.pine
                              : const Color(0xFFE2E8F0),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          alignment: isHomeVisitsActive
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x20000000),
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // NOTIFICATION BANNER (only when there are requests)
              if (requests.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.amberPale,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.amber.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.amber,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${requests.length} New Booking ${requests.length == 1 ? 'Request' : 'Requests'}',
                              style: AppTypography.cardTitle(color: AppColors.ink),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Review and respond to pending appointments',
                              style: AppTypography.bodySmall(
                                color: AppColors.inkMid,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.amber,
                        size: 20,
                      ),
                    ],
                  ),
                ),

              if (requests.isNotEmpty) const SizedBox(height: 24),

              if (requests.isEmpty) const SizedBox(height: 8),

              // SUMMARY CARDS SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your Activity', style: AppTypography.headingSmall()),
                  GestureDetector(
                    onTap: () =>
                        ref.read(availabilityProvider.notifier).toggle(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? AppColors.pinePale
                            : AppColors.dangerPale,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isAvailable
                                  ? AppColors.pine
                                  : AppColors.danger,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isAvailable ? 'Active' : 'Busy',
                            style: AppTypography.bodySmall(
                              color: isAvailable
                                  ? AppColors.pine
                                  : AppColors.danger,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // SUMMARY CARDS ROW
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      count: todaySessions.length,
                      label: "Appointments",
                      icon: Icons.calendar_today_rounded,
                      isDark: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      count: requests.length,
                      label: 'Pending',
                      icon: Icons.access_time_rounded,
                      isDark: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      count: completed.length,
                      label: 'Complete',
                      icon: Icons.check_circle_outline_rounded,
                      isDark: false,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // PENDING REQUESTS SECTION
              if (requests.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Requests',
                      style: AppTypography.headingSmall(),
                    ),
                    Text(
                      'See All',
                      style: AppTypography.bodyMedium(
                        color: AppColors.pine,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...requests.map(
                  (session) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _RequestCard(session: session, lang: lang, ref: ref),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // TODAY'S SESSIONS SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today's Session", style: AppTypography.headingSmall()),
                  Text(
                    'See All',
                    style: AppTypography.bodyMedium(
                      color: AppColors.pine,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              if (todaySessions.isEmpty)
                AppCard(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: AppColors.mist,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.event_available,
                              size: 32,
                              color: AppColors.pine,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No sessions today',
                            style: AppTypography.bodyLarge(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You have a free day to relax.',
                            style: AppTypography.bodyMedium(
                              color: AppColors.inkMute,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ...todaySessions.map(
                  (session) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _TodaySessionCard(session: session),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.count,
    required this.label,
    required this.icon,
    required this.isDark,
  });

  final int count;
  final String label;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.pine : AppColors.white;
    final textColor = isDark ? AppColors.white : AppColors.ink;
    final iconColor = isDark ? AppColors.white : AppColors.pine;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? null : Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.pine.withValues(alpha: 0.3)
                : AppColors.cardShadow,
            blurRadius: isDark ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.15)
                  : AppColors.pinePale,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(
            '$count',
            style: AppTypography.statNumber(color: textColor)
                .copyWith(fontSize: 28),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: AppTypography.metricLabel(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.8)
                  : AppColors.inkMute,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.session,
    required this.lang,
    required this.ref,
  });

  final PhysioSession session;
  final AppLanguage lang;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return AppCard(
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
                  color: AppColors.amberPale,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.amber,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.patientName,
                      style: AppTypography.bodyLarge(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      session.treatment,
                      style: AppTypography.bodySmall(color: AppColors.inkMute),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.amberPale,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Pending',
                  style: AppTypography.bodySmall(
                    color: AppColors.amber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 14,
                color: AppColors.inkMute,
              ),
              const SizedBox(width: 4),
              Text(
                DateFormatter.formatShortDate(session.date),
                style: AppTypography.bodySmall(color: AppColors.inkMid),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time_outlined,
                size: 14,
                color: AppColors.inkMute,
              ),
              const SizedBox(width: 4),
              Text(
                session.time,
                style: AppTypography.bodySmall(color: AppColors.inkMid),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref
                      .read(sessionsProvider.notifier)
                      .declineRequest(session.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Decline',
                    style: AppTypography.bodyMedium(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => ref
                      .read(sessionsProvider.notifier)
                      .acceptRequest(session.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pine,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Accept',
                    style: AppTypography.bodyMedium(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
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

class _TodaySessionCard extends StatelessWidget {
  const _TodaySessionCard({required this.session});

  final PhysioSession session;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.pinePale,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  session.time.split(':')[0],
                  style: AppTypography.headingMedium(color: AppColors.pine)
                      .copyWith(fontSize: 20),
                ),
                Text(
                  session.time.contains('AM') ? 'AM' : 'PM',
                  style: AppTypography.eyebrow(color: AppColors.pine)
                      .copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.patientName,
                  style: AppTypography.bodyLarge(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  session.treatment,
                  style: AppTypography.bodySmall(color: AppColors.inkMute),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: AppColors.pineLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      session.location,
                      style: AppTypography.bodySmall(
                        color: AppColors.pineLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.chevron_right,
              color: AppColors.inkMid,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
