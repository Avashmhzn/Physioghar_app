import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../providers/patient_provider.dart';
import 'patient_detail_screen.dart';

class PatientListScreen extends ConsumerWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final patients = ref.watch(filteredPatientsProvider);
    final searchQuery = ref.watch(patientSearchProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get('patients', lang),
                    style: AppTypography.headingLarge(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${patients.length} total',
                    style: AppTypography.bodySmall(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search patients...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.inkMute),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => ref.read(patientSearchProvider.notifier).state = '',
                        )
                      : null,
                ),
                onChanged: (value) => ref.read(patientSearchProvider.notifier).state = value,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: patients.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search, size: 56, color: AppColors.inkMute),
                          const SizedBox(height: 16),
                          Text(
                            searchQuery.isEmpty
                                ? 'No patients yet'
                                : 'No patients found',
                            style: AppTypography.bodyMedium(),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: patients.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        return AppCard(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PatientDetailScreen(patientId: patient.id),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.pinePale,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    patient.name.split(' ').map((w) => w[0]).take(2).join(),
                                    style: AppTypography.bodyMedium(
                                      color: AppColors.pine,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patient.name,
                                      style: AppTypography.bodyLarge(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      patient.condition,
                                      style: AppTypography.bodyMedium(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.cake_outlined, size: 13, color: AppColors.inkMute),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${patient.age} yrs',
                                          style: AppTypography.bodySmall(),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(Icons.schedule, size: 13, color: AppColors.inkMute),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormatter.formatShortDate(patient.lastSessionDate),
                                          style: AppTypography.bodySmall(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: AppColors.inkMute),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
