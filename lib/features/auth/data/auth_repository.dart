import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

import '../../../core/supabase/supabase_client.dart';
import '../models/auth_user.dart';

abstract class AuthRepository {
  AuthUser? get currentUser;

  Stream<AuthUser?> get authStateChanges;

  Future<AuthUser?> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthUser?> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  });

  Future<void> signOut();
}

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  @override
  AuthUser? get currentUser {
    final user = _supabase.auth.currentUser;
    return user == null ? null : AuthUser.fromSupabase(user);
  }

  @override
  Stream<AuthUser?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((state) {
      final user = state.session?.user;
      return user == null ? null : AuthUser.fromSupabase(user);
    });
  }

  @override
  Future<AuthUser?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    final user = response.user;
    return user == null ? null : AuthUser.fromSupabase(user);
  }

  @override
  Future<AuthUser?> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: <String, dynamic>{
        if (fullName != null && fullName.trim().isNotEmpty)
          'full_name': fullName.trim(),
      },
    );
    final user = response.user;
    return user == null ? null : AuthUser.fromSupabase(user);
  }

  @override
  Future<void> signOut() => _supabase.auth.signOut();
}
