import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../domain/availability_slot.dart';
import '../providers/schedule_provider.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen>
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
    final lang = ref.watch(languageProvider);
    final selectedDate = ref.watch(selectedScheduleDateProvider);
    final slots = ref.watch(scheduleProvider);
    final weekDates = DateFormatter.getWeekDates(selectedDate);

    final daySlots =
        slots
            .where((s) => DateFormatter.isSameDay(s.date, selectedDate))
            .toList()
          ..sort((a, b) => a.time.compareTo(b.time));

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get('schedule', lang),
                    style: AppTypography.headingLarge(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormatter.formatMonthYear(selectedDate),
                    style: AppTypography.bodyMedium(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Upcoming Schedule header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Upcoming Schedule',
                style: AppTypography.headingSmall(color: AppColors.slate),
              ),
            ),

            // Week selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        ref.read(selectedScheduleDateProvider.notifier).state =
                            selectedDate.subtract(const Duration(days: 7)),
                    icon: const Icon(
                      Icons.chevron_left,
                      color: AppColors.slate,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: weekDates.map((date) {
                        final isSelected = DateFormatter.isSameDay(
                          date,
                          selectedDate,
                        );
                        final isToday = DateFormatter.isSameDay(
                          date,
                          DateTime.now(),
                        );
                        return GestureDetector(
                          onTap: () =>
                              ref
                                      .read(
                                        selectedScheduleDateProvider.notifier,
                                      )
                                      .state =
                                  date,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.pine
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  DateFormatter.formatDayOfWeek(date),
                                  style: AppTypography.eyebrow(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.slateMute,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormatter.formatDayNumber(date),
                                  style: AppTypography.bodyLarge(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.slate,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                                if (isToday && !isSelected) ...[
                                  const SizedBox(height: 2),
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                      color: AppColors.pine,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        ref.read(selectedScheduleDateProvider.notifier).state =
                            selectedDate.add(const Duration(days: 7)),
                    icon: const Icon(
                      Icons.chevron_right,
                      color: AppColors.slate,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Day info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    DateFormatter.formatFullDate(selectedDate),
                    style: AppTypography.bodyMedium(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${daySlots.length} slots',
                    style: AppTypography.bodySmall(),
                  ),
                ],
              ),
            ),

            // Slot list
            Expanded(
              child: daySlots.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy_outlined,
                            size: 48,
                            color: AppColors.slateMute,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No slots for this day',
                            style: AppTypography.bodyMedium(),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () =>
                                _showAddSlotSheet(context, ref, selectedDate),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add Slot'),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      itemCount: daySlots.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final slot = daySlots[index];
                        return _SlotCard(
                          slot: slot,
                          lang: lang,
                          onTap: () =>
                              _showSlotActions(context, ref, slot, lang),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSlotSheet(context, ref, selectedDate),
        backgroundColor: AppColors.pine,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSlotSheet(BuildContext context, WidgetRef ref, DateTime date) {
    final times = [
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

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
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
                        Navigator.pop(ctx);
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
      ),
    );
  }

  void _showSlotActions(
    BuildContext context,
    WidgetRef ref,
    AvailabilitySlot slot,
    AppLanguage lang,
  ) {
    if (slot.status == SlotStatus.booked) return; // Can't modify booked slots

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
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
                  Navigator.pop(ctx);
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
                  Navigator.pop(ctx);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({required this.slot, required this.lang, this.onTap});

  final AvailabilitySlot slot;
  final AppLanguage lang;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final statusLabel = switch (slot.status) {
      SlotStatus.open => AppStrings.get('open', lang),
      SlotStatus.booked => AppStrings.get('booked', lang),
      SlotStatus.blocked => AppStrings.get('blocked', lang),
    };
    final bgColor = switch (slot.status) {
      SlotStatus.open => AppColors.pinePale,
      SlotStatus.booked => AppColors.sandPale,
      SlotStatus.blocked => AppColors.dangerPale,
    };
    final fgColor = switch (slot.status) {
      SlotStatus.open => AppColors.pine,
      SlotStatus.booked => AppColors.sand,
      SlotStatus.blocked => AppColors.danger,
    };
    final icon = switch (slot.status) {
      SlotStatus.open => Icons.check_circle_outline,
      SlotStatus.booked => Icons.event,
      SlotStatus.blocked => Icons.block,
    };

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 44,
            decoration: BoxDecoration(
              color: fgColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            slot.time,
            style: AppTypography.bodyLarge(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          if (slot.status == SlotStatus.booked && slot.patientName != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  slot.patientName!,
                  style: AppTypography.bodyMedium(fontWeight: FontWeight.w500),
                ),
                if (slot.treatment != null)
                  Text(slot.treatment!, style: AppTypography.bodySmall()),
              ],
            ),
            const SizedBox(width: 10),
          ],
          StatusBadge(
            label: statusLabel,
            backgroundColor: bgColor,
            foregroundColor: fgColor,
            icon: icon,
          ),
        ],
      ),
    );
  }
}
