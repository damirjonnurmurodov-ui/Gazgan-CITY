import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/data/json_readers.dart';

class NewsItem {
  const NewsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.icon,
    required this.imageColor,
    this.isFeatured = false,
    this.isOfficial = false,
  });

  final String id;
  final String title;
  final String description;
  final String date;
  final String category;
  final IconData icon;
  final Color imageColor;
  final bool isFeatured;
  final bool isOfficial;

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    final category = readString(json, const <String>[
      'category',
      'category_name',
      'type',
    ], fallback: 'Yangiliklar');

    return NewsItem(
      id: readString(json, const <String>['id', 'uuid']),
      title: readString(json, const <String>[
        'title',
        'name',
      ], fallback: 'Yangilik'),
      description: readString(json, const <String>[
        'description',
        'content',
        'body',
        'summary',
      ], fallback: 'G\'ozg\'on shahri bo\'yicha yangilik.'),
      date: readString(json, const <String>[
        'date',
        'published_at',
        'created_at',
      ], fallback: 'Bugun'),
      category: category,
      icon: _iconForCategory(category),
      imageColor: readColor(json, const <String>[
        'color',
        'image_color',
        'accent_color',
      ], fallback: _colorForCategory(category)),
      isFeatured: readBool(json, const <String>['is_featured', 'featured']),
      isOfficial: readBool(json, const <String>[
        'is_official',
        'official',
      ], fallback: category.toLowerCase().contains('rasmiy')),
    );
  }
}

IconData _iconForCategory(String category) {
  final normalized = category.toLowerCase();
  if (normalized.contains('sayyor') || normalized.contains('qabul')) {
    return LucideIcons.users;
  }
  if (normalized.contains('tadbir')) return LucideIcons.music;
  if (normalized.contains('ish')) return LucideIcons.briefcase;
  if (normalized.contains('transport')) return LucideIcons.bus;
  if (normalized.contains('tibb')) return LucideIcons.heartPulse;
  if (normalized.contains('ogohlantirish') || normalized.contains('muhim')) {
    return LucideIcons.alertTriangle;
  }
  if (normalized.contains('rasmiy')) return LucideIcons.fileText;
  return LucideIcons.newspaper;
}

Color _colorForCategory(String category) {
  final normalized = category.toLowerCase();
  if (normalized.contains('sayyor')) return const Color(0xFF17B26A);
  if (normalized.contains('tadbir')) return const Color(0xFFFF7043);
  if (normalized.contains('ish')) return const Color(0xFF5C6BC0);
  if (normalized.contains('transport')) return const Color(0xFF42A5F5);
  if (normalized.contains('muhim')) return const Color(0xFFF04438);
  return const Color(0xFF1368E8);
}
