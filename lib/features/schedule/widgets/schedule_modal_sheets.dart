import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/localization/app_strings.dart';
import 'package:physioghar_therapist/core/utils/date_formatter.dart';
import 'package:physioghar_therapist/features/schedule/domain/availability_slot.dart';
import 'package:physioghar_therapist/features/schedule/providers/schedule_provider.dart';

class AddSlotSheet extends ConsumerWidget {
  const AddSlotSheet({super.key, required this.date});

  final DateTime date;

  static Future<void> show(BuildContext context, WidgetRef ref, DateTime date) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => AddSlotSheet(date: date),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const times = [
      '08:00 AM',
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '01:00 PM',
      '02:00 PM',
      '03:00 PM',
      '04:00 PM',
      '05:00 PM',
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Add New Slot', style: AppTypography.headingSmall()),
          Text(
            DateFormatter.formatFullDate(date),
            style: AppTypography.bodySmall(),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: times
                .map(
                  (time) => ActionChip(
                    label: Text(time, style: AppTypography.monoBadge()),
                    onPressed: () {
                      ref.read(scheduleProvider.notifier).addSlot(date, time);
                      Navigator.pop(context);
                    },
                    backgroundColor: AppColors.cream,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class SlotActionsSheet extends ConsumerWidget {
  const SlotActionsSheet({super.key, required this.slot, required this.lang});

  final AvailabilitySlot slot;
  final AppLanguage lang;

  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    AvailabilitySlot slot,
    AppLanguage lang,
  ) {
    if (slot.status == SlotStatus.booked) {
      return Future.value();
    }

    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SlotActionsSheet(slot: slot, lang: lang),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (slot.status == SlotStatus.booked) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Slot Actions', style: AppTypography.headingSmall()),
          Text(
            '${slot.time} · ${DateFormatter.formatShortDate(slot.date)}',
            style: AppTypography.bodySmall(),
          ),
          const SizedBox(height: 20),
          if (slot.status == SlotStatus.open)
            ListTile(
              leading: const Icon(Icons.block, color: AppColors.danger),
              title: Text(
                AppStrings.get('blocked', lang),
                style: AppTypography.bodyLarge(),
              ),
              subtitle: Text(
                'Block this time slot',
                style: AppTypography.bodySmall(),
              ),
              onTap: () {
                ref.read(scheduleProvider.notifier).blockSlot(slot.id);
                Navigator.pop(context);
              },
            )
          else if (slot.status == SlotStatus.blocked)
            ListTile(
              leading: const Icon(
                Icons.check_circle_outline,
                color: AppColors.pine,
              ),
              title: Text('Open Slot', style: AppTypography.bodyLarge()),
              subtitle: Text(
                'Make available for bookings',
                style: AppTypography.bodySmall(),
              ),
              onTap: () {
                ref.read(scheduleProvider.notifier).unblockSlot(slot.id);
                Navigator.pop(context);
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
