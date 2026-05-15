import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/core/data/repository_result.dart';
import 'package:gazgan_city/features/auth/data/auth_repository.dart';
import 'package:gazgan_city/features/auth/models/auth_user.dart';
import 'package:gazgan_city/features/listings/listing_detail_screen.dart';
import 'package:gazgan_city/features/listings/models/listing_item.dart';
import 'package:gazgan_city/features/news/data/news_repository.dart';
import 'package:gazgan_city/features/news/models/news_item.dart';
import 'package:gazgan_city/features/news/news_detail_screen.dart';
import 'package:gazgan_city/features/saved/data/saved_items_repository.dart';
import 'package:gazgan_city/features/saved/models/saved_item.dart';
import 'package:gazgan_city/features/saved/saved_items_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('saved items screen shows empty state', (tester) async {
    await _pumpScreen(
      tester,
      SavedItemsScreen(
        repository: _SavedStateRepository(
          result: const RepositoryResult.live(<SavedItem>[]),
        ),
        authRepository: _FakeAuthRepository(
          const AuthUser(id: 'user-1', email: 'ali@example.com'),
        ),
      ),
    );

    expect(find.text('Saqlanganlar yo\'q'), findsOneWidget);
    expect(
      find.text('Saqlangan e\'lonlar shu yerda ko\'rinadi.'),
      findsOneWidget,
    );
  });

  testWidgets('save action sends signed-out user to login', (tester) async {
    final router = GoRouter(
      initialLocation: '/detail',
      routes: <RouteBase>[
        GoRoute(
          path: '/detail',
          builder: (context, state) => ListingDetailScreen(
            listingId: 'listing-1',
            initialItem: _listing,
            authRepository: _FakeAuthRepository(null),
            savedRepository: _SavedStateRepository(),
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) =>
              const Scaffold(body: Text('Login route opened')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();

    await tester.tap(find.text('Saqlash'));
    await tester.pumpAndSettle();

    expect(find.text('Login route opened'), findsOneWidget);
  });

  testWidgets('news detail renders official source and content', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      NewsDetailScreen(
        newsId: 'news-1',
        repository: _NewsStateRepository(item: _news),
        authRepository: _FakeAuthRepository(null),
        savedRepository: _SavedStateRepository(),
      ),
    );
    await tester.pump();

    expect(find.text('Shahar hokimiyati qarori'), findsOneWidget);
    expect(find.text('Rasmiy manba: Gazgan City'), findsOneWidget);
    expect(find.text('42 ko\'rildi'), findsOneWidget);
  });

  testWidgets('news detail keeps rendering when views increment fails', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      NewsDetailScreen(
        newsId: 'news-1',
        repository: _NewsStateRepository(item: _news, throwOnIncrement: true),
        authRepository: _FakeAuthRepository(null),
        savedRepository: _SavedStateRepository(),
      ),
    );
    await tester.pump();

    expect(find.text('Shahar hokimiyati qarori'), findsOneWidget);
    expect(find.text('Ko\'rishlar sonini yangilab bo\'lmadi.'), findsOneWidget);
  });
}

Future<void> _pumpScreen(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: child));
  await tester.pump();
}

const _listing = ListingItem(
  id: 'listing-1',
  title: 'Telefon ta\'mirlash xizmati',
  price: 'Kelishiladi',
  location: 'Bozor ko\'chasi',
  date: '15.05.2026',
  category: 'Xizmatlar',
  icon: LucideIcons.smartphone,
  imageColor: Color(0xFF1368E8),
);

const _news = NewsItem(
  id: 'news-1',
  title: 'Shahar hokimiyati qarori',
  description: 'Obodonlashtirish bo\'yicha yangi qaror qabul qilindi.',
  date: '15.05.2026',
  category: 'Rasmiy e\'lonlar',
  icon: LucideIcons.fileText,
  imageColor: Color(0xFF1368E8),
  viewsCount: 42,
  isOfficial: true,
);

class _SavedStateRepository extends SavedItemsRepository {
  _SavedStateRepository({
    this.result = const RepositoryResult.live(<SavedItem>[]),
  });

  final RepositoryResult<List<SavedItem>> result;

  @override
  Future<RepositoryResult<List<SavedItem>>> fetchSavedItemsResult(
    String userId,
  ) async {
    return result;
  }

  @override
  Future<Set<String>> fetchSavedItemIds({
    required String userId,
    required SavedItemType type,
  }) async {
    return result.data
        .where((item) => item.type == type)
        .map((item) => item.itemId)
        .toSet();
  }
}

class _NewsStateRepository extends NewsRepository {
  _NewsStateRepository({required this.item, this.throwOnIncrement = false});

  final NewsItem item;
  final bool throwOnIncrement;

  @override
  Future<RepositoryResult<NewsItem?>> fetchNewsItemResult(String id) async {
    return RepositoryResult.live(item);
  }

  @override
  Future<void> incrementViews(String id) async {
    if (throwOnIncrement) throw Exception('increment failed');
  }
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._user);

  final AuthUser? _user;

  @override
  AuthUser? get currentUser => _user;

  @override
  Stream<AuthUser?> get authStateChanges => Stream<AuthUser?>.value(_user);

  @override
  Future<AuthUser?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _user;
  }

  @override
  Future<AuthUser?> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    return _user;
  }

  @override
  Future<void> signInWithGoogle({
    String redirectTo = AuthRepository.defaultOAuthRedirectTo,
  }) async {}

  @override
  Future<void> signOut() async {}
}
