import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/features/auth/data/auth_repository.dart';
import 'package:gazgan_city/features/auth/models/auth_user.dart';
import 'package:gazgan_city/features/auth/screens/login_screen.dart';
import 'package:gazgan_city/features/auth/screens/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('login screen shows email password form', (tester) async {
    await _pumpAuthScreen(
      tester,
      LoginScreen(repository: _FakeAuthRepository()),
    );

    expect(find.text('Kirish'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Parol'), findsOneWidget);
  });

  testWidgets('login screen shows google sign in button', (tester) async {
    await _pumpAuthScreen(
      tester,
      LoginScreen(repository: _FakeAuthRepository()),
    );

    expect(find.text('Google orqali davom etish'), findsOneWidget);
  });

  testWidgets('login screen shows google error without crashing', (
    tester,
  ) async {
    await _pumpAuthScreen(
      tester,
      LoginScreen(repository: _FakeAuthRepository(googleThrows: true)),
    );

    await tester.tap(find.text('Google orqali davom etish'));
    await tester.pump();

    expect(find.text('Google orqali kirishda xatolik yuz berdi.'), findsOneWidget);
  });

  testWidgets('register screen shows full name email password form', (
    tester,
  ) async {
    await _pumpAuthScreen(
      tester,
      RegisterScreen(repository: _FakeAuthRepository()),
    );

    expect(find.text('Ro\'yxatdan o\'tish'), findsWidgets);
    expect(find.text('Ism familiya'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Parol'), findsOneWidget);
  });

  testWidgets('register screen shows google sign in button', (tester) async {
    await _pumpAuthScreen(
      tester,
      RegisterScreen(repository: _FakeAuthRepository()),
    );

    expect(find.text('Google orqali davom etish'), findsOneWidget);
  });
}

Future<void> _pumpAuthScreen(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: child));
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.googleThrows = false});

  final bool googleThrows;

  @override
  AuthUser? get currentUser => null;

  @override
  Stream<AuthUser?> get authStateChanges => const Stream<AuthUser?>.empty();

  @override
  Future<AuthUser?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return null;
  }

  @override
  Future<AuthUser?> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    return null;
  }

  @override
  Future<void> signInWithGoogle({
    String redirectTo = AuthRepository.defaultOAuthRedirectTo,
  }) async {
    if (googleThrows) {
      throw const AuthFailure('Google orqali kirishda xatolik yuz berdi.');
    }
  }

  @override
  Future<void> signOut() async {}
}
