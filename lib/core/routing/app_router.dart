import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/about/view/about_page.dart';
import '../../features/home/view/home_page.dart';
import '../../features/onboarding/view/onboarding_page.dart';
import '../../features/political_currents/view/current_detail_page.dart';
import '../../features/political_currents/view/explore_page.dart';
import '../../features/privacy/view/privacy_page.dart';
import '../../features/quiz/view/quiz_page.dart';
import '../../features/results/view/results_page.dart';
import '../../features/settings/bloc/settings_bloc.dart';
import '../../features/settings/view/settings_page.dart';
import '../widgets/main_shell.dart';
import '../widgets/gradient_scaffold.dart';

/// Clé globale du navigateur racine (routes plein écran : quiz, résultats…).
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Crée le routeur principal de l'app.
///
/// Structure :
/// - [StatefulShellRoute] : 3 onglets (/explore, /home, /settings) dans [MainShell]
/// - Routes hors shell avec [parentNavigatorKey] : quiz, résultats, fiches…
/// - Redirect : force /onboarding tant que non terminé
GoRouter createRouter({required bool onboardingDone}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: onboardingDone ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExplorePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/quiz',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const QuizPage(),
      ),
      GoRoute(
        path: '/results',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            const AppNavOverlay(selectedIndex: 1, child: ResultsPage()),
      ),
      GoRoute(
        path: '/about',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            const AppNavOverlay(selectedIndex: 2, child: AboutPage()),
      ),
      GoRoute(path: '/methodology', redirect: (context, state) => '/about'),
      GoRoute(
        path: '/privacy',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            const AppNavOverlay(selectedIndex: 2, child: PrivacyPage()),
      ),
      GoRoute(
        path: '/current/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => AppNavOverlay(
          selectedIndex: 0,
          child: CurrentDetailPage(currentId: state.pathParameters['id']!),
        ),
      ),
    ],
    redirect: (context, state) {
      final done = context.read<SettingsBloc>().state.onboardingDone;
      final onOnboarding = state.matchedLocation == '/onboarding';
      final replay = state.uri.queryParameters['replay'] == '1';
      if (!done && !onOnboarding) return '/onboarding';
      if (done && onOnboarding && !replay) return '/home';
      if (state.uri.path == '/') return '/home';
      return null;
    },
    errorBuilder: (context, state) => AppNavOverlay(
      selectedIndex: 1,
      child: GradientScaffold(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Page introuvable',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Cette page n’existe pas ou a été déplacée.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Retour à l’accueil'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
