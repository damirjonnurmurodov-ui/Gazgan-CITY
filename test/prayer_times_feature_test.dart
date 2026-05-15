import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/core/data/repository_result.dart';
import 'package:gazgan_city/features/home/data/home_repository.dart';
import 'package:gazgan_city/features/home/home_screen.dart';
import 'package:gazgan_city/features/home/models/home_content.dart';
import 'package:gazgan_city/features/home/widgets/quick_action_card.dart';
import 'package:gazgan_city/features/news/data/news_repository.dart';
import 'package:gazgan_city/features/prayer/data/prayer_times_repository.dart';
import 'package:gazgan_city/features/prayer/models/prayer_time.dart';
import 'package:gazgan_city/features/prayer/prayer_times_screen.dart';
import 'package:gazgan_city/features/prayer/widgets/home_prayer_times_card.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('home prayer card renders default Gazgan values', (tester) async {
    await _pumpRouter(tester, home: const HomePrayerTimesCard());

    expect(find.text('Namoz vaqtlari'), findsOneWidget);
    expect(find.text("G'ozg'on"), findsOneWidget);
    expect(find.text('Bomdod'), findsOneWidget);
    expect(find.text('05:12'), findsOneWidget);
    expect(find.text('Barcha vaqtlar'), findsOneWidget);
  });

  testWidgets('home prayer card opens prayer times route', (tester) async {
    await _pumpRouter(tester, home: const HomePrayerTimesCard());

    await tester.tap(find.text('Barcha vaqtlar'));
    await tester.pumpAndSettle();

    expect(
      find.text('Joylashuvingizga qarab kunlik namoz vaqtlari'),
      findsOneWidget,
    );
  });

  testWidgets('home screen shows prayer quick action and no official badge', (
    tester,
  ) async {
    await _pumpRouter(
      tester,
      home: HomeScreen(repository: _FakeHomeRepository()),
    );

    expect(find.text("Hokimiyat tomonidan qo'llab-quvvatlanadi"), findsNothing);
    expect(
      find.widgetWithText(QuickActionCard, 'Namoz vaqtlari'),
      findsOneWidget,
    );
  });

  testWidgets('sayyor qabullar quick action opens receptions route', (
    tester,
  ) async {
    await _pumpRouter(
      tester,
      home: HomeScreen(repository: _FakeHomeRepository()),
    );

    await tester.tap(find.widgetWithText(QuickActionCard, 'Sayyor qabullar'));
    await tester.pumpAndSettle();

    expect(
      find.text('G\'ozg\'on shahri bo\'yicha rejalashtirilgan qabullar'),
      findsOneWidget,
    );
  });

  testWidgets('prayer times screen renders default location state', (
    tester,
  ) async {
    await _pumpRouter(tester, home: const PrayerTimesScreen());

    expect(find.text('Namoz vaqtlari'), findsWidgets);
    expect(find.text("G'ozg'on"), findsWidgets);
    expect(
      find.text("Default G'ozg'on vaqtlari ko'rsatilmoqda."),
      findsOneWidget,
    );
    expect(find.text('Xufton'), findsOneWidget);
  });

  testWidgets('prayer times screen renders soft error state', (tester) async {
    await _pumpRouter(
      tester,
      home: PrayerTimesScreen(repository: _ThrowingPrayerTimesRepository()),
    );

    await tester.pump();

    expect(find.text('Namoz vaqtlari vaqtincha mavjud emas'), findsOneWidget);
  });
}

Future<void> _pumpRouter(WidgetTester tester, {required Widget home}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => home),
      GoRoute(
        path: '/prayer-times',
        builder: (context, state) => const PrayerTimesScreen(),
      ),
      GoRoute(
        path: '/receptions',
        builder: (context, state) => const Scaffold(
          body: Text('G\'ozg\'on shahri bo\'yicha rejalashtirilgan qabullar'),
        ),
      ),
    ],
  );

  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pump();
}

class _FakeHomeRepository extends HomeRepository {
  @override
  Future<RepositoryResult<HomeContent>> fetchHomeContentResult() async {
    return RepositoryResult.live(
      HomeContent(
        announcement: HomeRepository.fallbackAnnouncement,
        reception: HomeRepository.fallbackReception,
        news: NewsRepository.fallbackNews.take(3).toList(),
        announcementCount: 3,
        receptionCount: 1,
      ),
    );
  }
}

class _ThrowingPrayerTimesRepository extends PrayerTimesRepository {
  @override
  Future<DailyPrayerTimes> fetchTodayPrayerTimes() async {
    throw Exception('failed');
  }
}
