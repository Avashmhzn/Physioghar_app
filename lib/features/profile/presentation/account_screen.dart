import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/localization/app_strings.dart';
import 'package:physioghar_therapist/core/localization/language_provider.dart';
import 'package:physioghar_therapist/core/widgets/app_card.dart';
import 'package:physioghar_therapist/features/home/providers/home_provider.dart';
import 'package:physioghar_therapist/features/profile/providers/profile_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final profile = ref.watch(therapistProfileProvider);
    final isAvailable = ref.watch(homeVisitsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.pine,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(profile.profilePicUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(profile.name, style: AppTypography.headingSmall()),
              Text(
                profile.specialization,
                style: AppTypography.bodyMedium(color: AppColors.slateMid),
              ),
              const SizedBox(height: 32),

              AppCard(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.person_outline,
                        color: AppColors.pine,
                      ),
                      title: Text(AppStrings.get('my profile', lang)),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () => context.push('/profile/detail'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.edit_note_outlined,
                        color: AppColors.pine,
                      ),
                      title: Text(AppStrings.get('edit_profile', lang)),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () => context.push('/profile/edit'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.event_available_outlined,
                        color: AppColors.pine,
                      ),
                      title: Text(AppStrings.get('availability', lang)),
                      trailing: Switch(
                        value: isAvailable,
                        onChanged: (value) {
                          ref
                              .read(homeVisitsProvider.notifier)
                              .setHomeVisits(value);
                        },
                        activeThumbColor: AppColors.pine,
                        activeTrackColor: AppColors.pine.withValues(
                          alpha: 0.35,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.language,
                        color: AppColors.pine,
                      ),
                      title: Text(AppStrings.get('language', lang)),
                      trailing: DropdownButton<AppLanguage>(
                        value: lang,
                        underline: const SizedBox(),
                        onChanged: (val) {
                          if (val != null) {
                            ref
                                .read(languageProvider.notifier)
                                .setLanguage(val);
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value: AppLanguage.english,
                            child: Text('English'),
                          ),
                          DropdownMenuItem(
                            value: AppLanguage.nepali,
                            child: Text('नेपाली'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.report_problem_outlined,
                        color: AppColors.pine,
                      ),
                      title: Text(AppStrings.get('complaints', lang)),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () => context.push('/complaints'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: AppColors.danger,
                      ),
                      title: const Text('Logout'),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logged out successfully'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
