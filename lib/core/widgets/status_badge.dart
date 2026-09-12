import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.icon,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: foregroundColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foregroundColor),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: AppTypography.monoBadge(color: foregroundColor),
          ),
        ],
      ),
    );
  }
}

class AppStatusColors {
  static const openBg = AppColors.pinePale;
  static const openFg = AppColors.pine;
  static const bookedBg = AppColors.amberPale;
  static const bookedFg = AppColors.amber;
  static const blockedBg = AppColors.dangerPale;
  static const blockedFg = AppColors.danger;
  static const neutralBg = AppColors.mist;
  static const neutralFg = AppColors.inkMid;
}
