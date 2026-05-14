import 'package:flutter/material.dart';

class MapPlace {
  const MapPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.icon,
    required this.x,
    required this.y,
  });

  final String id;
  final String name;
  final String category;
  final String address;
  final IconData icon;
  final double x;
  final double y;
}
