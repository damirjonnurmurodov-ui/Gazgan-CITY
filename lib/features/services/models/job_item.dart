import '../../../core/data/json_readers.dart';

class JobItem {
  const JobItem({
    required this.id,
    required this.title,
    this.organization = '',
    this.salary = '',
    this.phone = '',
    this.description = '',
    this.isActive = true,
  });

  final String id;
  final String title;
  final String organization;
  final String salary;
  final String phone;
  final String description;
  final bool isActive;

  factory JobItem.fromJson(Map<String, dynamic> json) {
    return JobItem(
      id: readString(json, const <String>['id', 'uuid']),
      title: readString(json, const <String>['title'], fallback: 'Ish o\'rni'),
      organization: readString(json, const <String>['organization']),
      salary: readString(json, const <String>['salary']),
      phone: readString(json, const <String>['phone']),
      description: readString(json, const <String>['description']),
      isActive: readBool(json, const <String>['is_active'], fallback: true),
    );
  }
}
