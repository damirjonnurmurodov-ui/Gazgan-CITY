import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

import '../../../core/supabase/supabase_client.dart';
import '../models/user_profile.dart';

abstract class ProfileDataSource {
  Future<Map<String, dynamic>?> fetchProfileRow(String userId);

  Future<Map<String, dynamic>> upsertProfileRow(Map<String, dynamic> payload);
}

class SupabaseProfileDataSource implements ProfileDataSource {
  SupabaseProfileDataSource({SupabaseClient? client}) : _client = client;

  static const String _profileColumns = '''
    id,
    full_name,
    phone,
    address,
    avatar_url
  ''';

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  @override
  Future<Map<String, dynamic>?> fetchProfileRow(String userId) async {
    final rows = await _supabase
        .from('profiles')
        .select(_profileColumns)
        .eq('id', userId)
        .limit(1);
    return _rowsToMaps(rows).firstOrNull;
  }

  @override
  Future<Map<String, dynamic>> upsertProfileRow(
    Map<String, dynamic> payload,
  ) async {
    final rows = await _supabase
        .from('profiles')
        .upsert(payload)
        .select(_profileColumns)
        .limit(1);
    return _rowsToMaps(rows).first;
  }

  static List<Map<String, dynamic>> _rowsToMaps(Object? rows) {
    if (rows is! Iterable) return const <Map<String, dynamic>>[];

    return rows
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }
}

class ProfileRepository {
  ProfileRepository({
    SupabaseClient? client,
    ProfileDataSource? dataSource,
  }) : _dataSource = dataSource ?? SupabaseProfileDataSource(client: client);

  final ProfileDataSource _dataSource;

  Future<UserProfile?> fetchProfile(String userId) async {
    final row = await _dataSource.fetchProfileRow(userId);
    if (row == null) return null;
    return UserProfile.fromJson(row);
  }

  Future<UserProfile> upsertProfile(UserProfile profile) async {
    final row = await _dataSource.upsertProfileRow(profile.toUpsertMap());
    return UserProfile.fromJson(row);
  }
}
