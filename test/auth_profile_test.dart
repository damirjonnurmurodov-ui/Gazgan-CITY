import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/features/auth/data/auth_repository.dart';
import 'package:gazgan_city/features/auth/models/auth_user.dart';
import 'package:gazgan_city/features/profile/data/profile_repository.dart';
import 'package:gazgan_city/features/profile/edit_profile_screen.dart';
import 'package:gazgan_city/features/profile/profile_screen.dart';
import 'package:gazgan_city/features/profile/models/user_profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('profile screen shows login actions when user is signed out', (
    tester,
  ) async {
    await _pumpProfile(tester, user: null);

    expect(find.text('Kirish'), findsOneWidget);
    expect(find.text('Ro\'yxatdan o\'tish'), findsOneWidget);
    expect(find.text('Mening e\'lonlarim'), findsNothing);
    expect(find.text('Dastur muallifi: Nurmurodov Damirjon'), findsOneWidget);
  });

  testWidgets('profile screen shows account menu when user is signed in', (
    tester,
  ) async {
    await _pumpProfile(
      tester,
      user: const AuthUser(
        id: 'user-1',
        email: 'ali@example.com',
        fullName: 'Ali Valiyev',
      ),
    );

    expect(find.text('Ali Valiyev'), findsOneWidget);
    expect(find.text('ali@example.com'), findsOneWidget);
    expect(find.text('Mening e\'lonlarim'), findsOneWidget);
    expect(find.text('Saqlanganlar'), findsOneWidget);
    expect(find.text('Chiqish'), findsOneWidget);
  });

  testWidgets('profile screen edit button opens edit route', (tester) async {
    final router = GoRouter(
      initialLocation: '/profile',
      routes: <RouteBase>[
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(
            repository: _FakeAuthRepository(
              const AuthUser(
                id: 'user-1',
                email: 'ali@example.com',
                fullName: 'Ali Valiyev',
              ),
            ),
            profileRepository: _FakeProfileRepository(),
          ),
        ),
        GoRoute(
          path: '/edit-profile',
          builder: (context, state) =>
              const Scaffold(body: Text('Profilni tahrirlash')),
        ),
      ],
    );

    await _pumpRouter(tester, router);
    await tester.tap(find.text('Tahrirlash'));
    await tester.pumpAndSettle();

    expect(find.text('Profilni tahrirlash'), findsOneWidget);
  });

  testWidgets('edit profile validates required full name', (tester) async {
    await _pumpProfile(
      tester,
      child: EditProfileScreen(
        authRepository: _FakeAuthRepository(
          const AuthUser(id: 'user-1', email: 'ali@example.com'),
        ),
        profileRepository: _FakeProfileRepository(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Ism familiya'), '');
    await tester.tap(find.text('Saqlash'));
    await tester.pump();

    expect(find.text('Ism familiya bo\'sh bo\'lmasin.'), findsOneWidget);
  });
}

Future<void> _pumpProfile(
  WidgetTester tester, {
  AuthUser? user,
  Widget? child,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body:
            child ??
            ProfileScreen(
              repository: _FakeAuthRepository(user),
              profileRepository: _FakeProfileRepository(),
            ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _pumpRouter(WidgetTester tester, GoRouter router) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pump();
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

class _FakeProfileRepository extends ProfileRepository {
  @override
  Future<UserProfile?> fetchProfile(String userId) async => null;

  @override
  Future<UserProfile> upsertProfile(UserProfile profile) async => profile;
}
