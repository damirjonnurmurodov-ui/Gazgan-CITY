import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/data/json_readers.dart';

class ListingItem {
  const ListingItem({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.date,
    required this.category,
    required this.icon,
    required this.imageColor,
    this.categoryId,
    this.userId,
    this.description = '',
    this.phone = '',
    this.imageUrl,
    this.status = ListingStatus.active,
    this.viewsCount = 0,
    this.isFeatured = false,
    this.isOfficial = false,
  });

  final String id;
  final String? categoryId;
  final String? userId;
  final String title;
  final String description;
  final String price;
  final String location;
  final String phone;
  final String date;
  final String category;
  final String? imageUrl;
  final IconData icon;
  final Color imageColor;
  final ListingStatus status;
  final int viewsCount;
  final bool isFeatured;
  final bool isOfficial;

  String get statusLabel {
    switch (status) {
      case ListingStatus.pending:
        return 'Kutilmoqda';
      case ListingStatus.active:
        return 'Faol';
      case ListingStatus.rejected:
        return 'Rad etilgan';
    }
  }

  bool matchesQuery(String query) {
    final normalized = query.toLowerCase().trim();
    if (normalized.isEmpty) return true;

    final searchableText = <String>[
      title,
      description,
      price,
      location,
      phone,
      category,
    ].join(' ').toLowerCase();

    return searchableText.contains(normalized);
  }

  factory ListingItem.fromJson(Map<String, dynamic> json) {
    final category = _readCategory(json);

    return ListingItem(
      id: readString(json, const <String>['id', 'uuid']),
      categoryId: readString(json, const <String>['category_id']),
      userId: readString(json, const <String>['user_id']),
      title: readString(json, const <String>[
        'title',
        'name',
      ], fallback: 'Mahalliy e\'lon'),
      description: readString(json, const <String>[
        'description',
        'content',
        'body',
      ]),
      price: readString(json, const <String>[
        'price',
        'salary',
        'cost',
      ], fallback: 'Kelishiladi'),
      location: readString(json, const <String>[
        'location',
        'address',
      ], fallback: 'G\'ozg\'on shahri'),
      phone: readString(json, const <String>['phone', 'contact_phone']),
      date: _formatDate(
        readString(json, const <String>[
          'date',
          'created_at',
          'published_at',
        ], fallback: 'Bugun'),
      ),
      category: category,
      imageUrl: readString(json, const <String>['image_url', 'image']),
      icon: _iconForCategory(category),
      imageColor: readColor(json, const <String>[
        'color',
        'image_color',
        'accent_color',
      ], fallback: _colorForCategory(category)),
      status: _statusFromJson(readString(json, const <String>['status'])),
      viewsCount: _readInt(json, const <String>['views_count', 'views']),
      isFeatured: readBool(json, const <String>[
        'is_featured',
        'featured',
        'is_premium',
      ]),
      isOfficial: readBool(json, const <String>[
        'is_official',
        'official',
        'verified',
      ]),
    );
  }
}

class ListingCategory {
  const ListingCategory({required this.name, this.id});

  final String? id;
  final String name;

  factory ListingCategory.fromJson(Map<String, dynamic> json) {
    return ListingCategory(
      id: readString(json, const <String>['id']),
      name: readString(json, const <String>['name'], fallback: 'Boshqa'),
    );
  }
}

class CreateListingInput {
  const CreateListingInput({
    required this.userId,
    required this.title,
    required this.description,
    required this.phone,
    this.categoryId,
    this.price,
    this.location,
  });

  final String userId;
  final String? categoryId;
  final String title;
  final String description;
  final String? price;
  final String? location;
  final String phone;

  Map<String, dynamic> toInsertMap() {
    return <String, dynamic>{
      'user_id': userId,
      if (categoryId != null && categoryId!.trim().isNotEmpty)
        'category_id': categoryId!.trim(),
      'title': title.trim(),
      'description': description.trim(),
      'price': _nullableText(price),
      'location': _nullableText(location),
      'phone': phone.trim(),
      'status': 'pending',
    };
  }
}

enum ListingStatus { pending, active, rejected }

String? _nullableText(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

String _readCategory(Map<String, dynamic> json) {
  final relation = json['listing_categories'];
  if (relation is Map) {
    final category = readString(
      Map<String, dynamic>.from(relation),
      const <String>['name'],
    );
    if (category.isNotEmpty) return category;
  }

  if (relation is List && relation.isNotEmpty && relation.first is Map) {
    final category = readString(
      Map<String, dynamic>.from(relation.first as Map),
      const <String>['name'],
    );
    if (category.isNotEmpty) return category;
  }

  return readString(json, const <String>[
    'category',
    'category_name',
    'type',
  ], fallback: 'Mahalliy e\'lon');
}

ListingStatus _statusFromJson(String raw) {
  switch (raw.toLowerCase().trim()) {
    case 'pending':
      return ListingStatus.pending;
    case 'rejected':
      return ListingStatus.rejected;
    case 'active':
    default:
      return ListingStatus.active;
  }
}

int _readInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
  }
  return 0;
}

String _formatDate(String raw) {
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return raw;

  final day = parsed.day.toString().padLeft(2, '0');
  final month = parsed.month.toString().padLeft(2, '0');
  return '$day.$month.${parsed.year}';
}

IconData _iconForCategory(String category) {
  final normalized = category.toLowerCase();
  if (normalized.contains('uy') || normalized.contains('mulk')) {
    return LucideIcons.building2;
  }
  if (normalized.contains('transport') || normalized.contains('taxi')) {
    return LucideIcons.car;
  }
  if (normalized.contains('ish')) return LucideIcons.briefcase;
  if (normalized.contains('xizmat') || normalized.contains('usta')) {
    return LucideIcons.wrench;
  }
  if (normalized.contains('telefon') || normalized.contains('elektron')) {
    return LucideIcons.smartphone;
  }
  if (normalized.contains('savdo')) return LucideIcons.store;
  return LucideIcons.megaphone;
}

Color _colorForCategory(String category) {
  final normalized = category.toLowerCase();
  if (normalized.contains('transport') || normalized.contains('taxi')) {
    return const Color(0xFF42A5F5);
  }
  if (normalized.contains('ish')) return const Color(0xFF8D6E63);
  if (normalized.contains('xizmat') || normalized.contains('usta')) {
    return const Color(0xFF26A69A);
  }
  if (normalized.contains('savdo')) return const Color(0xFFFF7043);
  return const Color(0xFF4A90D9);
}
