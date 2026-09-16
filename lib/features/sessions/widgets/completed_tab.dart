import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar_therapist/features/sessions/providers/session_provider.dart';
import 'package:physioghar_therapist/features/sessions/widgets/completed_card.dart';
import 'package:physioghar_therapist/features/sessions/widgets/empty_state_card.dart';
import 'package:physioghar_therapist/features/sessions/widgets/section_title.dart';

class CompletedTab extends ConsumerWidget {
  const CompletedTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = ref.watch(completedSessionsProvider);

    if (completed.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: EmptyStateCard(
          icon: Icons.assignment_turned_in_outlined,
          title: 'No Completed Sessions',
          message: 'Completed sessions will appear here.',
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        SectionTitle(
          icon: Icons.note_alt_outlined,
          title: 'Clinical SOAP Logged Records',
          trailing: 'ALL UP TO DATE',
        ),
        ...completed.map(
          (session) => Padding(
            key: ValueKey(session.id),
            padding: const EdgeInsets.only(bottom: 14),
            child: CompletedCard(session: session),
          ),
        ),
      ],
    );
  }
}
