import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/repository_result.dart';
import '../../../core/supabase/supabase_client.dart';
import '../models/listing_item.dart';

abstract class ListingsRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchListingsRows();

  Future<List<Map<String, dynamic>>> fetchCategoryRows();

  Future<Map<String, dynamic>?> fetchListingRow(String id);

  Future<List<Map<String, dynamic>>> fetchMyListingRows(String userId);

  Future<void> insertListing(Map<String, dynamic> payload);
}

class SupabaseListingsRemoteDataSource implements ListingsRemoteDataSource {
  SupabaseListingsRemoteDataSource({SupabaseClient? client}) : _client = client;

  static const String _listingColumns = '''
    id,
    user_id,
    category_id,
    title,
    description,
    price,
    location,
    phone,
    image_url,
    status,
    views_count,
    created_at,
    updated_at,
    listing_categories(name)
  ''';

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  @override
  Future<List<Map<String, dynamic>>> fetchListingsRows() async {
    final rows = await _supabase
        .from('listings')
        .select(_listingColumns)
        .eq('status', 'active')
        .order('created_at', ascending: false)
        .limit(50);
    return _rowsToMaps(rows);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCategoryRows() async {
    final rows = await _supabase
        .from('listing_categories')
        .select('id, name, sort_order, is_active')
        .eq('is_active', true)
        .order('sort_order')
        .order('name');
    return _rowsToMaps(rows);
  }

  @override
  Future<Map<String, dynamic>?> fetchListingRow(String id) async {
    final rows = await _supabase
        .from('listings')
        .select(_listingColumns)
        .eq('id', id)
        .limit(1);
    return _rowsToMaps(rows).firstOrNull;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMyListingRows(String userId) async {
    final rows = await _supabase
        .from('listings')
        .select(_listingColumns)
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);
    return _rowsToMaps(rows);
  }

  @override
  Future<void> insertListing(Map<String, dynamic> payload) async {
    await _supabase.from('listings').insert(payload);
  }

  static List<Map<String, dynamic>> _rowsToMaps(Object? rows) {
    if (rows is! Iterable) return const <Map<String, dynamic>>[];

    return rows
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }
}

class ListingsRepository {
  ListingsRepository({
    SupabaseClient? client,
    ListingsRemoteDataSource? dataSource,
  }) : _dataSource =
           dataSource ?? SupabaseListingsRemoteDataSource(client: client);

  final ListingsRemoteDataSource _dataSource;

  Future<List<ListingItem>> fetchListings() async {
    final result = await fetchListingsResult();
    return result.data;
  }

  Future<RepositoryResult<List<ListingItem>>> fetchListingsResult() async {
    try {
      final rows = await _dataSource.fetchListingsRows();
      final items = rows
          .map(ListingItem.fromJson)
          .where((item) => item.title.trim().isNotEmpty)
          .toList();

      return RepositoryResult.live(items);
    } catch (_) {
      return const RepositoryResult.fallback(
        fallbackListings,
        message: 'E\'lonlar vaqtincha lokal ma\'lumotlardan ko\'rsatildi.',
      );
    }
  }

  Future<RepositoryResult<List<ListingCategory>>>
  fetchCategoriesResult() async {
    try {
      final rows = await _dataSource.fetchCategoryRows();
      final categories = rows
          .map(ListingCategory.fromJson)
          .where((category) => category.name.trim().isNotEmpty)
          .toList();

      if (categories.isEmpty) {
        return const RepositoryResult.live(fallbackCategories);
      }

      return RepositoryResult.live(categories);
    } catch (_) {
      return const RepositoryResult.fallback(
        fallbackCategories,
        message: 'Kategoriyalar lokal ro\'yxatdan ko\'rsatildi.',
      );
    }
  }

  Future<RepositoryResult<ListingItem?>> fetchListingResult(String id) async {
    try {
      final row = await _dataSource.fetchListingRow(id);
      if (row == null) return const RepositoryResult.live(null);
      return RepositoryResult.live(ListingItem.fromJson(row));
    } catch (_) {
      return RepositoryResult.fallback(
        fallbackListings.where((item) => item.id == id).firstOrNull,
        message: 'E\'lon vaqtincha lokal ma\'lumotlardan ko\'rsatildi.',
      );
    }
  }

  Future<RepositoryResult<List<ListingItem>>> fetchMyListingsResult(
    String userId,
  ) async {
    try {
      final rows = await _dataSource.fetchMyListingRows(userId);
      final items = rows
          .map(ListingItem.fromJson)
          .where((item) => item.title.trim().isNotEmpty)
          .toList();

      return RepositoryResult.live(items);
    } catch (_) {
      return const RepositoryResult.fallback(
        <ListingItem>[],
        message: 'Mening e\'lonlarimni hozircha o\'qib bo\'lmadi.',
      );
    }
  }

  Future<void> createListing(CreateListingInput input) async {
    await _dataSource.insertListing(input.toInsertMap());
  }

  static const List<ListingCategory> fallbackCategories = <ListingCategory>[
    ListingCategory(name: 'Xizmatlar'),
    ListingCategory(name: 'Savdo'),
    ListingCategory(name: 'Ish o\'rinlari'),
    ListingCategory(name: 'Ko\'chmas mulk'),
    ListingCategory(name: 'Transport'),
    ListingCategory(name: 'Elektronika'),
    ListingCategory(name: 'Boshqa'),
  ];

  static const List<ListingItem> fallbackListings = <ListingItem>[
    ListingItem(
      id: '1',
      title: '3 xonali kvartira ijaraga beriladi',
      description:
          'Shahar markaziga yaqin, toza va qulay kvartira ijaraga beriladi.',
      price: '2 500 000 so\'m/oy',
      location: "Mustaqillik ko'chasi, 12-uy",
      phone: '+998 90 123 45 67',
      date: 'Bugun, 14:25',
      category: "Ko'chmas mulk",
      icon: LucideIcons.building2,
      imageColor: Color(0xFF4A90D9),
      viewsCount: 128,
      isFeatured: true,
      isOfficial: true,
    ),
    ListingItem(
      id: '2',
      title: 'Telefon ta\'mirlash xizmati',
      description:
          'Telefon ekran, batareya va dasturiy nosozliklar tuzatiladi.',
      price: 'Kelishiladi',
      location: "Bozor ko'chasi, 5-uy",
      phone: '+998 91 222 33 44',
      date: 'Bugun, 11:10',
      category: 'Xizmatlar',
      icon: LucideIcons.smartphone,
      imageColor: Color(0xFF5C6BC0),
      viewsCount: 74,
    ),
    ListingItem(
      id: '3',
      title: 'Santexnik xizmatlari - arzon va sifatli',
      description: 'Uy va ofislar uchun tezkor santexnik xizmatlari.',
      price: '500 000 so\'m',
      location: "Bunyodkor ko'chasi, 22-uy",
      phone: '+998 93 444 55 66',
      date: 'Kecha, 18:45',
      category: 'Xizmatlar',
      icon: LucideIcons.wrench,
      imageColor: Color(0xFF26A69A),
      viewsCount: 95,
      isOfficial: true,
    ),
    ListingItem(
      id: '4',
      title: 'Bozorda savdo rastasi ijaraga beriladi',
      description: 'Markaziy bozorda qulay joylashgan savdo rastasi.',
      price: '8 000 000 so\'m/oy',
      location: "Markaziy bozor, 3-qator",
      phone: '+998 94 777 88 99',
      date: 'Kecha, 15:30',
      category: 'Savdo',
      icon: LucideIcons.store,
      imageColor: Color(0xFFFF7043),
      viewsCount: 216,
      isFeatured: true,
    ),
    ListingItem(
      id: '5',
      title: 'Yuk tashish xizmati - Gazgan bo\'ylab',
      description: 'Shahar ichida va yaqin hududlarga yuk tashish xizmati.',
      price: '300 000 so\'m',
      location: "Tinchlik ko'chasi, 8-uy",
      phone: '+998 95 101 20 30',
      date: '07.05.2026',
      category: 'Transport',
      icon: LucideIcons.truck,
      imageColor: Color(0xFF42A5F5),
      viewsCount: 67,
    ),
    ListingItem(
      id: '6',
      title: 'Ofitsiant qabul qilinadi - restoranga',
      description: 'Mas\'uliyatli va xushmuomala xodim ishga taklif qilinadi.',
      price: '6 500 000 so\'m/oy',
      location: "Navoiy ko'chasi, 30-uy",
      phone: '+998 97 555 66 77',
      date: '07.05.2026',
      category: 'Ish o\'rinlari',
      icon: LucideIcons.briefcase,
      imageColor: Color(0xFF8D6E63),
      viewsCount: 143,
      isOfficial: true,
    ),
    ListingItem(
      id: '7',
      title: 'Elektrik ta\'mirlash - barcha hududlarda',
      description: 'Elektr tarmoqlari, rozetka va yoritish tizimlari ta\'miri.',
      price: '350 000 so\'m',
      location: "Tabiat ko'chasi, 14-uy",
      phone: '+998 99 200 30 40',
      date: '06.05.2026',
      category: 'Xizmatlar',
      icon: LucideIcons.zap,
      imageColor: Color(0xFFFFC107),
      viewsCount: 82,
    ),
    ListingItem(
      id: '8',
      title: 'Taxi xizmati shahar bo\'ylab',
      description: 'Ishonchli haydovchi, shahar bo\'ylab tezkor xizmat.',
      price: 'Kelishiladi',
      location: "Markaziy bekat",
      phone: '+998 90 900 10 20',
      date: '06.05.2026',
      category: 'Transport',
      icon: LucideIcons.car,
      imageColor: Color(0xFF7E57C2),
      viewsCount: 189,
      isFeatured: true,
    ),
  ];
}
