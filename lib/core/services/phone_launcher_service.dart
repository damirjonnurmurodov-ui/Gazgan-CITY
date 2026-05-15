import 'package:url_launcher/url_launcher.dart';

class PhoneLauncherService {
  const PhoneLauncherService();

  Future<bool> call(String phone) async {
    final normalized = normalizePhoneNumber(phone);
    if (normalized.isEmpty) return false;

    try {
      return launchUrl(Uri(scheme: 'tel', path: normalized));
    } catch (_) {
      return false;
    }
  }
}

String normalizePhoneNumber(String phone) {
  return phone.replaceAll(RegExp(r'[\s\-\(\)]'), '').trim();
}
