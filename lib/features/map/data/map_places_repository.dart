import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/repository_result.dart';
import '../../../core/supabase/supabase_client.dart';
import '../models/map_place.dart';

class MapPlacesRepository {
  MapPlacesRepository({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  Future<List<MapPlace>> fetchPlaces() async {
    final result = await fetchPlacesResult();
    return result.data;
  }

  Future<RepositoryResult<List<MapPlace>>> fetchPlacesResult() async {
    try {
      final rows = await _supabase.from('map_places').select().limit(40);
      final items = <MapPlace>[];

      for (var index = 0; index < rows.length; index++) {
        final row = rows[index];
        final fallback = _fallbackPosition(index);
        items.add(
          MapPlace.fromJson(
            row,
            fallbackX: fallback.dx,
            fallbackY: fallback.dy,
          ),
        );
      }

      if (items.isEmpty) {
        return const RepositoryResult.fallback(
          fallbackPlaces,
          message: 'Xarita obyektlari topilmadi, lokal obyektlar ko\'rsatildi.',
        );
      }

      return RepositoryResult.live(items);
    } catch (_) {
      return const RepositoryResult.fallback(
        fallbackPlaces,
        message: 'Xarita vaqtincha lokal obyektlardan ko\'rsatildi.',
      );
    }
  }

  static Offset _fallbackPosition(int index) {
    const positions = <Offset>[
      Offset(0.27, 0.30),
      Offset(0.73, 0.28),
      Offset(0.13, 0.58),
      Offset(0.50, 0.42),
      Offset(0.68, 0.68),
      Offset(0.16, 0.84),
      Offset(0.84, 0.52),
      Offset(0.42, 0.76),
    ];
    return positions[index % positions.length];
  }

  static const List<MapPlace> fallbackPlaces = <MapPlace>[
    MapPlace(
      id: '1',
      name: "Hokimiyat",
      category: "Davlat idorasi",
      address: "Mustaqillik ko'chasi, 1-uy, G'ozg'on shahri",
      icon: LucideIcons.building2,
      x: 0.27,
      y: 0.30,
    ),
    MapPlace(
      id: '2',
      name: 'IIB bo\'limi',
      category: "Davlat idorasi",
      address: "Tinchlik ko'chasi, 15-uy, G'ozg'on shahri",
      icon: LucideIcons.shield,
      x: 0.73,
      y: 0.28,
    ),
    MapPlace(
      id: '3',
      name: 'Markaziy kasalxona',
      category: 'Tibbiyot',
      address: "Bunyodkor ko'chasi, 42-uy, G'ozg'on shahri",
      icon: LucideIcons.heartPulse,
      x: 0.13,
      y: 0.58,
    ),
    MapPlace(
      id: '4',
      name: '1-sonli maktab',
      category: 'Ta\'lim',
      address: "Navoiy ko'chasi, 8-uy, G'ozg'on shahri",
      icon: LucideIcons.graduationCap,
      x: 0.50,
      y: 0.42,
    ),
    MapPlace(
      id: '5',
      name: 'Markaziy bozor',
      category: 'Savdo',
      address: "Bozor ko'chasi, 3-uy, G'ozg'on shahri",
      icon: LucideIcons.shoppingBag,
      x: 0.68,
      y: 0.68,
    ),
    MapPlace(
      id: '6',
      name: 'Istirohat bog\'i',
      category: 'Dam olish',
      address: "Tabiat ko'chasi, 10-uy, G'ozg'on shahri",
      icon: LucideIcons.trees,
      x: 0.16,
      y: 0.84,
    ),
  ];
}
