import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 13),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.pine),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodyMedium(
                color: AppColors.slate,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            trailing,
            style: AppTypography.metricLabel(color: AppColors.pine),
          ),
        ],
      ),
    );
  }
}
