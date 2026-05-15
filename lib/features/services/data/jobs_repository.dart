import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/repository_result.dart';
import '../../../core/supabase/supabase_client.dart';
import '../models/job_item.dart';
import 'service_repository_helpers.dart';

abstract class JobsDataSource {
  Future<List<Map<String, dynamic>>> fetchRows();
}

class SupabaseJobsDataSource implements JobsDataSource {
  SupabaseJobsDataSource({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  @override
  Future<List<Map<String, dynamic>>> fetchRows() async {
    final rows = await _supabase
        .from('jobs')
        .select(
          'id, title, organization, salary, phone, description, is_active, created_at',
        )
        .eq('is_active', true)
        .order('created_at', ascending: false);
    return rowsToMaps(rows);
  }
}

class JobsRepository {
  JobsRepository({SupabaseClient? client, JobsDataSource? dataSource})
    : _dataSource = dataSource ?? SupabaseJobsDataSource(client: client);

  final JobsDataSource _dataSource;

  Future<RepositoryResult<List<JobItem>>> fetchJobsResult() async {
    try {
      final jobs = (await _dataSource.fetchRows())
          .map(JobItem.fromJson)
          .where((item) => item.title.trim().isNotEmpty)
          .toList();
      return RepositoryResult.live(jobs);
    } catch (_) {
      return const RepositoryResult.fallback(
        <JobItem>[],
        message: serviceFallbackMessage,
      );
    }
  }
}
