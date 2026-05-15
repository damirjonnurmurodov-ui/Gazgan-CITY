import 'package:flutter/material.dart';

String readString(
  Map<String, dynamic> json,
  List<String> keys, {
  String fallback = '',
}) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }
  return fallback;
}

bool readBool(
  Map<String, dynamic> json,
  List<String> keys, {
  bool fallback = false,
}) {
  for (final key in keys) {
    final value = json[key];
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
        return true;
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'no') {
        return false;
      }
    }
  }
  return fallback;
}

double readDouble(
  Map<String, dynamic> json,
  List<String> keys, {
  required double fallback,
}) {
  for (final key in keys) {
    final value = json[key];
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
  }
  return fallback;
}

Color readColor(
  Map<String, dynamic> json,
  List<String> keys, {
  required Color fallback,
}) {
  final raw = readString(json, keys);
  if (raw.isEmpty) return fallback;
  final cleaned = raw.replaceAll('#', '').replaceAll('0x', '').toUpperCase();
  final hex = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
  final value = int.tryParse(hex, radix: 16);
  return value == null ? fallback : Color(value);
}
