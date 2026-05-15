import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/repository_result.dart';
import '../../../core/supabase/supabase_client.dart';
import '../models/useful_contact.dart';
import 'service_repository_helpers.dart';

abstract class UsefulContactsDataSource {
  Future<List<Map<String, dynamic>>> fetchRows();
}

class SupabaseUsefulContactsDataSource implements UsefulContactsDataSource {
  SupabaseUsefulContactsDataSource({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  @override
  Future<List<Map<String, dynamic>>> fetchRows() async {
    final rows = await _supabase
        .from('useful_contacts')
        .select(
          'id, title, phone, category, description, is_active, created_at',
        )
        .eq('is_active', true)
        .order('created_at', ascending: false);
    return rowsToMaps(rows);
  }
}

class UsefulContactsRepository {
  UsefulContactsRepository({
    SupabaseClient? client,
    UsefulContactsDataSource? dataSource,
  }) : _dataSource =
           dataSource ?? SupabaseUsefulContactsDataSource(client: client);

  final UsefulContactsDataSource _dataSource;

  Future<RepositoryResult<List<UsefulContact>>> fetchContactsResult() async {
    try {
      final contacts = (await _dataSource.fetchRows())
          .map(UsefulContact.fromJson)
          .where((item) => item.title.trim().isNotEmpty)
          .toList();
      return RepositoryResult.live(contacts);
    } catch (_) {
      return const RepositoryResult.fallback(
        <UsefulContact>[],
        message: serviceFallbackMessage,
      );
    }
  }
}
