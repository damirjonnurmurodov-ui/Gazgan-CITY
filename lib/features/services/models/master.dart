import '../../../core/data/json_readers.dart';

class Master {
  const Master({
    required this.id,
    required this.name,
    required this.profession,
    required this.phone,
    this.description = '',
    this.isActive = true,
  });

  final String id;
  final String name;
  final String profession;
  final String phone;
  final String description;
  final bool isActive;

  factory Master.fromJson(Map<String, dynamic> json) {
    return Master(
      id: readString(json, const <String>['id', 'uuid']),
      name: readString(json, const <String>['name'], fallback: 'Usta'),
      profession: readString(json, const <String>[
        'profession',
      ], fallback: 'Xizmat ko\'rsatuvchi'),
      phone: readString(json, const <String>['phone']),
      description: readString(json, const <String>['description']),
      isActive: readBool(json, const <String>['is_active'], fallback: true),
    );
  }
}
