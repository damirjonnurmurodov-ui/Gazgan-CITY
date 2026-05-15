import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/features/listings/data/listings_repository.dart';
import 'package:gazgan_city/features/listings/models/listing_item.dart';

void main() {
  test('repository maps nested listing category rows', () async {
    final repository = ListingsRepository(
      dataSource: _FakeListingsRemoteDataSource(
        listingRows: <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'listing-1',
            'user_id': 'user-1',
            'category_id': 'category-1',
            'title': 'Telefon ta\'mirlash xizmati',
            'description': 'Ekran va batareya almashtirish.',
            'price': 'Kelishiladi',
            'location': 'Bozor ko\'chasi',
            'phone': '+998901112233',
            'status': 'active',
            'views_count': 12,
            'created_at': '2026-05-15T08:00:00Z',
            'listing_categories': <String, dynamic>{'name': 'Xizmatlar'},
          },
        ],
      ),
    );

    final result = await repository.fetchListingsResult();
    final item = result.data.single;

    expect(result.isFallback, isFalse);
    expect(item.id, 'listing-1');
    expect(item.categoryId, 'category-1');
    expect(item.category, 'Xizmatlar');
    expect(item.description, 'Ekran va batareya almashtirish.');
    expect(item.phone, '+998901112233');
    expect(item.status, ListingStatus.active);
    expect(item.viewsCount, 12);
  });
}

class _FakeListingsRemoteDataSource implements ListingsRemoteDataSource {
  _FakeListingsRemoteDataSource({
    this.listingRows = const <Map<String, dynamic>>[],
  });

  final List<Map<String, dynamic>> listingRows;

  @override
  Future<List<Map<String, dynamic>>> fetchListingsRows() async => listingRows;

  @override
  Future<List<Map<String, dynamic>>> fetchCategoryRows() async {
    return const <Map<String, dynamic>>[];
  }

  @override
  Future<Map<String, dynamic>?> fetchListingRow(String id) async {
    return listingRows.where((row) => row['id'] == id).firstOrNull;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMyListingRows(String userId) async {
    return listingRows.where((row) => row['user_id'] == userId).toList();
  }

  @override
  Future<void> insertListing(Map<String, dynamic> payload) async {}
}
