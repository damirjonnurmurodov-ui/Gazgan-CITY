import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthUser {
  const AuthUser({required this.id, this.email, this.phone, this.fullName});

  final String id;
  final String? email;
  final String? phone;
  final String? fullName;

  String get displayName {
    final name = fullName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return email ?? phone ?? 'Gazgan City foydalanuvchisi';
  }

  String get contactLabel => email ?? phone ?? 'Kontakt kiritilmagan';

  factory AuthUser.fromSupabase(supabase.User user) {
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    final fullName =
        metadata['full_name']?.toString() ?? metadata['name']?.toString();

    return AuthUser(
      id: user.id,
      email: user.email,
      phone: user.phone,
      fullName: fullName,
    );
  }
}
