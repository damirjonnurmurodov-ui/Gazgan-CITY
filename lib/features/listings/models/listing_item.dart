import 'package:flutter/material.dart';

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
    this.isFeatured = false,
    this.isOfficial = false,
  });

  final String id;
  final String title;
  final String price;
  final String location;
  final String date;
  final String category;
  final IconData icon;
  final Color imageColor;
  final bool isFeatured;
  final bool isOfficial;
}
