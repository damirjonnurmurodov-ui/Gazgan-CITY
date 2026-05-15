import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/services/phone_launcher_service.dart';
import 'data/taxi_services_repository.dart';
import 'models/taxi_service.dart';
import 'widgets/service_call_feedback.dart';
import 'widgets/service_catalog_scaffold.dart';
import 'widgets/service_info_card.dart';

class TaxiServicesScreen extends StatelessWidget {
  const TaxiServicesScreen({super.key, this.repository, this.phoneLauncher});

  final TaxiServicesRepository? repository;
  final PhoneLauncherService? phoneLauncher;

  @override
  Widget build(BuildContext context) {
    final servicesRepository = repository ?? TaxiServicesRepository();
    final launcher = phoneLauncher ?? const PhoneLauncherService();

    return ServiceCatalogScaffold<TaxiService>(
      title: 'Taxi xizmatlari',
      subtitle: 'G\'ozg\'on shahri bo\'ylab faol taxi xizmatlari',
      loadingTitle: 'Taxi xizmatlari yuklanmoqda',
      loadingMessage: 'Faol taxi xizmatlari ro\'yxati tayyorlanmoqda.',
      emptyTitle: 'Taxi xizmatlari topilmadi',
      emptyMessage: 'Hozircha faol taxi xizmatlari mavjud emas.',
      loadItems: servicesRepository.fetchServicesResult,
      itemBuilder: (context, item) {
        return ServiceInfoCard(
          title: item.name,
          phone: item.phone,
          description: item.description,
          icon: LucideIcons.car,
          badge: 'Taxi',
          onCall: () => callWithFeedback(context, launcher, item.phone),
        );
      },
    );
  }
}
