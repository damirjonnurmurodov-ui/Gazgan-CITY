import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/services/phone_launcher_service.dart';
import 'data/useful_contacts_repository.dart';
import 'models/useful_contact.dart';
import 'widgets/service_call_feedback.dart';
import 'widgets/service_catalog_scaffold.dart';
import 'widgets/service_info_card.dart';

class UsefulContactsScreen extends StatelessWidget {
  const UsefulContactsScreen({super.key, this.repository, this.phoneLauncher});

  final UsefulContactsRepository? repository;
  final PhoneLauncherService? phoneLauncher;

  @override
  Widget build(BuildContext context) {
    final contactsRepository = repository ?? UsefulContactsRepository();
    final launcher = phoneLauncher ?? const PhoneLauncherService();

    return ServiceCatalogScaffold<UsefulContact>(
      title: 'Ishonch raqamlari',
      subtitle: 'Rasmiy va foydali shahar kontaktlari',
      loadingTitle: 'Kontaktlar yuklanmoqda',
      loadingMessage: 'Rasmiy telefon raqamlari tayyorlanmoqda.',
      emptyTitle: 'Kontaktlar topilmadi',
      emptyMessage: 'Hozircha faol ishonch raqamlari mavjud emas.',
      loadItems: contactsRepository.fetchContactsResult,
      itemBuilder: (context, item) {
        return ServiceInfoCard(
          title: item.title,
          subtitle: item.category,
          phone: item.phone,
          description: item.description,
          icon: LucideIcons.phone,
          badge: 'Rasmiy',
          official: true,
          onCall: () => callWithFeedback(context, launcher, item.phone),
        );
      },
    );
  }
}
