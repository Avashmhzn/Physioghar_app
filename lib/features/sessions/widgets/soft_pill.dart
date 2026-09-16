import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';

class SoftPill extends StatelessWidget {
  const SoftPill({super.key, 
    required this.label,
    required this.background,
    required this.color,
  });

  final String label;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        label,
        style: AppTypography.monoBadge(color: color).copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
