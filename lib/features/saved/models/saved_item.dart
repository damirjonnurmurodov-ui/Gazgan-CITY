import '../../listings/models/listing_item.dart';
import '../../map/models/map_place.dart';
import '../../news/models/news_item.dart';

class SavedItem {
  const SavedItem({
    required this.id,
    required this.userId,
    required this.type,
    required this.itemId,
    required this.createdAt,
    this.listing,
    this.news,
    this.mapPlace,
  });

  final String id;
  final String userId;
  final SavedItemType type;
  final String itemId;
  final String createdAt;
  final ListingItem? listing;
  final NewsItem? news;
  final MapPlace? mapPlace;

  String get title {
    switch (type) {
      case SavedItemType.listing:
        return listing?.title ?? 'Saqlangan e\'lon';
      case SavedItemType.news:
        return news?.title ?? 'Saqlangan yangilik';
      case SavedItemType.mapPlace:
        return mapPlace?.name ?? 'Saqlangan joy';
    }
  }

  String get subtitle {
    switch (type) {
      case SavedItemType.listing:
        return listing?.location ?? 'E\'lon';
      case SavedItemType.news:
        return news?.category ?? 'Yangilik';
      case SavedItemType.mapPlace:
        return mapPlace?.address ?? 'Xarita obyekti';
    }
  }

  String get typeLabel {
    switch (type) {
      case SavedItemType.listing:
        return 'E\'lon';
      case SavedItemType.news:
        return 'Yangilik';
      case SavedItemType.mapPlace:
        return 'Joy';
    }
  }
}

enum SavedItemType {
  listing('listing'),
  news('news'),
  mapPlace('map_place');

  const SavedItemType(this.value);

  final String value;

  static SavedItemType fromValue(String value) {
    switch (value.trim()) {
      case 'news':
        return SavedItemType.news;
      case 'map_place':
        return SavedItemType.mapPlace;
      case 'listing':
      default:
        return SavedItemType.listing;
    }
  }
}
