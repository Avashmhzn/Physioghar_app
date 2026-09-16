import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';
import 'package:physioghar_therapist/features/sessions/providers/session_provider.dart';
import 'package:physioghar_therapist/features/sessions/widgets/empty_state_card.dart';
import 'package:physioghar_therapist/features/sessions/widgets/request_card.dart';
import 'package:physioghar_therapist/features/sessions/widgets/section_title.dart';

class RequestTab extends ConsumerWidget {
  const RequestTab({
    super.key,
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
        child: EmptyStateCard(
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
        SectionTitle(
          icon: Icons.inbox_outlined,
          title: 'New Patient Requests',
          trailing: 'REVIEW & ACCEPT',
        ),
        ...requests.map(
          (session) => Padding(
            key: ValueKey(session.id),
            padding: const EdgeInsets.only(bottom: 14),
            child: RequestCard(
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
