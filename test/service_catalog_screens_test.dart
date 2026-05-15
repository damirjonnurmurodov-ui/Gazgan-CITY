import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/core/data/repository_result.dart';
import 'package:gazgan_city/core/services/phone_launcher_service.dart';
import 'package:gazgan_city/features/map/data/map_places_repository.dart';
import 'package:gazgan_city/features/map/map_place_detail_screen.dart';
import 'package:gazgan_city/features/map/models/map_place.dart';
import 'package:gazgan_city/features/services/data/taxi_services_repository.dart';
import 'package:gazgan_city/features/services/models/taxi_service.dart';
import 'package:gazgan_city/features/services/taxi_services_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('service catalog live empty result shows empty state', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      TaxiServicesScreen(
        repository: _TaxiStateRepository(
          result: const RepositoryResult.live(<TaxiService>[]),
        ),
        phoneLauncher: const _PhoneLauncherResult(true),
      ),
    );

    expect(find.text('Taxi xizmatlari topilmadi'), findsOneWidget);
    expect(find.text('Demo ma\'lumot'), findsNothing);
  });

  testWidgets('service catalog fallback result shows error and retry action', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      TaxiServicesScreen(
        repository: _TaxiStateRepository(
          result: const RepositoryResult.fallback(
            <TaxiService>[],
            message: 'Ma\'lumot vaqtincha mavjud emas.',
          ),
        ),
        phoneLauncher: const _PhoneLauncherResult(true),
      ),
    );

    expect(find.text('Ma\'lumot vaqtincha mavjud emas.'), findsOneWidget);
    expect(find.text('Qayta urinish'), findsOneWidget);
  });

  testWidgets('map place detail renders place fields', (tester) async {
    await _pumpScreen(
      tester,
      MapPlaceDetailScreen(
        placeId: 'place-1',
        initialPlace: _place,
        repository: _MapDetailRepository(_place),
        phoneLauncher: const _PhoneLauncherResult(true),
      ),
    );

    expect(find.text('Markaziy poliklinika'), findsOneWidget);
    expect(find.text('Tibbiyot'), findsOneWidget);
    expect(find.text('Bunyodkor ko\'chasi, 42-uy'), findsOneWidget);
    expect(find.text('+998901002030'), findsOneWidget);
    expect(find.text('Aholi uchun birlamchi tibbiy xizmat.'), findsOneWidget);
  });

  testWidgets('call action failure shows soft message', (tester) async {
    await _pumpScreen(
      tester,
      TaxiServicesScreen(
        repository: _TaxiStateRepository(
          result: const RepositoryResult.live(<TaxiService>[
            TaxiService(
              id: 'taxi-1',
              name: 'Gazgan Taxi',
              phone: '+998901112233',
              description: 'Shahar bo\'ylab taxi.',
            ),
          ]),
        ),
        phoneLauncher: const _PhoneLauncherResult(false),
      ),
    );

    await tester.tap(find.text('Qo\'ng\'iroq'));
    await tester.pump();

    expect(find.text('Qo\'ng\'iroq qilish imkoni bo\'lmadi'), findsOneWidget);
  });
}

Future<void> _pumpScreen(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: child));
  await tester.pump();
}

const _place = MapPlace(
  id: 'place-1',
  name: 'Markaziy poliklinika',
  category: 'Tibbiyot',
  address: 'Bunyodkor ko\'chasi, 42-uy',
  phone: '+998901002030',
  description: 'Aholi uchun birlamchi tibbiy xizmat.',
  icon: LucideIcons.heartPulse,
  x: 0.2,
  y: 0.5,
);

class _TaxiStateRepository extends TaxiServicesRepository {
  _TaxiStateRepository({required this.result});

  final RepositoryResult<List<TaxiService>> result;

  @override
  Future<RepositoryResult<List<TaxiService>>> fetchServicesResult() async {
    return result;
  }
}

class _MapDetailRepository extends MapPlacesRepository {
  _MapDetailRepository(this.place);

  final MapPlace place;

  @override
  Future<RepositoryResult<MapPlace?>> fetchPlaceDetailResult(String id) async {
    return RepositoryResult.live(place);
  }
}

class _PhoneLauncherResult extends PhoneLauncherService {
  const _PhoneLauncherResult(this.result);

  final bool result;

  @override
  Future<bool> call(String phone) async => result;
}
