import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/json_readers.dart';
import '../../../core/data/repository_result.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../listings/models/listing_item.dart';
import '../../map/models/map_place.dart';
import '../../news/models/news_item.dart';
import '../models/saved_item.dart';

abstract class SavedItemsDataSource {
  Future<List<Map<String, dynamic>>> fetchSavedRows(String userId);

  Future<List<Map<String, dynamic>>> fetchListingRows(List<String> ids);

  Future<List<Map<String, dynamic>>> fetchNewsRows(List<String> ids);

  Future<List<Map<String, dynamic>>> fetchMapPlaceRows(List<String> ids);

  Future<void> insertSavedItem({
    required String userId,
    required String itemType,
    required String itemId,
  });

  Future<void> deleteSavedItem({
    required String userId,
    required String itemType,
    required String itemId,
  });
}

class SupabaseSavedItemsDataSource implements SavedItemsDataSource {
  SupabaseSavedItemsDataSource({SupabaseClient? client}) : _client = client;

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
    listing_categories(name)
  ''';

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  @override
  Future<List<Map<String, dynamic>>> fetchSavedRows(String userId) async {
    final rows = await _supabase
        .from('saved_items')
        .select('id, user_id, item_type, item_id, created_at')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return _rowsToMaps(rows);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchListingRows(List<String> ids) async {
    if (ids.isEmpty) return const <Map<String, dynamic>>[];
    final rows = await _supabase
        .from('listings')
        .select(_listingColumns)
        .inFilter('id', ids);
    return _rowsToMaps(rows);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchNewsRows(List<String> ids) async {
    if (ids.isEmpty) return const <Map<String, dynamic>>[];
    final rows = await _supabase.from('news').select().inFilter('id', ids);
    return _rowsToMaps(rows);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMapPlaceRows(List<String> ids) async {
    if (ids.isEmpty) return const <Map<String, dynamic>>[];
    final rows = await _supabase
        .from('map_places')
        .select()
        .inFilter('id', ids);
    return _rowsToMaps(rows);
  }

  @override
  Future<void> insertSavedItem({
    required String userId,
    required String itemType,
    required String itemId,
  }) async {
    await _supabase.from('saved_items').insert(<String, dynamic>{
      'user_id': userId,
      'item_type': itemType,
      'item_id': itemId,
    });
  }

  @override
  Future<void> deleteSavedItem({
    required String userId,
    required String itemType,
    required String itemId,
  }) async {
    await _supabase
        .from('saved_items')
        .delete()
        .eq('user_id', userId)
        .eq('item_type', itemType)
        .eq('item_id', itemId);
  }

  static List<Map<String, dynamic>> _rowsToMaps(Object? rows) {
    if (rows is! Iterable) return const <Map<String, dynamic>>[];
    return rows
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }
}

class SavedItemsRepository {
  SavedItemsRepository({
    SupabaseClient? client,
    SavedItemsDataSource? dataSource,
  }) : _dataSource = dataSource ?? SupabaseSavedItemsDataSource(client: client);

  final SavedItemsDataSource _dataSource;

  Future<RepositoryResult<List<SavedItem>>> fetchSavedItemsResult(
    String userId,
  ) async {
    try {
      final rows = await _dataSource.fetchSavedRows(userId);
      final listingIds = _idsForType(rows, SavedItemType.listing);
      final newsIds = _idsForType(rows, SavedItemType.news);
      final mapPlaceIds = _idsForType(rows, SavedItemType.mapPlace);

      final listings = _mapById(
        await _dataSource.fetchListingRows(listingIds),
        ListingItem.fromJson,
      );
      final news = _mapById(
        await _dataSource.fetchNewsRows(newsIds),
        NewsItem.fromJson,
      );
      final mapPlaces = _mapById(
        await _dataSource.fetchMapPlaceRows(mapPlaceIds),
        (row) => MapPlace.fromJson(row, fallbackX: 0.5, fallbackY: 0.5),
      );

      final savedItems = rows
          .map(
            (row) => _savedFromRow(
              row,
              listings: listings,
              news: news,
              mapPlaces: mapPlaces,
            ),
          )
          .toList();

      return RepositoryResult.live(savedItems);
    } catch (_) {
      return const RepositoryResult.fallback(
        <SavedItem>[],
        message: 'Saqlanganlarni hozircha o\'qib bo\'lmadi.',
      );
    }
  }

  Future<Set<String>> fetchSavedItemIds({
    required String userId,
    required SavedItemType type,
  }) async {
    try {
      final rows = await _dataSource.fetchSavedRows(userId);
      return rows
          .where(
            (row) =>
                SavedItemType.fromValue(
                  readString(row, const <String>['item_type']),
                ) ==
                type,
          )
          .map((row) => readString(row, const <String>['item_id']))
          .where((id) => id.isNotEmpty)
          .toSet();
    } catch (_) {
      return <String>{};
    }
  }

  Future<void> saveItem({
    required String userId,
    required SavedItemType type,
    required String itemId,
  }) async {
    try {
      await _dataSource.insertSavedItem(
        userId: userId,
        itemType: type.value,
        itemId: itemId,
      );
    } on PostgrestException catch (error) {
      if (error.code != '23505') rethrow;
    }
  }

  Future<void> unsaveItem({
    required String userId,
    required SavedItemType type,
    required String itemId,
  }) async {
    await _dataSource.deleteSavedItem(
      userId: userId,
      itemType: type.value,
      itemId: itemId,
    );
  }

  Future<bool> setSaved({
    required String userId,
    required SavedItemType type,
    required String itemId,
    required bool isSaved,
  }) async {
    if (isSaved) {
      await saveItem(userId: userId, type: type, itemId: itemId);
      return true;
    }

    await unsaveItem(userId: userId, type: type, itemId: itemId);
    return false;
  }
}

List<String> _idsForType(List<Map<String, dynamic>> rows, SavedItemType type) {
  return rows
      .where(
        (row) =>
            SavedItemType.fromValue(
              readString(row, const <String>['item_type']),
            ) ==
            type,
      )
      .map((row) => readString(row, const <String>['item_id']))
      .where((id) => id.isNotEmpty)
      .toList();
}

Map<String, T> _mapById<T>(
  List<Map<String, dynamic>> rows,
  T Function(Map<String, dynamic>) mapper,
) {
  return <String, T>{
    for (final row in rows)
      if (readString(row, const <String>['id']).isNotEmpty)
        readString(row, const <String>['id']): mapper(row),
  };
}

SavedItem _savedFromRow(
  Map<String, dynamic> row, {
  required Map<String, ListingItem> listings,
  required Map<String, NewsItem> news,
  required Map<String, MapPlace> mapPlaces,
}) {
  final itemId = readString(row, const <String>['item_id']);
  final type = SavedItemType.fromValue(
    readString(row, const <String>['item_type']),
  );

  return SavedItem(
    id: readString(row, const <String>['id']),
    userId: readString(row, const <String>['user_id']),
    type: type,
    itemId: itemId,
    createdAt: readString(row, const <String>['created_at']),
    listing: type == SavedItemType.listing ? listings[itemId] : null,
    news: type == SavedItemType.news ? news[itemId] : null,
    mapPlace: type == SavedItemType.mapPlace ? mapPlaces[itemId] : null,
  );
}
