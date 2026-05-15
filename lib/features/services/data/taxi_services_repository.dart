import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/repository_result.dart';
import '../../../core/supabase/supabase_client.dart';
import '../models/taxi_service.dart';
import 'service_repository_helpers.dart';

abstract class TaxiServicesDataSource {
  Future<List<Map<String, dynamic>>> fetchRows();
}

class SupabaseTaxiServicesDataSource implements TaxiServicesDataSource {
  SupabaseTaxiServicesDataSource({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  @override
  Future<List<Map<String, dynamic>>> fetchRows() async {
    final rows = await _supabase
        .from('taxi_services')
        .select('id, name, phone, description, is_active, created_at')
        .eq('is_active', true)
        .order('created_at', ascending: false);
    return rowsToMaps(rows);
  }
}

class TaxiServicesRepository {
  TaxiServicesRepository({
    SupabaseClient? client,
    TaxiServicesDataSource? dataSource,
  }) : _dataSource =
           dataSource ?? SupabaseTaxiServicesDataSource(client: client);

  final TaxiServicesDataSource _dataSource;

  Future<RepositoryResult<List<TaxiService>>> fetchServicesResult() async {
    try {
      final services = (await _dataSource.fetchRows())
          .map(TaxiService.fromJson)
          .where((item) => item.name.trim().isNotEmpty)
          .toList();
      return RepositoryResult.live(services);
    } catch (_) {
      return const RepositoryResult.fallback(
        <TaxiService>[],
        message: serviceFallbackMessage,
      );
    }
  }
}
