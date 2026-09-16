import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/features/sessions/widgets/session_shell.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return SessionShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.pinePale,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.pine, size: 28),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTypography.headingSmall()),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(color: AppColors.slateMid),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pine,
                  foregroundColor: AppColors.white,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(actionLabel!, style: AppTypography.buttonText()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
