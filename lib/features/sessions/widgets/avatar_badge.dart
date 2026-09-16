import 'package:flutter/material.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/features/sessions/domain/session.dart';

class AvatarBadge extends StatelessWidget {
  const AvatarBadge({super.key, required this.session, required this.radius});

  final PhysioSession session;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.mist,
          foregroundImage: session.photoUrl == null || session.photoUrl!.isEmpty
              ? null
              : NetworkImage(session.photoUrl!),
          onForegroundImageError: (_, _) {},
          child: Icon(Icons.person, color: AppColors.pine, size: radius),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            decoration: BoxDecoration(
              color: session.location.toLowerCase().contains('home')
                  ? AppColors.sandPale
                  : AppColors.pinePale,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppColors.white, width: 1.2),
            ),
            child: Text(
              session.location.toLowerCase().contains('home') ? 'HV' : 'CL',
              style: AppTypography.caption(
                color: session.location.toLowerCase().contains('home')
                    ? AppColors.sand
                    : AppColors.pine,
                fontWeight: FontWeight.w800,
              ).copyWith(fontSize: 7.5, height: 1),
            ),
          ),
        ),
      ],
    );
  }
}
