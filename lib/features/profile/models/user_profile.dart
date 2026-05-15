import '../../../core/data/json_readers.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    this.fullName,
    this.phone,
    this.address,
    this.avatarUrl,
  });

  final String id;
  final String? fullName;
  final String? phone;
  final String? address;
  final String? avatarUrl;

  String get displayName {
    final name = fullName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return 'Gazgan City foydalanuvchisi';
  }

  String get contactLabel {
    final contact = phone?.trim();
    if (contact != null && contact.isNotEmpty) return contact;
    final addressText = address?.trim();
    if (addressText != null && addressText.isNotEmpty) return addressText;
    return 'Kontakt kiritilmagan';
  }

  UserProfile copyWith({
    String? fullName,
    String? phone,
    String? address,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toUpsertMap() {
    return <String, dynamic>{
      'id': id,
      'full_name': _nullableText(fullName),
      'phone': _nullableText(phone),
      'address': _nullableText(address),
      'avatar_url': _nullableText(avatarUrl),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: readString(json, const <String>['id', 'user_id']),
      fullName: readString(json, const <String>['full_name', 'name']),
      phone: readString(json, const <String>['phone', 'contact_phone']),
      address: readString(json, const <String>['address', 'mahalla']),
      avatarUrl: readString(json, const <String>['avatar_url', 'avatar']),
    );
  }
}

String? _nullableText(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) return null;
  return text;
}
