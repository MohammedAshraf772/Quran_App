import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/pages/home_screen.dart';
import '../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../features/quran/data/models/surah_model.dart';
import '../features/surah_details/presentation/pages/surah_details_screen.dart';

abstract final class AppRoutes {
  static const String onboarding = '/';
  static const String home = '/home';
  static const String surahDetails = '/surah-details';
}

class SurahDetailsArgs {
  final SurahModel surah;
  final List<SurahModel> allSurahs;
  final bool autoNextSurah;

  const SurahDetailsArgs({
    required this.surah,
    required this.allSurahs,
    this.autoNextSurah = true,
  });
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.surahDetails,
        name: AppRoutes.surahDetails,
        builder: (context, state) {
          final args = state.extra;
          if (args is! SurahDetailsArgs) {
            return const HomeScreen();
          }
          return SurahDetailsScreen(
            surah: args.surah,
            allSurahs: args.allSurahs,
            autoNextSurah: args.autoNextSurah,
          );
        },
      ),
    ],
  );
}
