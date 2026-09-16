import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/localization/app_strings.dart';
import 'core/localization/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.cream,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  // Preload Google Fonts for better performance
  await Future.wait([
    GoogleFonts.pendingFonts([
      GoogleFonts.newsreader(),
      GoogleFonts.inter(),
      GoogleFonts.ibmPlexMono(),
    ]),
  ]);

  runApp(const ProviderScope(child: PhysioGharApp()));
}

class PhysioGharApp extends ConsumerWidget {
  const PhysioGharApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    return MaterialApp.router(
      title: AppStrings.get('app_name', lang),
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
