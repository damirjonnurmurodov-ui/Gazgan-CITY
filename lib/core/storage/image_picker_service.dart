import 'package:image_picker/image_picker.dart';

import 'image_upload_repository.dart';

abstract class AppImagePicker {
  Future<LocalImageFile?> pickImage();
}

class DeviceImagePicker implements AppImagePicker {
  DeviceImagePicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<LocalImageFile?> pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
      maxWidth: 1600,
    );
    if (image == null) return null;
    return LocalImageFile(path: image.path);
  }
}
