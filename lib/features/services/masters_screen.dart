import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/services/phone_launcher_service.dart';
import 'data/masters_repository.dart';
import 'models/master.dart';
import 'widgets/service_call_feedback.dart';
import 'widgets/service_catalog_scaffold.dart';
import 'widgets/service_info_card.dart';

class MastersScreen extends StatelessWidget {
  const MastersScreen({super.key, this.repository, this.phoneLauncher});

  final MastersRepository? repository;
  final PhoneLauncherService? phoneLauncher;

  @override
  Widget build(BuildContext context) {
    final mastersRepository = repository ?? MastersRepository();
    final launcher = phoneLauncher ?? const PhoneLauncherService();

    return ServiceCatalogScaffold<Master>(
      title: 'Ustalar',
      subtitle: 'Mahalliy usta va xizmat ko\'rsatuvchilar',
      loadingTitle: 'Ustalar yuklanmoqda',
      loadingMessage: 'Faol ustalar ro\'yxati tayyorlanmoqda.',
      emptyTitle: 'Ustalar topilmadi',
      emptyMessage: 'Hozircha faol ustalar ro\'yxati mavjud emas.',
      loadItems: mastersRepository.fetchMastersResult,
      itemBuilder: (context, item) {
        return ServiceInfoCard(
          title: item.name,
          subtitle: item.profession,
          phone: item.phone,
          description: item.description,
          icon: LucideIcons.wrench,
          badge: item.profession,
          onCall: () => callWithFeedback(context, launcher, item.phone),
        );
      },
    );
  }
}
