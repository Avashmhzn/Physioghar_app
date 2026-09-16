import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/localization/app_strings.dart';
import 'package:physioghar_therapist/core/widgets/app_card.dart';
import 'package:physioghar_therapist/core/widgets/status_badge.dart';
import 'package:physioghar_therapist/features/schedule/domain/availability_slot.dart';

class SlotCard extends StatelessWidget {
  const SlotCard({
    super.key,
    required this.slot,
    required this.lang,
    this.onTap,
  });

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
