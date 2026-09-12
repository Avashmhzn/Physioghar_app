import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_theme.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/schedule/presentation/schedule_screen.dart';
import 'features/sessions/presentation/sessions_screen.dart';
import 'features/patients/presentation/patient_list_screen.dart';
import 'features/profile/presentation/account_screen.dart';
import 'core/constants/app_colors.dart';
import 'core/localization/app_strings.dart';
import 'core/localization/language_provider.dart';

void main() {
  runApp(const ProviderScope(child: PhysioGharApp()));
}

class PhysioGharApp extends ConsumerWidget {
  const PhysioGharApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    return MaterialApp(
      title: AppStrings.get('app_name', lang),
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AppShell(),
    );
  }
}

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    ScheduleScreen(),
    SessionsScreen(),
    PatientListScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppColors.white,
          elevation: 0,
          indicatorColor: AppColors.pinePale,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home, color: AppColors.pine),
              label: 'Home',
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_today_outlined),
              selectedIcon: const Icon(Icons.calendar_today, color: AppColors.pine),
              label: AppStrings.get('schedule', lang),
            ),
            NavigationDestination(
              icon: const Icon(Icons.assignment_outlined),
              selectedIcon: const Icon(Icons.assignment, color: AppColors.pine),
              label: AppStrings.get('sessions', lang),
            ),
            NavigationDestination(
              icon: const Icon(Icons.people_outline),
              selectedIcon: const Icon(Icons.people, color: AppColors.pine),
              label: AppStrings.get('patients', lang),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person, color: AppColors.pine),
              label: AppStrings.get('profile', lang),
            ),
          ],
        ),
      ),
    );
  }
}
