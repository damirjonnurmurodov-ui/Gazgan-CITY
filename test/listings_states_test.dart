import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/core/data/repository_result.dart';
import 'package:gazgan_city/features/auth/data/auth_repository.dart';
import 'package:gazgan_city/features/auth/models/auth_user.dart';
import 'package:gazgan_city/features/listings/create_listing_screen.dart';
import 'package:gazgan_city/features/listings/data/listings_repository.dart';
import 'package:gazgan_city/features/listings/listings_screen.dart';
import 'package:gazgan_city/features/listings/models/listing_item.dart';
import 'package:gazgan_city/features/listings/my_listings_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('listings screen shows empty state for live empty data', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      ListingsScreen(
        repository: _ListingsStateRepository(
          listings: const RepositoryResult.live(<ListingItem>[]),
        ),
        authRepository: _FakeAuthRepository(null),
      ),
    );

    expect(find.text('E\'lonlar topilmadi'), findsOneWidget);
    expect(find.text('3 xonali kvartira ijaraga beriladi'), findsNothing);
  });

  testWidgets('listings screen shows fallback cards on repository error', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      ListingsScreen(
        repository: _ListingsStateRepository(
          listings: const RepositoryResult.fallback(
            ListingsRepository.fallbackListings,
            message: 'E\'lonlar vaqtincha lokal ma\'lumotlardan ko\'rsatildi.',
          ),
        ),
        authRepository: _FakeAuthRepository(null),
      ),
    );

    expect(
      find.text('E\'lonlar vaqtincha lokal ma\'lumotlardan ko\'rsatildi.'),
      findsOneWidget,
    );
    expect(find.text('3 xonali kvartira ijaraga beriladi'), findsOneWidget);
  });

  testWidgets('create listing screen requires login', (tester) async {
    await _pumpScreen(
      tester,
      CreateListingScreen(
        repository: _ListingsStateRepository(),
        authRepository: _FakeAuthRepository(null),
      ),
    );

    expect(find.text('E\'lon berish uchun tizimga kiring'), findsOneWidget);
    expect(find.text('Kirish'), findsOneWidget);
  });

  testWidgets('my listings screen shows empty state for signed-in user', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      MyListingsScreen(
        repository: _ListingsStateRepository(
          myListings: const RepositoryResult.live(<ListingItem>[]),
        ),
        authRepository: _FakeAuthRepository(
          const AuthUser(id: 'user-1', email: 'ali@example.com'),
        ),
      ),
    );

    expect(find.text('Hali e\'lon yo\'q'), findsOneWidget);
    expect(find.text('Yangi e\'lon qo\'shish'), findsOneWidget);
  });
}

Future<void> _pumpScreen(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
  await tester.pump();
}

class _ListingsStateRepository extends ListingsRepository {
  _ListingsStateRepository({
    this.listings = const RepositoryResult.live(<ListingItem>[]),
    this.myListings = const RepositoryResult.live(<ListingItem>[]),
  });

  final RepositoryResult<List<ListingItem>> listings;
  final RepositoryResult<List<ListingItem>> myListings;

  @override
  Future<RepositoryResult<List<ListingItem>>> fetchListingsResult() async {
    return listings;
  }

  @override
  Future<RepositoryResult<List<ListingCategory>>>
  fetchCategoriesResult() async {
    return const RepositoryResult.live(<ListingCategory>[
      ListingCategory(id: 'category-1', name: 'Xizmatlar'),
    ]);
  }

  @override
  Future<RepositoryResult<List<ListingItem>>> fetchMyListingsResult(
    String userId,
  ) async {
    return myListings;
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
  Future<void> signOut() async {}
}
