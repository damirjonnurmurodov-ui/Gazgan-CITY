import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/repository_result.dart';
import '../../../core/supabase/supabase_client.dart';
import '../models/master.dart';
import 'service_repository_helpers.dart';

abstract class MastersDataSource {
  Future<List<Map<String, dynamic>>> fetchRows();
}

class SupabaseMastersDataSource implements MastersDataSource {
  SupabaseMastersDataSource({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  @override
  Future<List<Map<String, dynamic>>> fetchRows() async {
    final rows = await _supabase
        .from('masters')
        .select(
          'id, name, profession, phone, description, is_active, created_at',
        )
        .eq('is_active', true)
        .order('created_at', ascending: false);
    return rowsToMaps(rows);
  }
}

class MastersRepository {
  MastersRepository({SupabaseClient? client, MastersDataSource? dataSource})
    : _dataSource = dataSource ?? SupabaseMastersDataSource(client: client);

  final MastersDataSource _dataSource;

  Future<RepositoryResult<List<Master>>> fetchMastersResult() async {
    try {
      final masters = (await _dataSource.fetchRows())
          .map(Master.fromJson)
          .where((item) => item.name.trim().isNotEmpty)
          .toList();
      return RepositoryResult.live(masters);
    } catch (_) {
      return const RepositoryResult.fallback(
        <Master>[],
        message: serviceFallbackMessage,
      );
    }
  }
}
