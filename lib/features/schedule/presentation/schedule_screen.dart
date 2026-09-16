import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/localization/app_strings.dart';
import 'package:physioghar_therapist/core/localization/language_provider.dart';
import 'package:physioghar_therapist/core/utils/date_formatter.dart';
import 'package:physioghar_therapist/features/schedule/domain/availability_slot.dart';
import 'package:physioghar_therapist/features/schedule/providers/schedule_provider.dart';
import 'package:physioghar_therapist/features/schedule/widgets/schedule_modal_sheets.dart';
import 'package:physioghar_therapist/features/schedule/widgets/slot_actions_sheet.dart';
import 'package:physioghar_therapist/features/schedule/widgets/slot_card_widget.dart';

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
          ..sort(
            (a, b) =>
                DateFormatter.timeToMinutes(a.time)
                    .compareTo(DateFormatter.timeToMinutes(b.time)),
          );

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
                                AddSlotSheet.show(context, ref, selectedDate),
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
                        return SlotCard(
                          slot: slot,
                          lang: lang,
                          onTap: slot.status == SlotStatus.booked
                              ? null
                              : () => SlotActionsSheet.show(
                                  context,
                                  ref,
                                  slot,
                                  lang,
                                ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddSlotSheet.show(context, ref, selectedDate),
        backgroundColor: AppColors.pine,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
