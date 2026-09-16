import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/utils/date_formatter.dart';
import 'package:physioghar_therapist/features/schedule/providers/schedule_provider.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';
import 'package:physioghar_therapist/features/sessions/providers/session_provider.dart';
import 'package:physioghar_therapist/features/sessions/widgets/cancelled_tab.dart';
import 'package:physioghar_therapist/features/sessions/widgets/completed_tab.dart';
import 'package:physioghar_therapist/features/sessions/widgets/info_banner.dart';
import 'package:physioghar_therapist/features/sessions/widgets/request_tab.dart';
import 'package:physioghar_therapist/features/sessions/widgets/reschedule_dialog.dart';
import 'package:physioghar_therapist/features/sessions/widgets/tab_label.dart';
import 'package:physioghar_therapist/features/sessions/widgets/upcoming_tab.dart';

class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key});

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _bannerMessage;
  String? _justAcceptedSessionId;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChanged);
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    if (_tabController.index != 1 && _justAcceptedSessionId != null) {
      setState(() {
        _justAcceptedSessionId = null;
      });
    }
  }

  void _showBanner(String message) {
    _bannerTimer?.cancel();
    setState(() {
      _bannerMessage = message;
    });
    _bannerTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _clearBanner();
      }
    });
  }

  void _clearBanner() {
    _bannerTimer?.cancel();
    _bannerTimer = null;
    setState(() {
      _bannerMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(requestSessionsProvider);
    final upcoming = ref.watch(upcomingSessionsProvider);
    final completed = ref.watch(completedSessionsProvider);
    final cancelled = ref.watch(cancelledSessionsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Session Desk',
                          style: AppTypography.headingLarge(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.pinePale,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.pine,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              'Active Shifts',
                              style: AppTypography.bodySmall(
                                color: AppColors.pine,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Manage booking requests, scheduled appointments, and\nclinical progression.',
                    style: AppTypography.bodyMedium(
                      color: AppColors.slateMid,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow.withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation: _tabController,
                builder: (context, _) {
                  return TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.pine,
                      borderRadius: BorderRadius.circular(18),
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
                      TabLabel(
                        title: 'Requests',
                        count: requests.length,
                        active: _tabController.index == 0,
                        highlight: AppColors.sand,
                      ),
                      TabLabel(
                        title: 'Upcoming',
                        count: upcoming.length,
                        active: _tabController.index == 1,
                      ),
                      TabLabel(
                        title: 'Completed',
                        count: completed.length,
                        active: _tabController.index == 2,
                      ),
                      TabLabel(
                        title: 'Cancelled',
                        count: cancelled.length,
                        active: _tabController.index == 3,
                        highlight: AppColors.danger.withValues(alpha: 0.12),
                      ),
                    ],
                  );
                },
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              reverseDuration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  alignment: Alignment.topCenter,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: _bannerMessage == null
                  ? const SizedBox(height: 16, key: ValueKey('empty-banner'))
                  : Padding(
                      key: const ValueKey('active-banner'),
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: InfoBanner(
                        message: _bannerMessage!,
                        onClose: _clearBanner,
                      ),
                    ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  RequestTab(
                    onAccept: (session) {
                      final accepted = ref
                          .read(sessionsProvider.notifier)
                          .acceptRequest(session.id);
                      if (!accepted) {
                        _showBanner(
                          'This time is already booked or unavailable for another patient.',
                        );
                        return;
                      }
                      _tabController.animateTo(1);
                      setState(() {
                        _justAcceptedSessionId = session.id;
                      });
                      _showBanner(
                        'Accepted ${session.patientName} (${session.treatment}). Scheduled for upcoming.',
                      );
                    },
                    onDecline: (session) async {
                      final confirmed = await _confirmDeclineDialog(
                        context,
                        session,
                      );
                      if (confirmed == true) {
                        ref
                            .read(sessionsProvider.notifier)
                            .declineRequest(session.id);
                        _showBanner('Declined ${session.patientName} request.');
                      }
                    },
                    onGoToUpcoming: () => _tabController.animateTo(1),
                  ),
                  UpcomingTab(
                    justAcceptedSessionId: _justAcceptedSessionId,
                    onReschedule: (session) async {
                      final confirmed = await _showRescheduleDialog(
                        context,
                        session,
                      );
                      if (confirmed == true) {
                        _showBanner(
                          'Rescheduled request for ${session.patientName}.',
                        );
                      }
                    },
                    onComplete: (session) async {
                      final completedSession = await _showCompleteDialog(
                        context,
                        session,
                      );
                      if (completedSession != true || !mounted) return;

                      await Future<void>.delayed(
                        const Duration(milliseconds: 220),
                      );
                      if (!mounted) return;

                      ref
                          .read(sessionsProvider.notifier)
                          .markCompleted(session.id);
                      _tabController.animateTo(2);
                      _showBanner(
                        'Session verified and clinical marks saved to SOAP records.',
                      );
                    },
                  ),
                  CompletedTab(),
                  CancelledTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _confirmDeclineDialog(
    BuildContext context,
    PhysioSession session,
  ) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Decline Request', style: AppTypography.headingSmall()),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to decline ${session.patientName} for ${session.treatment}?',
                style: AppTypography.bodyMedium(color: AppColors.slateMid),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.slate,
                        side: const BorderSide(color: AppColors.border),
                        minimumSize: const Size(0, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTypography.buttonText(color: AppColors.slate),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        backgroundColor: AppColors.danger,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Decline', style: AppTypography.buttonText()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showRescheduleDialog(
    BuildContext context,
    PhysioSession session,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (_) => RescheduleDialog(
        session: session,
        scheduledSlots: ref.read(scheduleProvider),
        onSave: (newDate, newTime) {
          ref
              .read(sessionsProvider.notifier)
              .reschedule(session.id, newDate, newTime);
        },
      ),
    );
  }

  Future<bool?> _showCompleteDialog(
    BuildContext context,
    PhysioSession session,
  ) {
    final notesController = TextEditingController(
      text: 'Patient demonstrated significant recovery. Pain VAS dropped from 6/10 to 2/10. Safe for home exercise progression.',
    );
    const paymentText = 'NPR 1,500 via eSewa Pre-paid';

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: AppColors.pinePale,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: AppColors.pine,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Complete Session',
                            style: AppTypography.headingSmall(),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${session.patientName} • Session Discharge Notes',
                            style: AppTypography.bodySmall(
                              color: AppColors.slateMid,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context, false),
                      icon: const Icon(Icons.close, size: 20),
                      color: AppColors.slateMid,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Clinical Findings & Next Exercises (SOAP)',
                  style: AppTypography.bodyMedium(
                    color: AppColors.slate,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 9),
                TextField(
                  controller: notesController,
                  maxLines: 5,
                  style: AppTypography.bodyMedium(color: AppColors.slate),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.mist,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(13),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.mist,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: AppColors.slateMid,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          paymentText,
                          style: AppTypography.bodyMedium(
                            color: AppColors.slate,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.pinePale,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'VERIFIED',
                          style: AppTypography.caption(
                            color: AppColors.pine,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context, false);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          foregroundColor: AppColors.slate,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTypography.buttonText(
                            color: AppColors.slate,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context, true);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          backgroundColor: AppColors.pine,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: Text(
                          'Save & Complete',
                          style: AppTypography.buttonText(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((value) async {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      notesController.dispose();
      return value;
    });
  }
}

TimeOfDay? parseTime(String value) {
  final parsed = DateFormat('hh:mm a').tryParse(value);
  if (parsed == null) return null;
  return TimeOfDay(hour: parsed.hour, minute: parsed.minute);
}

bool sameTime(String first, String second) {
  final firstTime = parseTime(first);
  final secondTime = parseTime(second);
  if (firstTime == null || secondTime == null) return first == second;

  return firstTime.hour == secondTime.hour &&
      firstTime.minute == secondTime.minute;
}

String scheduleLine(PhysioSession session) {
  if (isToday(session.date)) {
    return 'Today, ${session.time} (In 45 mins)';
  }
  return '${DateFormatter.formatShortDate(session.date)}, ${session.time}';
}

bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

String treatmentPreview(PhysioSession session) {
  final treatment = session.treatment;
  if (treatment.toLowerCase().contains('back')) {
    return 'Post-Operative ACL Tea...';
  }
  if (treatment.toLowerCase().contains('neck')) {
    return 'Cervical Spondylos...';
  }
  if (treatment.toLowerCase().contains('knee')) {
    return 'Acute Ankle Sprain Rehabilitation';
  }
  return treatment;
}

String sessionProgress(PhysioSession session) {
  if (session.treatment.toLowerCase().contains('back')) return 'Session 4/12';
  if (session.treatment.toLowerCase().contains('knee')) return 'Session 2/8';
  return 'Session 6/10';
}

String clinicalMetric(PhysioSession session) {
  if (session.treatment.toLowerCase().contains('back')) {
    return 'Last ROM: Knee flexion 85°\n(Target: 95°)';
  }
  if (session.treatment.toLowerCase().contains('knee')) {
    return 'Balance: 45s assisted stand\n(Target: 60s)';
  }
  return 'Pain score: 4/10 after mobility\n(Target: 2/10)';
}

String clinicalGoal(PhysioSession session) {
  if (session.treatment.toLowerCase().contains('back')) return '+10°\ngoal';
  if (session.treatment.toLowerCase().contains('knee')) return '+15s\ngoal';
  return '-2\ngoal';
}
