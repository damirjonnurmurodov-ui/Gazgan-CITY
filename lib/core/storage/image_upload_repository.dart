import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart'
    show FileOptions, SupabaseClient;

import '../supabase/supabase_client.dart';

class LocalImageFile {
  const LocalImageFile({required this.path});

  final String path;
}

class ImageUploadResult {
  const ImageUploadResult._({this.publicUrl, this.message});

  final String? publicUrl;
  final String? message;

  bool get isSuccess => publicUrl != null;

  factory ImageUploadResult.success(String publicUrl) {
    return ImageUploadResult._(publicUrl: publicUrl);
  }

  factory ImageUploadResult.failure(String message) {
    return ImageUploadResult._(message: message);
  }
}

abstract class ImageUploadDataSource {
  Future<void> uploadFile({
    required String bucket,
    required String path,
    required String filePath,
    required bool upsert,
  });

  String getPublicUrl({required String bucket, required String path});
}

class SupabaseImageUploadDataSource implements ImageUploadDataSource {
  SupabaseImageUploadDataSource({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;
  SupabaseClient get _supabase => _client ?? supabaseClient;

  @override
  Future<void> uploadFile({
    required String bucket,
    required String path,
    required String filePath,
    required bool upsert,
  }) async {
    await _supabase.storage.from(bucket).upload(
          path,
          File(filePath),
          fileOptions: FileOptions(
            cacheControl: '3600',
            upsert: upsert,
          ),
        );
  }

  @override
  String getPublicUrl({required String bucket, required String path}) {
    return _supabase.storage.from(bucket).getPublicUrl(path);
  }
}

class ImageUploadRepository {
  ImageUploadRepository({
    SupabaseClient? client,
    ImageUploadDataSource? dataSource,
  }) : _dataSource =
           dataSource ?? SupabaseImageUploadDataSource(client: client);

  final ImageUploadDataSource _dataSource;

  Future<ImageUploadResult> uploadProfileAvatar({
    required String userId,
    required LocalImageFile file,
  }) async {
    return _uploadPublicImage(
      bucket: 'profile-avatars',
      path: '${_safeUserPath(userId)}/avatar_${_timestamp()}${_extension(file)}',
      file: file,
      upsert: false,
      failureMessage: 'Rasm yuklanmadi. Profilni rasmsiz saqlash mumkin.',
    );
  }

  Future<ImageUploadResult> uploadListingImage({
    required String userId,
    required LocalImageFile file,
  }) async {
    return _uploadPublicImage(
      bucket: 'listing-images',
      path:
          '${_safeUserPath(userId)}/listing_${_timestamp()}${_extension(file)}',
      file: file,
      upsert: false,
      failureMessage: 'Rasm yuklanmadi. E\'lonni rasmsiz yuborish mumkin.',
    );
  }

  Future<ImageUploadResult> _uploadPublicImage({
    required String bucket,
    required String path,
    required LocalImageFile file,
    required bool upsert,
    required String failureMessage,
  }) async {
    try {
      await _dataSource.uploadFile(
        bucket: bucket,
        path: path,
        filePath: file.path,
        upsert: upsert,
      );
      return ImageUploadResult.success(
        _dataSource.getPublicUrl(bucket: bucket, path: path),
      );
    } catch (_) {
      return ImageUploadResult.failure(failureMessage);
    }
  }
}

String _safeUserPath(String userId) {
  return userId.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
}

String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

String _extension(LocalImageFile file) {
  final path = file.path.toLowerCase();
  final dotIndex = path.lastIndexOf('.');
  if (dotIndex == -1 || dotIndex == path.length - 1) return '.jpg';
  final extension = path.substring(dotIndex);
  if (extension == '.jpeg') return '.jpg';
  if (extension == '.png' || extension == '.webp' || extension == '.jpg') {
    return extension;
  }
  return '.jpg';
}
