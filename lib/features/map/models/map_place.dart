import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/data/json_readers.dart';

class MapPlace {
  const MapPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.icon,
    required this.x,
    required this.y,
    this.phone = '',
    this.description = '',
    this.imageUrl,
  });

  final String id;
  final String name;
  final String category;
  final String address;
  final String phone;
  final String description;
  final String? imageUrl;
  final IconData icon;
  final double x;
  final double y;

  factory MapPlace.fromJson(
    Map<String, dynamic> json, {
    required double fallbackX,
    required double fallbackY,
  }) {
    final category = readString(json, const <String>[
      'category',
      'category_name',
      'type',
    ], fallback: 'Shahar obyekti');

    return MapPlace(
      id: readString(json, const <String>['id', 'uuid']),
      name: readString(json, const <String>[
        'name',
        'title',
      ], fallback: 'Shahar obyekti'),
      category: category,
      address: readString(json, const <String>[
        'address',
        'location',
      ], fallback: 'G\'ozg\'on shahri'),
      phone: readString(json, const <String>['phone']),
      description: readString(json, const <String>['description']),
      imageUrl: readString(json, const <String>['image_url', 'image']),
      icon: _iconForCategory(category),
      x: readDouble(json, const <String>[
        'x',
        'map_x',
      ], fallback: fallbackX).clamp(0.08, 0.92).toDouble(),
      y: readDouble(json, const <String>[
        'y',
        'map_y',
      ], fallback: fallbackY).clamp(0.10, 0.90).toDouble(),
    );
  }
}

IconData _iconForCategory(String category) {
  final normalized = category.toLowerCase();
  if (normalized.contains('davlat') || normalized.contains('hokim')) {
    return LucideIcons.building2;
  }
  if (normalized.contains('iib') || normalized.contains('polits')) {
    return LucideIcons.shield;
  }
  if (normalized.contains('tibb') || normalized.contains('kasal')) {
    return LucideIcons.heartPulse;
  }
  if (normalized.contains('ta\'lim') || normalized.contains('maktab')) {
    return LucideIcons.graduationCap;
  }
  if (normalized.contains('savdo') || normalized.contains('bozor')) {
    return LucideIcons.shoppingBag;
  }
  if (normalized.contains('dam') || normalized.contains('park')) {
    return LucideIcons.trees;
  }
  if (normalized.contains('taxi') || normalized.contains('transport')) {
    return LucideIcons.car;
  }
  return LucideIcons.mapPin;
}
