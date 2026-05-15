import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/data/repository_result.dart';
import '../../core/widgets/data_status_banner.dart';
import '../../core/widgets/section_header.dart';
import '../news/data/news_repository.dart';
import '../news/models/news_item.dart';
import 'data/home_repository.dart';
import 'models/home_content.dart';
import 'widgets/compact_news_card.dart';
import 'widgets/home_header.dart';
import 'widgets/local_service_card.dart';
import 'widgets/official_announcement_card.dart';
import 'widgets/quick_action_grid.dart';
import 'widgets/reception_card.dart';
import 'widgets/useful_section_card.dart';
import 'widgets/weather_status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.repository});

  final HomeRepository? repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<RepositoryResult<HomeContent>> _homeFuture;

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
  void initState() {
    super.initState();
    _homeFuture = (widget.repository ?? HomeRepository())
        .fetchHomeContentResult();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RepositoryResult<HomeContent>>(
      future: _homeFuture,
      initialData: _fallbackResult,
      builder: (context, snapshot) {
        final result = snapshot.data ?? _fallbackResult;
        final content = result.data;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 128),
            children: <Widget>[
              const HomeHeader(),
              if (isLoading) ...[
                const SizedBox(height: 10),
                const LinearProgressIndicator(minHeight: 2),
              ] else if (result.isFallback) ...[
                const SizedBox(height: 10),
                DataStatusBanner(message: result.message!),
              ],
              const SizedBox(height: 18),
              WeatherStatusCard(
                announcementCount: content.announcementCount,
                receptionCount: content.receptionCount,
              ),
              const SizedBox(height: 16),
              OfficialAnnouncementCard(announcement: content.announcement),
              const SizedBox(height: 16),
              const QuickActionGrid(items: _quickActions),
              const SizedBox(height: 18),
              const SectionHeader(
                title: 'Bugungi sayyor qabullar',
                actionLabel: "Barchasini ko'rish",
              ),
              const SizedBox(height: 10),
              ReceptionCard(reception: content.reception),
              const SizedBox(height: 18),
              const SectionHeader(
                title: "So'nggi yangiliklar",
                actionLabel: "Barchasini ko'rish",
              ),
              const SizedBox(height: 10),
              _NewsRow(items: _compactNews(content.news)),
              const SizedBox(height: 18),
              const SectionHeader(title: "Foydali bo'limlar"),
              const SizedBox(height: 10),
              const UsefulSectionGrid(items: _usefulSections),
              const SizedBox(height: 18),
              const SectionHeader(
                title: 'Mahalliy xizmatlar',
                actionLabel: "Barchasini ko'rish",
              ),
              const SizedBox(height: 10),
              const LocalServiceGrid(items: _localServices),
            ],
          ),
        );
      },
    );
  }

  List<CompactNewsItem> _compactNews(List<NewsItem> news) {
    return news
        .take(3)
        .map(
          (item) => CompactNewsItem(
            title: item.title,
            category: item.category,
            date: item.date,
          ),
        )
        .toList();
  }

  static RepositoryResult<HomeContent> get _fallbackResult {
    return RepositoryResult.fallback(
      HomeContent(
        announcement: HomeRepository.fallbackAnnouncement,
        reception: HomeRepository.fallbackReception,
        news: NewsRepository.fallbackNews.take(3).toList(),
        announcementCount: 3,
        receptionCount: 1,
      ),
      message: 'Bosh sahifa vaqtincha lokal ma\'lumotlardan ko\'rsatildi.',
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
