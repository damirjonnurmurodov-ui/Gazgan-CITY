import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/core/storage/image_upload_repository.dart';

void main() {
  test('avatar upload returns graceful failure when storage fails', () async {
    final repository = ImageUploadRepository(
      dataSource: _ThrowingImageUploadDataSource(),
    );

    final result = await repository.uploadProfileAvatar(
      userId: 'user-1',
      file: const LocalImageFile(path: 'C:/tmp/avatar.jpg'),
    );

    expect(result.isSuccess, isFalse);
    expect(result.publicUrl, isNull);
    expect(result.message, 'Rasm yuklanmadi. Profilni rasmsiz saqlash mumkin.');
  });

  test('listing upload returns public url and owner scoped path', () async {
    final dataSource = _RecordingImageUploadDataSource();
    final repository = ImageUploadRepository(dataSource: dataSource);

    final result = await repository.uploadListingImage(
      userId: 'user-1',
      file: const LocalImageFile(path: 'C:/tmp/listing.jpg'),
    );

    expect(result.isSuccess, isTrue);
    expect(result.publicUrl, 'https://example.com/listing.jpg');
    expect(dataSource.lastBucket, 'listing-images');
    expect(dataSource.lastPath, startsWith('user-1/listing_'));
    expect(dataSource.lastPath, endsWith('.jpg'));
  });
}

class _ThrowingImageUploadDataSource implements ImageUploadDataSource {
  @override
  Future<void> uploadFile({
    required String bucket,
    required String path,
    required String filePath,
    required bool upsert,
  }) async {
    throw Exception('bucket missing');
  }

  @override
  String getPublicUrl({required String bucket, required String path}) {
    return 'https://example.com/unused.jpg';
  }
}

class _RecordingImageUploadDataSource implements ImageUploadDataSource {
  String? lastBucket;
  String? lastPath;

  @override
  Future<void> uploadFile({
    required String bucket,
    required String path,
    required String filePath,
    required bool upsert,
  }) async {
    lastBucket = bucket;
    lastPath = path;
  }

  @override
  String getPublicUrl({required String bucket, required String path}) {
    return 'https://example.com/listing.jpg';
  }
}
