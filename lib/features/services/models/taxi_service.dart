import '../../../core/data/json_readers.dart';

class TaxiService {
  const TaxiService({
    required this.id,
    required this.name,
    required this.phone,
    this.description = '',
    this.isActive = true,
  });

  final String id;
  final String name;
  final String phone;
  final String description;
  final bool isActive;

  factory TaxiService.fromJson(Map<String, dynamic> json) {
    return TaxiService(
      id: readString(json, const <String>['id', 'uuid']),
      name: readString(json, const <String>['name'], fallback: 'Taxi xizmati'),
      phone: readString(json, const <String>['phone']),
      description: readString(json, const <String>['description']),
      isActive: readBool(json, const <String>['is_active'], fallback: true),
    );
  }
}
