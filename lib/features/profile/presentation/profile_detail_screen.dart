import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/localization/app_strings.dart';
import 'package:physioghar_therapist/core/localization/language_provider.dart';
import 'package:physioghar_therapist/features/profile/providers/profile_provider.dart';
import 'package:physioghar_therapist/features/profile/widget/info_tile_widget.dart';

class ProfileDetailScreen extends ConsumerWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final profile = ref.watch(therapistProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.get('my profile', lang),
          style: AppTypography.headingSmall(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.pine,
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: NetworkImage(profile.profilePicUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                profile.name,
                style: AppTypography.headingMedium(),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                profile.specialization,
                style: AppTypography.bodyMedium(color: AppColors.slateMid),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            InfoTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: profile.email,
            ),
            InfoTile(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: profile.phone,
            ),
            InfoTile(
              icon: Icons.work_outline,
              label: 'Experience',
              value: profile.experience,
            ),
            InfoTile(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: profile.address,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/profile/edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pine,
                  foregroundColor: AppColors.white,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text('Edit Profile', style: AppTypography.buttonText()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
