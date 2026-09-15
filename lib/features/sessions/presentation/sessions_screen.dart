import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/date_formatter.dart';
import '../domain/session.dart';
import '../providers/session_provider.dart';

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
                      _TabLabel(
                        title: 'Requests',
                        count: requests.length,
                        active: _tabController.index == 0,
                        highlight: AppColors.sand,
                      ),
                      _TabLabel(
                        title: 'Upcoming',
                        count: upcoming.length,
                        active: _tabController.index == 1,
                      ),
                      _TabLabel(
                        title: 'Completed',
                        count: completed.length,
                        active: _tabController.index == 2,
                      ),
                      _TabLabel(
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
                      child: _InfoBanner(
                        message: _bannerMessage!,
                        onClose: _clearBanner,
                      ),
                    ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _RequestTab(
                    onAccept: (session) {
                      ref
                          .read(sessionsProvider.notifier)
                          .acceptRequest(session.id);
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
                  _UpcomingTab(
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
                  _CompletedTab(),
                  _CancelledTab(),
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
      builder: (_) => _RescheduleDialog(
        session: session,
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
      // The dialog future completes before the route's text field is fully
      // removed on some Android versions. Dispose after that removal frame.
      await Future<void>.delayed(const Duration(milliseconds: 350));
      notesController.dispose();
      return value;
    });
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.title,
    required this.count,
    required this.active,
    this.highlight,
  });

  final String title;
  final int count;
  final bool active;
  final Color? highlight;

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Text(title, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: active ? AppColors.white : highlight ?? AppColors.mist,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: AppTypography.caption(
                color: active ? AppColors.pine : AppColors.slate,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.message, required this.onClose});

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.pinePale,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.pine, size: 18),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall(
                color: AppColors.pine,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 17, color: AppColors.pine),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _RequestTab extends ConsumerWidget {
  const _RequestTab({
    required this.onAccept,
    required this.onDecline,
    required this.onGoToUpcoming,
  });

  final void Function(PhysioSession session) onAccept;
  final void Function(PhysioSession session) onDecline;
  final VoidCallback onGoToUpcoming;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(requestSessionsProvider);

    if (requests.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: _EmptyStateCard(
          icon: Icons.check_circle_outline,
          title: 'Inbox Cleared!',
          message: 'All pending therapy requests have been processed. Switch over to view active schedules.',
          actionLabel: 'Go to Upcoming Sessions',
          onAction: onGoToUpcoming,
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        _SectionTitle(
          icon: Icons.inbox_outlined,
          title: 'New Patient Requests',
          trailing: 'REVIEW & ACCEPT',
        ),
        ...requests.map(
          (session) => Padding(
            key: ValueKey(session.id),
            padding: const EdgeInsets.only(bottom: 14),
            child: _RequestCard(
              session: session,
              onAccept: onAccept,
              onDecline: onDecline,
            ),
          ),
        ),
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.session,
    required this.onAccept,
    required this.onDecline,
  });

  final PhysioSession session;
  final void Function(PhysioSession session) onAccept;
  final void Function(PhysioSession session) onDecline;

  @override
  Widget build(BuildContext context) {
    return _SessionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AvatarBadge(session: session, radius: 22),
              const SizedBox(width: 12),
              Expanded(child: _PatientNameBlock(session: session)),
              _SoftPill(
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
          _InfoStrip(
            icon: Icons.schedule_outlined,
            text:
                '${DateFormatter.formatShortDate(session.date)} • ${session.time}',
            trailing: 'REQUESTED',
          ),
          const SizedBox(height: 8),
          _InfoStrip(icon: Icons.location_on_outlined, text: session.location),
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

class _RescheduleDialog extends StatefulWidget {
  const _RescheduleDialog({required this.session, required this.onSave});

  final PhysioSession session;
  final void Function(DateTime newDate, String newTime) onSave;

  @override
  State<_RescheduleDialog> createState() => _RescheduleDialogState();
}

class _RescheduleDialogState extends State<_RescheduleDialog> {
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: DateFormatter.formatShortDate(widget.session.date),
    );
    _timeController = TextEditingController(text: widget.session.time);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reschedule Session', style: AppTypography.headingSmall()),
            const SizedBox(height: 14),
            Text(
              'Update the schedule for ${widget.session.patientName}.',
              style: AppTypography.bodyMedium(color: AppColors.slateMid),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                      minimumSize: const Size(0, 44),
                      foregroundColor: AppColors.slate,
                      side: const BorderSide(color: AppColors.border),
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
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      final newDate = DateFormat('d MMM yyyy')
                          .tryParse(_dateController.text.trim());
                      final newTime = _timeController.text.trim().isNotEmpty
                          ? _timeController.text.trim()
                          : widget.session.time;

                      widget.onSave(newDate ?? widget.session.date, newTime);
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      backgroundColor: AppColors.pine,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Save', style: AppTypography.buttonText()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingTab extends ConsumerWidget {
  const _UpcomingTab({
    required this.justAcceptedSessionId,
    required this.onReschedule,
    required this.onComplete,
  });

  final String? justAcceptedSessionId;
  final void Function(PhysioSession session) onReschedule;
  final void Function(PhysioSession session) onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(upcomingSessionsProvider);

    if (upcoming.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: _EmptyStateCard(
          icon: Icons.event_available_outlined,
          title: 'No Upcoming Sessions',
          message: 'No sessions scheduled right now. New approved bookings will appear here.',
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        _SectionTitle(
          icon: Icons.event_note_outlined,
          title: 'Confirmed Patient Visits',
          trailing: 'TODAY & UPCOMING',
        ),
        ...upcoming.map(
          (session) => Padding(
            key: ValueKey(session.id),
            padding: const EdgeInsets.only(bottom: 14),
            child: _UpcomingCard(
              session: session,
              isJustAccepted: session.id == justAcceptedSessionId,
              onReschedule: onReschedule,
              onComplete: onComplete,
            ),
          ),
        ),
      ],
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({
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
      return _JustAcceptedCard(session: session, onComplete: onComplete);
    }

    return _SessionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AvatarBadge(session: session, radius: 22),
              const SizedBox(width: 12),
              Expanded(child: _PatientNameBlock(session: session)),
              _SoftPill(
                label: _sessionProgress(session),
                background: AppColors.pinePale,
                color: AppColors.pine,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _treatmentPreview(session),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium(
              color: AppColors.slate,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 11),
          _InfoStrip(
            icon: Icons.schedule_outlined,
            text: _scheduleLine(session),
            trailing: 'CONFIRMED',
            trailingColor: AppColors.sand,
          ),
          const SizedBox(height: 8),
          _InfoStrip(icon: Icons.warning_amber_rounded, text: session.location),
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
                    _clinicalMetric(session),
                    style: AppTypography.bodySmall(
                      color: AppColors.slate,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  _clinicalGoal(session),
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

class _JustAcceptedCard extends StatelessWidget {
  const _JustAcceptedCard({required this.session, required this.onComplete});

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
              _SoftPill(
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
              _AvatarBadge(session: session, radius: 23),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PatientNameBlock(session: session),
                    const SizedBox(height: 2),
                    Text(
                      _treatmentPreview(session),
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

class _CancelledTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cancelled = ref.watch(cancelledSessionsProvider);

    if (cancelled.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: _EmptyStateCard(
          icon: Icons.cancel_outlined,
          title: 'No Cancelled Sessions',
          message: 'Cancelled bookings will appear here.',
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        _SectionTitle(
          icon: Icons.remove_circle_outline,
          title: 'Cancelled Requests',
          trailing: 'ARCHIVED',
        ),
        ...cancelled.map(
          (session) => Padding(
            key: ValueKey(session.id),
            padding: const EdgeInsets.only(bottom: 14),
            child: _CancelledCard(session: session),
          ),
        ),
      ],
    );
  }
}

class _CancelledCard extends StatelessWidget {
  const _CancelledCard({required this.session});

  final PhysioSession session;

  @override
  Widget build(BuildContext context) {
    return _SessionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AvatarBadge(session: session, radius: 22),
              const SizedBox(width: 12),
              Expanded(child: _PatientNameBlock(session: session)),
              _SoftPill(
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
          _InfoStrip(
            icon: Icons.schedule_outlined,
            text:
                '${DateFormatter.formatShortDate(session.date)} • ${session.time}',
          ),
          const SizedBox(height: 8),
          _InfoStrip(icon: Icons.location_on_outlined, text: session.location),
        ],
      ),
    );
  }
}

class _CompletedTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = ref.watch(completedSessionsProvider);

    if (completed.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: _EmptyStateCard(
          icon: Icons.assignment_turned_in_outlined,
          title: 'No Completed Sessions',
          message: 'Completed sessions will appear here.',
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        _SectionTitle(
          icon: Icons.note_alt_outlined,
          title: 'Clinical SOAP Logged Records',
          trailing: 'ALL UP TO DATE',
        ),
        ...completed.map(
          (session) => Padding(
            key: ValueKey(session.id),
            padding: const EdgeInsets.only(bottom: 14),
            child: _CompletedCard(session: session),
          ),
        ),
      ],
    );
  }
}

class _CompletedCard extends StatelessWidget {
  const _CompletedCard({required this.session});

  final PhysioSession session;

  @override
  Widget build(BuildContext context) {
    final compactOutcome =
        session.id.startsWith('req-') ||
        session.treatment.toLowerCase().contains('knee');

    return _SessionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AvatarBadge(session: session, radius: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PatientNameBlock(session: session),
                    const SizedBox(height: 2),
                    Text(
                      _treatmentPreview(session),
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
              _SoftPill(
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
                ? _OutcomeContent(session: session)
                : _SoapContent(session: session),
          ),
        ],
      ),
    );
  }
}

class _SoapContent extends StatelessWidget {
  const _SoapContent({required this.session});

  final PhysioSession session;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.note_alt_outlined,
              size: 16,
              color: AppColors.pine,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                'Therapist Clinical Remarks:',
                style: AppTypography.caption(
                  color: AppColors.pine,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              'Session 6/10',
              style: AppTypography.monoBadge(color: AppColors.slate),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '“${session.notes ?? 'Patient showed 30% improved cervical extension without radiating numbness. Advised scapular retractions 3x daily and ergonomic screen elevation.'}”',
          style: AppTypography.bodyMedium(color: AppColors.slate)
              .copyWith(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Next follow-up: Monday 10:00 AM',
                style: AppTypography.metricLabel(color: AppColors.slate),
              ),
            ),
            Text(
              'Edit SOAP  ↗',
              style: AppTypography.caption(
                color: AppColors.pine,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OutcomeContent extends StatelessWidget {
  const _OutcomeContent({required this.session});

  final PhysioSession session;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Outcome Assessment:',
                style: AppTypography.caption(
                  color: AppColors.pine,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              'Discharged Phase 1',
              style: AppTypography.monoBadge(color: AppColors.slate),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Text(
          session.notes ?? 'Isometric wall sits tolerated 45s with zero patellar tendon tenderness. Graduated to concentric step-ups.',
          style: AppTypography.bodyMedium(
            color: AppColors.slate,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 13),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.pine),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodyMedium(
                color: AppColors.slate,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            trailing,
            style: AppTypography.metricLabel(color: AppColors.pine),
          ),
        ],
      ),
    );
  }
}

class _SessionShell extends StatelessWidget {
  const _SessionShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return _SessionShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.pinePale,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.pine, size: 28),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTypography.headingSmall()),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(color: AppColors.slateMid),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pine,
                  foregroundColor: AppColors.white,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(actionLabel!, style: AppTypography.buttonText()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({required this.session, required this.radius});

  final PhysioSession session;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.mist,
          foregroundImage: session.photoUrl == null || session.photoUrl!.isEmpty
              ? null
              : NetworkImage(session.photoUrl!),
          onForegroundImageError: (_, _) {},
          child: Icon(Icons.person, color: AppColors.pine, size: radius),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            decoration: BoxDecoration(
              color: session.location.toLowerCase().contains('home')
                  ? AppColors.sandPale
                  : AppColors.pinePale,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppColors.white, width: 1.2),
            ),
            child: Text(
              session.location.toLowerCase().contains('home') ? 'HV' : 'CL',
              style: AppTypography.caption(
                color: session.location.toLowerCase().contains('home')
                    ? AppColors.sand
                    : AppColors.pine,
                fontWeight: FontWeight.w800,
              ).copyWith(fontSize: 7.5, height: 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _PatientNameBlock extends StatelessWidget {
  const _PatientNameBlock({required this.session});

  final PhysioSession session;

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: session.patientName,
        style: AppTypography.headingSmall(color: AppColors.slate)
            .copyWith(fontSize: 17, height: 1.05),
        children: [
          if (session.age != null)
            TextSpan(
              text: '  ${session.age}y',
              style: AppTypography.bodySmall(
                color: AppColors.slateMid,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

class _SoftPill extends StatelessWidget {
  const _SoftPill({
    required this.label,
    required this.background,
    required this.color,
  });

  final String label;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        label,
        style: AppTypography.monoBadge(color: color).copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _InfoStrip extends StatelessWidget {
  const _InfoStrip({
    required this.icon,
    required this.text,
    this.trailing,
    this.trailingColor,
  });

  final IconData icon;
  final String text;
  final String? trailing;
  final Color? trailingColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.pine),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall(
                color: AppColors.slate,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            Text(
              trailing!,
              style: AppTypography.caption(
                color: trailingColor ?? AppColors.pine,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String _scheduleLine(PhysioSession session) {
  if (_isToday(session.date)) {
    return 'Today, ${session.time} (In 45 mins)';
  }
  return '${DateFormatter.formatShortDate(session.date)}, ${session.time}';
}

bool _isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

String _treatmentPreview(PhysioSession session) {
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

String _sessionProgress(PhysioSession session) {
  if (session.treatment.toLowerCase().contains('back')) return 'Session 4/12';
  if (session.treatment.toLowerCase().contains('knee')) return 'Session 2/8';
  return 'Session 6/10';
}

String _clinicalMetric(PhysioSession session) {
  if (session.treatment.toLowerCase().contains('back')) {
    return 'Last ROM: Knee flexion 85°\n(Target: 95°)';
  }
  if (session.treatment.toLowerCase().contains('knee')) {
    return 'Balance: 45s assisted stand\n(Target: 60s)';
  }
  return 'Pain score: 4/10 after mobility\n(Target: 2/10)';
}

String _clinicalGoal(PhysioSession session) {
  if (session.treatment.toLowerCase().contains('back')) return '+10°\ngoal';
  if (session.treatment.toLowerCase().contains('knee')) return '+15s\ngoal';
  return '-2\ngoal';
}
