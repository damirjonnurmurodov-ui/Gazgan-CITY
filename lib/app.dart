import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/app_bottom_nav.dart';
import 'features/home/home_screen.dart';
import 'features/listings/listings_screen.dart';
import 'features/map/map_screen.dart';
import 'features/news/news_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/splash/splash_screen.dart';

class GazganCityApp extends StatelessWidget {
  const GazganCityApp({super.key});

  static final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _AppShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/map',
                name: 'map',
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/listings',
                name: 'listings',
                builder: (context, state) => const ListingsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/news',
                name: 'news',
                builder: (context, state) => const NewsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gazgan City',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        items: const <AppBottomNavItem>[
          AppBottomNavItem(
            icon: LucideIcons.home,
            label: 'Bosh sahifa',
          ),
          AppBottomNavItem(
            icon: LucideIcons.map,
            label: 'Xarita',
          ),
          AppBottomNavItem(
            icon: LucideIcons.megaphone,
            label: "E'lonlar",
          ),
          AppBottomNavItem(
            icon: LucideIcons.newspaper,
            label: 'Yangiliklar',
          ),
          AppBottomNavItem(
            icon: LucideIcons.user,
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
