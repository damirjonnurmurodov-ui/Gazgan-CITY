import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/repository_result.dart';
import '../../../core/supabase/supabase_client.dart';
import '../models/news_item.dart';

class NewsRepository {
  NewsRepository({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  Future<List<NewsItem>> fetchNews() async {
    final result = await fetchNewsResult();
    return result.data;
  }

  Future<RepositoryResult<List<NewsItem>>> fetchNewsResult() async {
    try {
      final rows = await _supabase.from('news').select().limit(30);
      final items = rows
          .whereType<Map<String, dynamic>>()
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

  static const NewsItem fallbackFeaturedNews = NewsItem(
    id: 'featured',
    title: 'Marmarobod MFYda sayyor qabul bo\'lib o\'tadi',
    description:
        'Bugun soat 15:00 da aholi bilan ochiq muloqot tashkil etiladi. Mahalla fuqarolar yig\'inida shahar hokimi ishtirok etadi.',
    date: '08 May 2026',
    category: 'Sayyor qabullar',
    icon: LucideIcons.users,
    imageColor: Color(0xFF1368E8),
    isFeatured: true,
    isOfficial: true,
  );

  static const List<NewsItem> fallbackNews = <NewsItem>[
    NewsItem(
      id: '1',
      title: 'Shahar hokimiyati tomonidan yangi qaror qabul qilindi',
      description:
          'G\'ozg\'on shahri obodonlashtirish bo\'yicha 2026 yilgi reja tasdiqlandi.',
      date: '08 May 2026',
      category: 'Rasmiy e\'lonlar',
      icon: LucideIcons.fileText,
      imageColor: Color(0xFF1368E8),
      isOfficial: true,
    ),
    NewsItem(
      id: '2',
      title: 'Navoiy MFYda sayyor qabul o\'tkaziladi',
      description:
          'Shu hafta juma kuni soat 14:00 da Navoiy MFYda aholi murojaatlarini tinglash tadbiri.',
      date: '07 May 2026',
      category: 'Sayyor qabullar',
      icon: LucideIcons.users,
      imageColor: Color(0xFF17B26A),
      isOfficial: true,
    ),
    NewsItem(
      id: '3',
      title: 'Yoshlar festivali dasturi tasdiqlandi',
      description:
          '15-may kuni shahar markaziy bog\'ida "Yoshlar ovozi" festivali bo\'lib o\'tadi.',
      date: '06 May 2026',
      category: 'Tadbirlar',
      icon: LucideIcons.music,
      imageColor: Color(0xFFFF7043),
    ),
    NewsItem(
      id: '4',
      title: 'Mustaqillik ko\'chasida obodonlashtirish ishlari yakunlandi',
      description:
          'Ko\'cha bo\'ylab yangi yoritish tizimi o\'rnatildi va piyodalar yo\'laklari ta\'mirlandi.',
      date: '05 May 2026',
      category: 'Obodonlashtirish',
      icon: LucideIcons.trees,
      imageColor: Color(0xFF26A69A),
      isOfficial: true,
    ),
    NewsItem(
      id: '5',
      title: 'Mahalliy korxonalarda 25 ta yangi ish o\'rni yaratildi',
      description:
          'G\'ozg\'on shahridagi mahalliy korxonalarda yangi ish o\'rinlari e\'lon qilindi.',
      date: '04 May 2026',
      category: 'Ish o\'rinlari',
      icon: LucideIcons.briefcase,
      imageColor: Color(0xFF5C6BC0),
    ),
    NewsItem(
      id: '6',
      title: 'Muhim xabar: suv ta\'minoti bo\'yicha ogohlantirish',
      description:
          '12-may kuni soat 09:00 dan 16:00 gacha suv ta\'minotida vaqtinchalik uzilishlar kutilmoqda.',
      date: '04 May 2026',
      category: 'Muhim xabarlar',
      icon: LucideIcons.alertTriangle,
      imageColor: Color(0xFFF04438),
      isOfficial: true,
    ),
    NewsItem(
      id: '7',
      title: 'Yangi avtobus yo\'nalishi ishga tushdi',
      description:
          'G\'ozg\'on shahri va Navoiy viloyati o\'rtasida yangi avtobus qatnovi yo\'lga qo\'yildi.',
      date: '03 May 2026',
      category: 'Transport',
      icon: LucideIcons.bus,
      imageColor: Color(0xFF42A5F5),
    ),
    NewsItem(
      id: '8',
      title: 'Tibbiy ko\'rik kunlari e\'lon qilindi',
      description:
          'Shahar markaziy poliklinikasida 20-25 may kunlari bepul tibbiy ko\'rik o\'tkaziladi.',
      date: '02 May 2026',
      category: 'Rasmiy e\'lonlar',
      icon: LucideIcons.heartPulse,
      imageColor: Color(0xFFEC407A),
      isOfficial: true,
    ),
  ];
}
