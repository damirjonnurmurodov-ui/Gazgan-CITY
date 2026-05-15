import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/core/data/repository_result.dart';
import 'package:gazgan_city/features/home/data/home_repository.dart';
import 'package:gazgan_city/features/home/home_screen.dart';
import 'package:gazgan_city/features/home/models/home_content.dart';
import 'package:gazgan_city/features/listings/data/listings_repository.dart';
import 'package:gazgan_city/features/listings/listings_screen.dart';
import 'package:gazgan_city/features/listings/models/listing_item.dart';
import 'package:gazgan_city/features/map/data/map_places_repository.dart';
import 'package:gazgan_city/features/map/map_screen.dart';
import 'package:gazgan_city/features/map/models/map_place.dart';
import 'package:gazgan_city/features/news/data/news_repository.dart';
import 'package:gazgan_city/features/news/models/news_item.dart';
import 'package:gazgan_city/features/news/news_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('home screen renders fallback content while repository fails', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      HomeScreen(repository: _ThrowingHomeRepository()),
    );

    expect(
      find.text("Hokimiyat tomonidan qo'llab-quvvatlanadi"),
      findsOneWidget,
    );
    expect(find.text('Bugun Marmarobod MFYda sayyor qabul'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -420));
    await tester.pump();

    expect(find.text('Hokim sayyor qabuli'), findsOneWidget);
  });

  testWidgets('news screen renders fallback content while repository fails', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      NewsScreen(repository: _ThrowingNewsRepository()),
    );

    expect(find.text('Yangiliklar'), findsWidgets);
    expect(
      find.text('Shahar hokimiyati tomonidan yangi qaror qabul qilindi'),
      findsWidgets,
    );
  });

  testWidgets(
    'listings screen renders fallback content while repository fails',
    (tester) async {
      await _pumpScreen(
        tester,
        ListingsScreen(repository: _ThrowingListingsRepository()),
      );

      expect(find.text('E\'lonlar'), findsOneWidget);
      expect(find.text('3 xonali kvartira ijaraga beriladi'), findsOneWidget);
    },
  );

  testWidgets('map screen renders fallback content while repository fails', (
    tester,
  ) async {
    await _pumpScreen(tester, MapScreen(repository: _ThrowingMapRepository()));

    expect(find.text('Xarita'), findsOneWidget);
    expect(find.text('Hokimiyat'), findsWidgets);
  });
}

Future<void> _pumpScreen(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
  await tester.pump();
}

class _ThrowingHomeRepository extends HomeRepository {
  @override
  Future<RepositoryResult<HomeContent>> fetchHomeContentResult() async {
    return RepositoryResult.fallback(
      HomeContent(
        announcement: HomeRepository.fallbackAnnouncement,
        reception: HomeRepository.fallbackReception,
        news: NewsRepository.fallbackNews.take(3).toList(),
        announcementCount: 3,
        receptionCount: 1,
      ),
      message: 'Bosh sahifa vaqtincha lokal ma\'lumotlardan ko\'rsatildi.',
    );
  }
}

class _ThrowingNewsRepository extends NewsRepository {
  @override
  Future<RepositoryResult<List<NewsItem>>> fetchNewsResult() async {
    return const RepositoryResult.fallback(
      NewsRepository.fallbackNews,
      message: 'Yangiliklar vaqtincha lokal ma\'lumotlardan ko\'rsatildi.',
    );
  }
}

class _ThrowingListingsRepository extends ListingsRepository {
  @override
  Future<RepositoryResult<List<ListingItem>>> fetchListingsResult() async {
    return const RepositoryResult.fallback(
      ListingsRepository.fallbackListings,
      message: 'E\'lonlar vaqtincha lokal ma\'lumotlardan ko\'rsatildi.',
    );
  }
}

class _ThrowingMapRepository extends MapPlacesRepository {
  @override
  Future<RepositoryResult<List<MapPlace>>> fetchPlacesResult() async {
    return const RepositoryResult.fallback(
      MapPlacesRepository.fallbackPlaces,
      message: 'Xarita vaqtincha lokal obyektlardan ko\'rsatildi.',
    );
  }
}
