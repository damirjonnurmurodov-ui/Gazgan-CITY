import '../../../core/data/json_readers.dart';

class UsefulContact {
  const UsefulContact({
    required this.id,
    required this.title,
    required this.phone,
    required this.category,
    this.description = '',
    this.isActive = true,
  });

  final String id;
  final String title;
  final String phone;
  final String category;
  final String description;
  final bool isActive;

  factory UsefulContact.fromJson(Map<String, dynamic> json) {
    return UsefulContact(
      id: readString(json, const <String>['id', 'uuid']),
      title: readString(json, const <String>[
        'title',
        'name',
      ], fallback: 'Foydali kontakt'),
      phone: readString(json, const <String>['phone']),
      category: readString(json, const <String>[
        'category',
      ], fallback: 'Foydali kontakt'),
      description: readString(json, const <String>['description']),
      isActive: readBool(json, const <String>['is_active'], fallback: true),
    );
  }
}
