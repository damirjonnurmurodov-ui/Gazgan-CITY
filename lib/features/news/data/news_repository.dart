import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/json_readers.dart';
import '../../../core/data/repository_result.dart';
import '../../../core/supabase/supabase_client.dart';
import '../models/news_item.dart';

abstract class NewsRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchNewsRows();

  Future<Map<String, dynamic>?> fetchNewsRow(String id);

  Future<void> updateViewsCount({required String id, required int viewsCount});
}

class SupabaseNewsRemoteDataSource implements NewsRemoteDataSource {
  SupabaseNewsRemoteDataSource({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  @override
  Future<List<Map<String, dynamic>>> fetchNewsRows() async {
    final rows = await _supabase
        .from('news')
        .select()
        .eq('status', 'published')
        .order('published_at', ascending: false)
        .limit(30);
    return _rowsToMaps(rows);
  }

  @override
  Future<Map<String, dynamic>?> fetchNewsRow(String id) async {
    final rows = await _supabase.from('news').select().eq('id', id).limit(1);
    return _rowsToMaps(rows).firstOrNull;
  }

  @override
  Future<void> updateViewsCount({
    required String id,
    required int viewsCount,
  }) async {
    await _supabase
        .from('news')
        .update(<String, dynamic>{'views_count': viewsCount})
        .eq('id', id);
  }

  static List<Map<String, dynamic>> _rowsToMaps(Object? rows) {
    if (rows is! Iterable) return const <Map<String, dynamic>>[];
    return rows
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }
}

class NewsRepository {
  NewsRepository({SupabaseClient? client, NewsRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? SupabaseNewsRemoteDataSource(client: client);

  final NewsRemoteDataSource _dataSource;

  Future<List<NewsItem>> fetchNews() async {
    final result = await fetchNewsResult();
    return result.data;
  }

  Future<RepositoryResult<List<NewsItem>>> fetchNewsResult() async {
    try {
      final rows = await _dataSource.fetchNewsRows();
      final items = rows
          .map(NewsItem.fromJson)
          .where((item) => item.title.trim().isNotEmpty)
          .toList();

      if (items.isEmpty) {
        return const RepositoryResult.fallback(
          fallbackNews,
          message: 'Yangiliklar topilmadi, lokal ma\'lumotlar ko\'rsatildi.',
        );
      }

      return RepositoryResult.live(items);
    } catch (_) {
      return const RepositoryResult.fallback(
        fallbackNews,
        message: 'Yangiliklar vaqtincha lokal ma\'lumotlardan ko\'rsatildi.',
      );
    }
  }

  Future<RepositoryResult<NewsItem?>> fetchNewsItemResult(String id) async {
    try {
      final row = await _dataSource.fetchNewsRow(id);
      if (row == null) return const RepositoryResult.live(null);
      return RepositoryResult.live(NewsItem.fromJson(row));
    } catch (_) {
      return RepositoryResult.fallback(
        fallbackNews.where((item) => item.id == id).firstOrNull,
        message: 'Yangilik vaqtincha lokal ma\'lumotlardan ko\'rsatildi.',
      );
    }
  }

  Future<void> incrementViews(String id) async {
    final row = await _dataSource.fetchNewsRow(id);
    if (row == null) return;

    final currentViews = _readViews(row);
    await _dataSource.updateViewsCount(id: id, viewsCount: currentViews + 1);
  }

  static int _readViews(Map<String, dynamic> row) {
    final value = readString(row, const <String>['views_count', 'views']);
    return int.tryParse(value) ?? 0;
  }

  static const NewsItem fallbackFeaturedNews = NewsItem(
    id: 'featured',
    title: 'Marmarobod MFYda sayyor qabul bo\'lib o\'tadi',
    description:
        'Bugun soat 15:00 da aholi bilan ochiq muloqot tashkil etiladi. Mahalla fuqarolar yig\'inida shahar hokimi ishtirok etadi.',
    content:
        'Aholi murojaatlarini joyida o\'rganish maqsadida ochiq muloqot tashkil etiladi.',
    date: '08 May 2026',
    category: 'Sayyor qabullar',
    icon: LucideIcons.users,
    imageColor: Color(0xFF1368E8),
    viewsCount: 180,
    isFeatured: true,
    isOfficial: true,
  );

  static const List<NewsItem> fallbackNews = <NewsItem>[
    NewsItem(
      id: '1',
      title: 'Shahar hokimiyati tomonidan yangi qaror qabul qilindi',
      description:
          'G\'ozg\'on shahri obodonlashtirish bo\'yicha 2026 yilgi reja tasdiqlandi.',
      content:
          'Qarorda mahalla infratuzilmasini yaxshilash, ko\'chalarni obodonlashtirish va aholi murojaatlari bilan ishlash bo\'yicha vazifalar belgilandi.',
      date: '08 May 2026',
      category: 'Rasmiy e\'lonlar',
      icon: LucideIcons.fileText,
      imageColor: Color(0xFF1368E8),
      viewsCount: 142,
      isOfficial: true,
    ),
    NewsItem(
      id: '2',
      title: 'Navoiy MFYda sayyor qabul o\'tkaziladi',
      description:
          'Shu hafta juma kuni soat 14:00 da Navoiy MFYda aholi murojaatlarini tinglash tadbiri.',
      content:
          'Qabul davomida kommunal xizmatlar, bandlik va mahalla infratuzilmasi bo\'yicha murojaatlar qabul qilinadi.',
      date: '07 May 2026',
      category: 'Sayyor qabullar',
      icon: LucideIcons.users,
      imageColor: Color(0xFF17B26A),
      viewsCount: 98,
      isOfficial: true,
    ),
    NewsItem(
      id: '3',
      title: 'Yoshlar festivali dasturi tasdiqlandi',
      description:
          '15-may kuni shahar markaziy bog\'ida "Yoshlar ovozi" festivali bo\'lib o\'tadi.',
      content:
          'Festival dasturida ijodiy chiqishlar, sport musobaqalari va yoshlar tashabbuslari taqdimoti o\'rin olgan.',
      date: '06 May 2026',
      category: 'Tadbirlar',
      icon: LucideIcons.music,
      imageColor: Color(0xFFFF7043),
      viewsCount: 77,
    ),
    NewsItem(
      id: '4',
      title: 'Mustaqillik ko\'chasida obodonlashtirish ishlari yakunlandi',
      description:
          'Ko\'cha bo\'ylab yangi yoritish tizimi o\'rnatildi va piyodalar yo\'laklari ta\'mirlandi.',
      content:
          'Ta\'mirlash ishlari natijasida piyodalar uchun qulaylik oshirildi va tungi yoritish yaxshilandi.',
      date: '05 May 2026',
      category: 'Obodonlashtirish',
      icon: LucideIcons.trees,
      imageColor: Color(0xFF26A69A),
      viewsCount: 121,
      isOfficial: true,
    ),
    NewsItem(
      id: '5',
      title: 'Mahalliy korxonalarda 25 ta yangi ish o\'rni yaratildi',
      description:
          'G\'ozg\'on shahridagi mahalliy korxonalarda yangi ish o\'rinlari e\'lon qilindi.',
      content:
          'Bandlikka ko\'maklashish markazi ish izlovchilarga maslahat va yo\'naltirish xizmatlarini ko\'rsatadi.',
      date: '04 May 2026',
      category: 'Ish o\'rinlari',
      icon: LucideIcons.briefcase,
      imageColor: Color(0xFF5C6BC0),
      viewsCount: 64,
    ),
    NewsItem(
      id: '6',
      title: 'Muhim xabar: suv ta\'minoti bo\'yicha ogohlantirish',
      description:
          '12-may kuni soat 09:00 dan 16:00 gacha suv ta\'minotida vaqtinchalik uzilishlar kutilmoqda.',
      content:
          'Profilaktika ishlari yakunlangach, suv ta\'minoti bosqichma-bosqich tiklanadi.',
      date: '04 May 2026',
      category: 'Muhim xabarlar',
      icon: LucideIcons.alertTriangle,
      imageColor: Color(0xFFF04438),
      viewsCount: 238,
      isOfficial: true,
    ),
    NewsItem(
      id: '7',
      title: 'Yangi avtobus yo\'nalishi ishga tushdi',
      description:
          'G\'ozg\'on shahri va Navoiy viloyati o\'rtasida yangi avtobus qatnovi yo\'lga qo\'yildi.',
      content:
          'Yo\'nalish aholining kundalik qatnovini qulaylashtirish uchun test rejimida ish boshladi.',
      date: '03 May 2026',
      category: 'Transport',
      icon: LucideIcons.bus,
      imageColor: Color(0xFF42A5F5),
      viewsCount: 83,
    ),
    NewsItem(
      id: '8',
      title: 'Tibbiy ko\'rik kunlari e\'lon qilindi',
      description:
          'Shahar markaziy poliklinikasida 20-25 may kunlari bepul tibbiy ko\'rik o\'tkaziladi.',
      content:
          'Ko\'rikdan o\'tish uchun mahalla faollari orqali oldindan ro\'yxatdan o\'tish mumkin.',
      date: '02 May 2026',
      category: 'Rasmiy e\'lonlar',
      icon: LucideIcons.heartPulse,
      imageColor: Color(0xFFEC407A),
      viewsCount: 156,
      isOfficial: true,
    ),
  ];
}
