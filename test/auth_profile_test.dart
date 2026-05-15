import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/features/auth/data/auth_repository.dart';
import 'package:gazgan_city/features/auth/models/auth_user.dart';
import 'package:gazgan_city/features/profile/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
}

Future<void> _pumpProfile(
  WidgetTester tester, {
  required AuthUser? user,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ProfileScreen(repository: _FakeAuthRepository(user)),
      ),
    ),
  );
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
  Future<void> signOut() async {}
}
