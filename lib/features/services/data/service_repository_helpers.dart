const serviceFallbackMessage = 'Ma\'lumot vaqtincha mavjud emas.';

List<Map<String, dynamic>> rowsToMaps(Object? rows) {
  if (rows is! Iterable) return const <Map<String, dynamic>>[];

  return rows
      .whereType<Map>()
      .map((row) => Map<String, dynamic>.from(row))
      .toList();
}
