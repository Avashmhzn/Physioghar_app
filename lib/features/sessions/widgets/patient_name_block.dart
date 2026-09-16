import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';

class PatientNameBlock extends StatelessWidget {
  const PatientNameBlock({super.key, required this.session});

  final PhysioSession session;

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: session.patientName,
        style: AppTypography.headingSmall(color: AppColors.slate)
            .copyWith(fontSize: 17, height: 1.05),
        children: [
          if (session.age != null)
            TextSpan(
              text: '  ${session.age}y',
              style: AppTypography.bodySmall(
                color: AppColors.slateMid,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
