import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/utils/date_formatter.dart';
import 'package:physioghar_therapist/core/widgets/app_card.dart';
import 'package:physioghar_therapist/features/home/providers/home_provider.dart';
import 'package:physioghar_therapist/features/home/widgets/home_state_widget.dart';
import 'package:physioghar_therapist/features/home/widgets/summery_card.dart';
import 'package:physioghar_therapist/features/home/widgets/today_session_card.dart';
import 'package:physioghar_therapist/features/profile/providers/profile_provider.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';
import 'package:physioghar_therapist/features/sessions/providers/session_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(therapistProfileProvider);
    final isHomeVisitsActive = ref.watch(homeVisitsProvider);
    final todaySessions = ref.watch(todaySessionsProvider);
    final upcomingSessions = ref.watch(upcomingSessionsProvider);
    final requests = ref.watch(requestSessionsProvider);
    final completedSessions = ref.watch(completedSessionsProvider);

    final now = DateTime.now();
    final completedThisMonth = completedSessions
        .where(
          (session) =>
              session.date.year == now.year && session.date.month == now.month,
        )
        .toList();

    // Filter by tab
    final activeSessions = todaySessions;
    final restSessions = <PhysioSession>[];
    final tomorrow = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1));
    final upcomingFromTomorrowSessions =
        upcomingSessions.where((session) {
          final sessionDay = DateTime(
            session.date.year,
            session.date.month,
            session.date.day,
          );
          return !sessionDay.isBefore(tomorrow);
        }).toList()..sort((a, b) {
          final dateComparison = a.date.compareTo(b.date);
          return dateComparison != 0
              ? dateComparison
              : a.time.compareTo(b.time);
        });
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/logo/physioghar_healthtech_logo.jpeg',
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // PhysioGhar and badge - flexible wrapper
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // PhysioGhar
                        Flexible(
                          child: Text(
                            'PhysioGhar',
                            style: AppTypography.headingSmall(
                              color: AppColors.pine,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 8),

                        // THERAPIST badge
                        Flexible(
                          child: Container(
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
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

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

              // DATE + LARGE THERAPIST IMAGE
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
                            color: AppColors.sage,
                            fontSize: 13,
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
                            color: AppColors.slateMid,
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
                                  ? AppColors.slate
                                  : AppColors.slateMid,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isHomeVisitsActive
                                ? 'Accepting Kathmandu valley appointments'
                                : 'Not accepting Kathmandu valley appointments',
                            style: AppTypography.bodyMedium(
                              color: isHomeVisitsActive
                                  ? AppColors.slateMid
                                  : AppColors.slateMute,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.sand.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.sandPale,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_active_outlined,
                          color: AppColors.sand,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Booking Requests',
                              style: AppTypography.cardTitle(
                                color: AppColors.slate,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'You have ${requests.length} new booking requests',
                              style: AppTypography.bodySmall(
                                color: AppColors.slateMid,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => context.push('/sessions'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sand,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Review',
                          style: AppTypography.buttonText(
                            color: AppColors.white,
                          ).copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

              if (requests.isNotEmpty) const SizedBox(height: 24),

              if (requests.isEmpty) const SizedBox(height: 8),

              const SizedBox(height: 16),

              // SUMMARY CARDS ROW
              LayoutBuilder(
                builder: (context, constraints) {
                  final spacing = constraints.maxWidth < 350 ? 6.0 : 8.0;
                  return Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          count: todaySessions.length,
                          label: 'Visits Today',
                          accentColor: AppColors.sand,
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: SummaryCard(
                          count: requests.length,
                          label: 'Pending ',
                          accentColor: AppColors.sage,
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: SummaryCard(
                          count: completedThisMonth.length,
                          label: 'Completed',
                          accentColor: AppColors.pine,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 28),

              // TODAY'S SCHEDULE SECTION - ON TOP
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today's Schedule", style: AppTypography.headingSmall()),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pinePale,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${todaySessions.length} sessions',
                      style: AppTypography.caption(
                        color: AppColors.pine,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Tab bar for Active/Rest
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, _) {
                    return TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.pine,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: AppColors.white,
                      unselectedLabelColor: AppColors.slateMid,
                      labelPadding: EdgeInsets.zero,
                      labelStyle: AppTypography.bodySmall(
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: AppTypography.bodySmall(
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: [
                        Tab(
                          height: 36,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Active'),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _tabController.index == 0
                                      ? AppColors.white
                                      : AppColors.mist,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${activeSessions.length}',
                                  style: AppTypography.caption(
                                    color: _tabController.index == 0
                                        ? AppColors.pine
                                        : AppColors.slate,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          height: 36,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Rest'),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _tabController.index == 1
                                      ? AppColors.white
                                      : AppColors.mist,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${restSessions.length}',
                                  style: AppTypography.caption(
                                    color: _tabController.index == 1
                                        ? AppColors.pine
                                        : AppColors.slate,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Tab view content
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: todaySessions.isEmpty ? 150 : 0,
                ),
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, _) {
                    if (_tabController.index == 0) {
                      // Active tab
                      if (activeSessions.isEmpty) {
                        return AppCard(
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
                                      color: AppColors.slateMute,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: activeSessions
                            .map(
                              (session) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: TodaySessionCard(session: session),
                              ),
                            )
                            .toList(),
                      );
                    } else {
                      // Rest tab
                      return AppCard(
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
                                    Icons.bedtime_outlined,
                                    size: 32,
                                    color: AppColors.pine,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No rest periods scheduled',
                                  style: AppTypography.bodyLarge(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 24),

              // UPCOMING SESSIONS SECTION - BELOW TODAY'S SCHEDULE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Sessions',
                    style: AppTypography.headingSmall(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (upcomingFromTomorrowSessions.isEmpty)
                const HomeEmptyState(
                  icon: Icons.event_busy_outlined,
                  title: 'No upcoming sessions',
                  message: 'Confirmed future visits will appear here.',
                )
              else
                ...upcomingFromTomorrowSessions.map(
                  (session) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TodaySessionCard(session: session),
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
