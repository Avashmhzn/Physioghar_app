import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';

class TabLabel extends StatelessWidget {
  const TabLabel({super.key, 
    required this.title,
    required this.count,
    required this.active,
    this.highlight,
  });

  final String title;
  final int count;
  final bool active;
  final Color? highlight;

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Text(title, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: active ? AppColors.white : highlight ?? AppColors.mist,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: AppTypography.caption(
                color: active ? AppColors.pine : AppColors.slate,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
