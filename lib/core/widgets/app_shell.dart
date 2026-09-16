import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physioghar_therapist/core/localization/language_provider.dart';
import 'package:physioghar_therapist/core/widgets/custom_bottom_nav_bar.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == '/') return 0;
    if (location.startsWith('/schedule')) return 1;
    if (location.startsWith('/sessions')) return 2;
    if (location.startsWith('/patients')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    // Close any detail or form route opened above the current tab first.
    Navigator.of(context).popUntil((route) => route.isFirst);

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/schedule');
        break;
      case 2:
        context.go('/sessions');
        break;
      case 3:
        context.go('/patients');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        language: lang,
      ),
    );
  }
}
