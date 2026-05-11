import 'package:go_router/go_router.dart';
import 'package:quran_app/features/splash/presentation/screens/splashScreen.dart';
import 'package:quran_app/features/surah_details/presentation/pages/surah_details_screen.dart';

import '../features/home/presentation/pages/home_screen.dart';
import '../features/onboarding/presentation/pages/onboarding_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/details',
        builder: (context, state) => const SurahDetailsScreen(),
      ),
    ],
  );
}
