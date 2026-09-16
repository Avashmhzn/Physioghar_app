import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:physioghar_therapist/core/widgets/app_shell.dart';
import 'package:physioghar_therapist/features/complaints/presentation/complaint_screen.dart';
import 'package:physioghar_therapist/features/home/presentation/home_screen.dart';
import 'package:physioghar_therapist/features/patients/presentation/patient_detail_screen.dart';
import 'package:physioghar_therapist/features/patients/presentation/patient_list_screen.dart';
import 'package:physioghar_therapist/features/profile/presentation/account_screen.dart';
import 'package:physioghar_therapist/features/profile/presentation/edit_profile_screen.dart';
import 'package:physioghar_therapist/features/profile/presentation/profile_detail_screen.dart';
import 'package:physioghar_therapist/features/schedule/presentation/schedule_screen.dart';
import 'package:physioghar_therapist/features/sessions/presentation/sessions_screen.dart';
import 'package:physioghar_therapist/features/sessions/presentation/session_detail_screen.dart';
import 'package:physioghar_therapist/features/splash/presentation/splash_screen.dart';

CustomTransitionPage<void> _buildTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.025, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const SplashScreen(),
      ),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => _buildTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/schedule',
          name: 'schedule',
          pageBuilder: (context, state) => _buildTransitionPage(
            key: state.pageKey,
            child: const ScheduleScreen(),
          ),
        ),
        GoRoute(
          path: '/sessions',
          name: 'sessions',
          pageBuilder: (context, state) => _buildTransitionPage(
            key: state.pageKey,
            child: const SessionsScreen(),
          ),
        ),
        GoRoute(
          path: '/sessions/:sessionId',
          name: 'session-detail',
          pageBuilder: (context, state) => _buildTransitionPage(
            key: state.pageKey,
            child: SessionDetailScreen(
              sessionId: state.pathParameters['sessionId']!,
            ),
          ),
        ),
        GoRoute(
          path: '/patients',
          name: 'patients',
          pageBuilder: (context, state) => _buildTransitionPage(
            key: state.pageKey,
            child: const PatientListScreen(),
          ),
        ),
        GoRoute(
          path: '/patients/:patientId',
          name: 'patient-detail',
          pageBuilder: (context, state) => _buildTransitionPage(
            key: state.pageKey,
            child: PatientDetailScreen(
              patientId: state.pathParameters['patientId']!,
            ),
          ),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => _buildTransitionPage(
            key: state.pageKey,
            child: const AccountScreen(),
          ),
        ),
        GoRoute(
          path: '/profile/detail',
          name: 'profile-detail',
          pageBuilder: (context, state) => _buildTransitionPage(
            key: state.pageKey,
            child: const ProfileDetailScreen(),
          ),
        ),
        GoRoute(
          path: '/profile/edit',
          name: 'profile-edit',
          pageBuilder: (context, state) => _buildTransitionPage(
            key: state.pageKey,
            child: const EditProfileScreen(),
          ),
        ),
        GoRoute(
          path: '/complaints',
          name: 'complaints',
          pageBuilder: (context, state) => _buildTransitionPage(
            key: state.pageKey,
            child: const ComplaintScreen(),
          ),
        ),
      ],
    ),
  ],
);
