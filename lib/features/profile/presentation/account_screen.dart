import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/widgets/app_card.dart';
import '../providers/profile_provider.dart';
import 'edit_profile_screen.dart';
import '../../complaints/presentation/complaint_screen.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final profile = ref.watch(therapistProfileProvider);

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
              Text(profile.specialization, style: AppTypography.bodyMedium(color: AppColors.inkMid)),
              const SizedBox(height: 32),

              AppCard(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline, color: AppColors.pine),
                      title: Text(AppStrings.get('edit_profile', lang)),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.language, color: AppColors.pine),
                      title: Text(AppStrings.get('language', lang)),
                      trailing: DropdownButton<AppLanguage>(
                        value: lang,
                        underline: const SizedBox(),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(languageProvider.notifier).setLanguage(val);
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: AppLanguage.english, child: Text('English')),
                          DropdownMenuItem(value: AppLanguage.nepali, child: Text('नेपाली')),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.report_problem_outlined, color: AppColors.pine),
                      title: Text(AppStrings.get('complaints', lang)),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ComplaintScreen()),
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
