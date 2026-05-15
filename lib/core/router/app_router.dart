import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/listings/create_listing_screen.dart';
import '../../features/listings/listing_detail_screen.dart';
import '../../features/listings/listings_screen.dart';
import '../../features/listings/models/listing_item.dart';
import '../../features/listings/my_listings_screen.dart';
import '../../features/map/map_place_detail_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/map/models/map_place.dart';
import '../../features/news/models/news_item.dart';
import '../../features/news/news_detail_screen.dart';
import '../../features/news/news_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/saved/saved_items_screen.dart';
import '../../features/services/jobs_screen.dart';
import '../../features/services/masters_screen.dart';
import '../../features/services/taxi_services_screen.dart';
import '../../features/services/useful_contacts_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/simple_info_screen.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) =>
            LoginScreen(redirectPath: state.uri.queryParameters['redirect']),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) =>
            RegisterScreen(redirectPath: state.uri.queryParameters['redirect']),
      ),
      GoRoute(
        path: '/my-listings',
        name: 'my-listings',
        builder: (context, state) => const MyListingsScreen(),
      ),
      GoRoute(
        path: '/create-listing',
        name: 'create-listing',
        builder: (context, state) => const CreateListingScreen(),
      ),
      GoRoute(
        path: '/listing-detail/:id',
        name: 'listing-detail',
        builder: (context, state) {
          final extra = state.extra;
          return ListingDetailScreen(
            listingId: state.pathParameters['id'] ?? '',
            initialItem: extra is ListingItem ? extra : null,
          );
        },
      ),
      GoRoute(
        path: '/saved',
        name: 'saved',
        builder: (context, state) => const SavedItemsScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/news-detail/:id',
        name: 'news-detail',
        builder: (context, state) {
          final extra = state.extra;
          return NewsDetailScreen(
            newsId: state.pathParameters['id'] ?? '',
            initialItem: extra is NewsItem ? extra : null,
          );
        },
      ),
      GoRoute(
        path: '/taxi-services',
        name: 'taxi-services',
        builder: (context, state) => const TaxiServicesScreen(),
      ),
      GoRoute(
        path: '/masters',
        name: 'masters',
        builder: (context, state) => const MastersScreen(),
      ),
      GoRoute(
        path: '/useful-contacts',
        name: 'useful-contacts',
        builder: (context, state) => const UsefulContactsScreen(),
      ),
      GoRoute(
        path: '/jobs',
        name: 'jobs',
        builder: (context, state) => const JobsScreen(),
      ),
      GoRoute(
        path: '/map-place-detail/:id',
        name: 'map-place-detail',
        builder: (context, state) {
          final extra = state.extra;
          return MapPlaceDetailScreen(
            placeId: state.pathParameters['id'] ?? '',
            initialPlace: extra is MapPlace ? extra : null,
          );
        },
      ),
      GoRoute(
        path: '/admin-messages',
        name: 'admin-messages',
        builder: (context, state) => const SimpleInfoScreen(
          title: 'Admin xabarlari',
          message: 'Rasmiy xabarlar va bildirishnomalar shu yerda ko\'rinadi.',
          icon: LucideIcons.messageSquare,
        ),
      ),
      GoRoute(
        path: '/terms',
        name: 'terms',
        builder: (context, state) => const SimpleInfoScreen(
          title: 'Foydalanish shartlari',
          message: 'Gazgan City xizmatlaridan mas\'uliyat bilan foydalaning.',
          icon: LucideIcons.fileText,
        ),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const SimpleInfoScreen(
          title: 'Maxfiylik siyosati',
          message:
              'Shaxsiy ma\'lumotlar faqat shahar xizmatlari uchun ishlatiladi.',
          icon: LucideIcons.shield,
        ),
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
          AppBottomNavItem(icon: LucideIcons.home, label: 'Bosh sahifa'),
          AppBottomNavItem(icon: LucideIcons.map, label: 'Xarita'),
          AppBottomNavItem(icon: LucideIcons.megaphone, label: "E'lonlar"),
          AppBottomNavItem(icon: LucideIcons.newspaper, label: 'Yangiliklar'),
          AppBottomNavItem(icon: LucideIcons.user, label: 'Profil'),
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
