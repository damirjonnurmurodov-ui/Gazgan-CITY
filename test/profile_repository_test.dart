import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/features/profile/data/profile_repository.dart';
import 'package:gazgan_city/features/profile/models/user_profile.dart';

void main() {
  test('user profile maps row values and address fallback', () {
    final profile = UserProfile.fromJson(<String, dynamic>{
      'id': 'user-1',
      'full_name': 'Ali Valiyev',
      'phone': '+998 90 111 22 33',
      'mahalla': 'Marmarobod MFY',
      'avatar_url': 'https://example.com/avatar.jpg',
    });

    expect(profile.id, 'user-1');
    expect(profile.fullName, 'Ali Valiyev');
    expect(profile.phone, '+998 90 111 22 33');
    expect(profile.address, 'Marmarobod MFY');
    expect(profile.avatarUrl, 'https://example.com/avatar.jpg');
  });

  test('profile repository upserts profile payload', () async {
    final dataSource = _FakeProfileDataSource();
    final repository = ProfileRepository(dataSource: dataSource);

    final saved = await repository.upsertProfile(
      const UserProfile(
        id: 'user-1',
        fullName: 'Ali Valiyev',
        phone: '+998 90 111 22 33',
        address: 'Marmarobod MFY',
        avatarUrl: 'https://example.com/avatar.jpg',
      ),
    );

    expect(saved.fullName, 'Ali Valiyev');
    expect(dataSource.lastPayload, <String, dynamic>{
      'id': 'user-1',
      'full_name': 'Ali Valiyev',
      'phone': '+998 90 111 22 33',
      'address': 'Marmarobod MFY',
      'avatar_url': 'https://example.com/avatar.jpg',
    });
  });
}

class _FakeProfileDataSource implements ProfileDataSource {
  Map<String, dynamic>? lastPayload;

  @override
  Future<Map<String, dynamic>?> fetchProfileRow(String userId) async {
    return <String, dynamic>{
      'id': userId,
      'full_name': 'Ali Valiyev',
    };
  }

  @override
  Future<Map<String, dynamic>> upsertProfileRow(
    Map<String, dynamic> payload,
  ) async {
    lastPayload = payload;
    return payload;
  }
}
