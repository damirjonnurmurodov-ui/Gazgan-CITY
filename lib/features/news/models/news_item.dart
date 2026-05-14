import 'package:flutter/material.dart';

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
}
