import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/features/auth/data/auth_repository.dart';

void main() {
  test('auth repository converts google OAuth errors to auth failure', () async {
    final repository = SupabaseAuthRepository(
      googleOAuthStarter: _ThrowingGoogleOAuthStarter(),
    );

    await expectLater(
      repository.signInWithGoogle(),
      throwsA(
        isA<AuthFailure>().having(
          (error) => error.message,
          'message',
          'Google orqali kirishda xatolik yuz berdi.',
        ),
      ),
    );
  });
}

class _ThrowingGoogleOAuthStarter implements GoogleOAuthStarter {
  @override
  Future<void> startGoogleOAuth({required String redirectTo}) async {
    throw Exception('provider disabled');
  }
}
