import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/features/saved/data/saved_items_repository.dart';
import 'package:gazgan_city/features/saved/models/saved_item.dart';

void main() {
  test('saved repository maps saved rows with listing details', () async {
    final repository = SavedItemsRepository(
      dataSource: _FakeSavedItemsDataSource(
        savedRows: const <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'saved-1',
            'user_id': 'user-1',
            'item_type': 'listing',
            'item_id': 'listing-1',
            'created_at': '2026-05-15T09:00:00Z',
          },
        ],
        listingRows: const <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'listing-1',
            'title': 'Telefon ta\'mirlash xizmati',
            'price': 'Kelishiladi',
            'location': 'Bozor ko\'chasi',
            'category': 'Xizmatlar',
            'created_at': '2026-05-15T08:00:00Z',
          },
        ],
      ),
    );

    final result = await repository.fetchSavedItemsResult('user-1');
    final saved = result.data.single;

    expect(result.isFallback, isFalse);
    expect(saved.id, 'saved-1');
    expect(saved.type, SavedItemType.listing);
    expect(saved.itemId, 'listing-1');
    expect(saved.listing?.title, 'Telefon ta\'mirlash xizmati');
  });
}

class _FakeSavedItemsDataSource implements SavedItemsDataSource {
  const _FakeSavedItemsDataSource({
    this.savedRows = const <Map<String, dynamic>>[],
    this.listingRows = const <Map<String, dynamic>>[],
  });

  final List<Map<String, dynamic>> savedRows;
  final List<Map<String, dynamic>> listingRows;

  @override
  Future<List<Map<String, dynamic>>> fetchSavedRows(String userId) async {
    return savedRows.where((row) => row['user_id'] == userId).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchListingRows(List<String> ids) async {
    return listingRows.where((row) => ids.contains(row['id'])).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMapPlaceRows(List<String> ids) async {
    return const <Map<String, dynamic>>[];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchNewsRows(List<String> ids) async {
    return const <Map<String, dynamic>>[];
  }

  @override
  Future<void> insertSavedItem({
    required String userId,
    required String itemType,
    required String itemId,
  }) async {}

  @override
  Future<void> deleteSavedItem({
    required String userId,
    required String itemType,
    required String itemId,
  }) async {}
}
