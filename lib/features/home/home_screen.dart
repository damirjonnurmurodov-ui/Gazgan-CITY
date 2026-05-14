import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/widgets/section_header.dart';
import 'widgets/compact_news_card.dart';
import 'widgets/home_header.dart';
import 'widgets/local_service_card.dart';
import 'widgets/official_announcement_card.dart';
import 'widgets/quick_action_grid.dart';
import 'widgets/reception_card.dart';
import 'widgets/useful_section_card.dart';
import 'widgets/weather_status_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<QuickActionItem> _quickActions = <QuickActionItem>[
    QuickActionItem(icon: LucideIcons.users, label: 'Sayyor qabullar'),
    QuickActionItem(icon: LucideIcons.newspaper, label: 'Yangiliklar'),
    QuickActionItem(icon: LucideIcons.car, label: 'Taxi'),
    QuickActionItem(icon: LucideIcons.phone, label: 'Ishonch raqamlari'),
    QuickActionItem(icon: LucideIcons.shoppingCart, label: 'Gazgan OLX'),
    QuickActionItem(icon: LucideIcons.mapPin, label: "G'ozg'on xaritasi"),
    QuickActionItem(icon: LucideIcons.grid, label: 'Barcha toifalar'),
    QuickActionItem(icon: LucideIcons.wrench, label: 'Ustalar'),
  ];

  static const List<CompactNewsItem> _news = <CompactNewsItem>[
    CompactNewsItem(
      title: 'Marmarobod MFYda obodonlashtirish ishlari davom etmoqda',
      category: 'Obodonlashtirish',
      date: '07.05.2026',
    ),
    CompactNewsItem(
      title: "Yoshlar uchun turizm yo'nalishlari e'lon qilindi",
      category: "Ish o'rinlari",
      date: '06.05.2026',
    ),
    CompactNewsItem(
      title: "G'ozg'on shahrida turizm yo'nalishi rivojlantirilmoqda",
      category: 'Turizm',
      date: '05.05.2026',
    ),
  ];

  static const List<UsefulSectionItem> _usefulSections = <UsefulSectionItem>[
    UsefulSectionItem(icon: LucideIcons.car, label: 'Taxi'),
    UsefulSectionItem(icon: LucideIcons.building2, label: 'Korxonalar'),
    UsefulSectionItem(icon: LucideIcons.grid, label: 'Barcha toifalar'),
    UsefulSectionItem(icon: LucideIcons.briefcase, label: "Ish o'rinlari"),
  ];

  static const List<LocalServiceItem> _localServices = <LocalServiceItem>[
    LocalServiceItem(icon: LucideIcons.wrench, label: 'Ustalar'),
    LocalServiceItem(icon: LucideIcons.zap, label: 'Elektrik'),
    LocalServiceItem(icon: LucideIcons.droplets, label: 'Santexnik'),
    LocalServiceItem(icon: LucideIcons.truck, label: 'Yuk tashish'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 128),
        children: <Widget>[
          const HomeHeader(),
          const SizedBox(height: 18),
          const WeatherStatusCard(),
          const SizedBox(height: 16),
          const OfficialAnnouncementCard(),
          const SizedBox(height: 16),
          const QuickActionGrid(items: _quickActions),
          const SizedBox(height: 18),
          const SectionHeader(
            title: 'Bugungi sayyor qabullar',
            actionLabel: "Barchasini ko'rish",
          ),
          const SizedBox(height: 10),
          const ReceptionCard(),
          const SizedBox(height: 18),
          const SectionHeader(
            title: "So'nggi yangiliklar",
            actionLabel: "Barchasini ko'rish",
          ),
          const SizedBox(height: 10),
          _NewsRow(items: _news),
          const SizedBox(height: 18),
          const SectionHeader(title: "Foydali bo'limlar"),
          const SizedBox(height: 10),
          UsefulSectionGrid(items: _usefulSections),
          const SizedBox(height: 18),
          const SectionHeader(
            title: 'Mahalliy xizmatlar',
            actionLabel: "Barchasini ko'rish",
          ),
          const SizedBox(height: 10),
          LocalServiceGrid(items: _localServices),
        ],
      ),
    );
  }
}

class _NewsRow extends StatelessWidget {
  const _NewsRow({required this.items});

  final List<CompactNewsItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 156,
            child: CompactNewsCard(item: items[index]),
          );
        },
      ),
    );
  }
}
