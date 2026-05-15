import 'package:flutter/material.dart';

import '../../../core/services/phone_launcher_service.dart';

Future<void> callWithFeedback(
  BuildContext context,
  PhoneLauncherService phoneLauncher,
  String phone,
) async {
  final success = await phoneLauncher.call(phone);
  if (success || !context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Qo\'ng\'iroq qilish imkoni bo\'lmadi')),
  );
}
