import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar_therapist/features/sessions/providers/session_provider.dart';
import 'package:physioghar_therapist/features/sessions/widgets/cancelled_card.dart';
import 'package:physioghar_therapist/features/sessions/widgets/empty_state_card.dart';
import 'package:physioghar_therapist/features/sessions/widgets/section_title.dart';

class CancelledTab extends ConsumerWidget {
  const CancelledTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cancelled = ref.watch(cancelledSessionsProvider);

    if (cancelled.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: EmptyStateCard(
          icon: Icons.cancel_outlined,
          title: 'No Cancelled Sessions',
          message: 'Cancelled bookings will appear here.',
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        SectionTitle(
          icon: Icons.remove_circle_outline,
          title: 'Cancelled Requests',
          trailing: 'ARCHIVED',
        ),
        ...cancelled.map(
          (session) => Padding(
            key: ValueKey(session.id),
            padding: const EdgeInsets.only(bottom: 14),
            child: CancelledCard(session: session),
          ),
        ),
      ],
    );
  }
}
