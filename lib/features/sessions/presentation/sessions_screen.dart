import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                AppStrings.get('sessions', lang),
                style: AppTypography.headingLarge(),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.pine,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.inkMid,
                labelStyle: AppTypography.bodySmall(fontWeight: FontWeight.w600),
                unselectedLabelStyle: AppTypography.bodySmall(),
                padding: const EdgeInsets.all(4),
                tabs: [
                  Tab(text: '${AppStrings.get('requests', lang)} (${requests.length})'),
                  Tab(text: '${AppStrings.get('upcoming', lang)} (${upcoming.length})'),
                  Tab(text: '${AppStrings.get('completed', lang)} (${completed.length})'),
                  Tab(text: '${AppStrings.get('cancelled', lang)} (${cancelled.length})'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _SessionList(sessions: requests, status: SessionStatus.request, lang: lang),
                  _SessionList(sessions: upcoming, status: SessionStatus.upcoming, lang: lang),
                  _SessionList(sessions: completed, status: SessionStatus.completed, lang: lang),
                  _SessionList(sessions: cancelled, status: SessionStatus.cancelled, lang: lang),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionList extends ConsumerWidget {
  const _SessionList({
    required this.sessions,
    required this.status,
    required this.lang,
  });

  final List<PhysioSession> sessions;
  final SessionStatus status;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_outlined,
              size: 56,
              color: AppColors.inkMute,
            ),
            const SizedBox(height: 16),
            Text(
              'No sessions in this category',
              style: AppTypography.bodyMedium(),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: sessions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _SessionCard(session: session, status: status, lang: lang);
      },
    );
  }
}

class _SessionCard extends ConsumerWidget {
  const _SessionCard({
    required this.session,
    required this.status,
    required this.lang,
  });

  final PhysioSession session;
  final SessionStatus status;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (bgColor, fgColor, icon, label) = switch (status) {
      SessionStatus.request => (AppColors.amberPale, AppColors.amber, Icons.schedule, 'PENDING'),
      SessionStatus.upcoming => (AppColors.pinePale, AppColors.pine, Icons.event, 'UPCOMING'),
      SessionStatus.completed => (AppColors.mist, AppColors.pineLight, Icons.check_circle, 'COMPLETED'),
      SessionStatus.cancelled => (AppColors.dangerPale, AppColors.danger, Icons.cancel, 'CANCELLED'),
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.patientName,
                      style: AppTypography.bodyLarge(fontWeight: FontWeight.w600),
                    ),
                    if (session.age != null)
                      Text(
                        '${session.age} years',
                        style: AppTypography.bodySmall(),
                      ),
                  ],
                ),
              ),
              StatusBadge(
                label: label,
                backgroundColor: bgColor,
                foregroundColor: fgColor,
                icon: icon,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(session.treatment, style: AppTypography.bodyMedium(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time_outlined, size: 14, color: AppColors.inkMute),
              const SizedBox(width: 4),
              Text(
                '${DateFormatter.formatShortDate(session.date)} · ${session.time}',
                style: AppTypography.bodySmall(),
              ),
              const SizedBox(width: 12),
              Icon(Icons.location_on_outlined, size: 14, color: AppColors.inkMute),
              const SizedBox(width: 4),
              Text(session.location, style: AppTypography.bodySmall()),
            ],
          ),
          if (session.notes != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.notes, size: 14, color: AppColors.inkMid),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      session.notes!,
                      style: AppTypography.bodySmall(color: AppColors.inkMid),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (status == SessionStatus.request) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => ref.read(sessionsProvider.notifier).declineRequest(session.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                      minimumSize: const Size(0, 40),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      AppStrings.get('decline', lang),
                      style: AppTypography.buttonText(color: AppColors.danger),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => ref.read(sessionsProvider.notifier).acceptRequest(session.id),
                    child: Text(
                      AppStrings.get('accept', lang),
                      style: AppTypography.buttonText(),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (status == SessionStatus.upcoming) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showMarkCompletedDialog(context, ref, session, lang),
                child: Text(
                  AppStrings.get('mark_completed', lang),
                  style: AppTypography.buttonText(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showMarkCompletedDialog(BuildContext context, WidgetRef ref, PhysioSession session, AppLanguage lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Mark as Completed', style: AppTypography.headingSmall()),
        content: Text(
          'Are you sure you want to mark this session with ${session.patientName} as completed?',
          style: AppTypography.bodyMedium(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTypography.bodyMedium(color: AppColors.inkMid)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(sessionsProvider.notifier).markCompleted(session.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 40),
              shape: const StadiumBorder(),
            ),
            child: Text('Confirm', style: AppTypography.buttonText()),
          ),
        ],
      ),
    );
  }
}
