import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';
import 'package:physioghar_therapist/features/sessions/providers/session_provider.dart';
import 'package:physioghar_therapist/features/sessions/widgets/empty_state_card.dart';
import 'package:physioghar_therapist/features/sessions/widgets/section_title.dart';
import 'package:physioghar_therapist/features/sessions/widgets/upcoming_card.dart';

class UpcomingTab extends ConsumerWidget {
  const UpcomingTab({
    super.key,
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
        child: EmptyStateCard(
          icon: Icons.event_available_outlined,
          title: 'No Upcoming Sessions',
          message: 'No sessions scheduled right now. New approved bookings will appear here.',
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        SectionTitle(
          icon: Icons.event_note_outlined,
          title: 'Confirmed Patient Visits',
          trailing: 'TODAY & UPCOMING',
        ),
        ...upcoming.map(
          (session) => Padding(
            key: ValueKey(session.id),
            padding: const EdgeInsets.only(bottom: 14),
            child: UpcomingCard(
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
