import 'package:go_router/go_router.dart';

import '../features/home/presentation/pages/home_screen.dart';
import '../features/onboarding/presentation/pages/onboarding_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const OnboardingScreen();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
    ],
  );
}
