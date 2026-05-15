import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/repository_result.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../news/data/news_repository.dart';
import '../../news/models/news_item.dart';
import '../models/home_content.dart';

class HomeRepository {
  HomeRepository({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  Future<HomeContent> fetchHomeContent() async {
    final result = await fetchHomeContentResult();
    return result.data;
  }

  Future<RepositoryResult<HomeContent>> fetchHomeContentResult() async {
    final newsResult = await _fetchNews();
    final announcementResult = await _fetchAnnouncement();
    final receptionResult = await _fetchReception();
    final news = newsResult.data;
    final announcement = announcementResult.data;
    final reception = receptionResult.data;

    final content = HomeContent(
      announcement: announcement,
      reception: reception,
      news: news.isEmpty ? NewsRepository.fallbackNews.take(3).toList() : news,
      announcementCount: announcement == fallbackAnnouncement ? 3 : 1,
      receptionCount: reception == fallbackReception ? 1 : 1,
    );

    if (newsResult.isFallback ||
        announcementResult.isFallback ||
        receptionResult.isFallback) {
      return RepositoryResult.fallback(
        content,
        message: 'Bosh sahifa vaqtincha lokal ma\'lumotlardan ko\'rsatildi.',
      );
    }

    return RepositoryResult.live(content);
  }

  Future<RepositoryResult<List<NewsItem>>> _fetchNews() async {
    try {
      final rows = await _supabase.from('news').select().limit(3);
      final items = rows
          .whereType<Map<String, dynamic>>()
          .map(NewsItem.fromJson)
          .where((item) => item.title.trim().isNotEmpty)
          .toList();
      if (items.isEmpty) {
        return RepositoryResult.fallback(
          NewsRepository.fallbackNews.take(3).toList(),
          message: 'Yangiliklar topilmadi.',
        );
      }
      return RepositoryResult.live(items);
    } catch (_) {
      return RepositoryResult.fallback(
        NewsRepository.fallbackNews.take(3).toList(),
        message: 'Yangiliklarni o\'qib bo\'lmadi.',
      );
    }
  }

  Future<RepositoryResult<HomeAnnouncement>> _fetchAnnouncement() async {
    try {
      final rows = await _supabase.from('announcements').select().limit(1);
      final first = rows.whereType<Map<String, dynamic>>().firstOrNull;
      if (first == null) {
        return const RepositoryResult.fallback(
          fallbackAnnouncement,
          message: 'Rasmiy e\'lon topilmadi.',
        );
      }
      return RepositoryResult.live(HomeAnnouncement.fromJson(first));
    } catch (_) {
      return const RepositoryResult.fallback(
        fallbackAnnouncement,
        message: 'Rasmiy e\'lonni o\'qib bo\'lmadi.',
      );
    }
  }

  Future<RepositoryResult<HomeReception>> _fetchReception() async {
    try {
      final rows = await _supabase.from('mobile_receptions').select().limit(1);
      final first = rows.whereType<Map<String, dynamic>>().firstOrNull;
      if (first == null) {
        return const RepositoryResult.fallback(
          fallbackReception,
          message: 'Sayyor qabul topilmadi.',
        );
      }
      return RepositoryResult.live(HomeReception.fromJson(first));
    } catch (_) {
      return const RepositoryResult.fallback(
        fallbackReception,
        message: 'Sayyor qabulni o\'qib bo\'lmadi.',
      );
    }
  }

  static const HomeAnnouncement fallbackAnnouncement = HomeAnnouncement(
    badge: 'Rasmiy e\'lon',
    title: 'Bugun Marmarobod MFYda sayyor qabul',
    description: 'Soat 15:00 da hokim sayyor qabuli bo\'lib o\'tadi',
  );

  static const HomeReception fallbackReception = HomeReception(
    title: 'Hokim sayyor qabuli',
    location: 'Marmarobod MFY',
    time: 'Bugun, 15:00',
  );
}
