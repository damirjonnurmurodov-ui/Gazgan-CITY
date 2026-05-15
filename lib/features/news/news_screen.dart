import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/data/repository_result.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/data_status_banner.dart';
import '../../core/widgets/section_header.dart';
import 'data/news_repository.dart';
import 'models/news_item.dart';
import 'widgets/featured_news_card.dart';
import 'widgets/news_list_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key, this.repository});

  final NewsRepository? repository;

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String _selectedCategory = 'Barchasi';
  late final Future<RepositoryResult<List<NewsItem>>> _newsFuture;

  static const List<String> _categories = <String>[
    'Barchasi',
    'Rasmiy e\'lonlar',
    'Sayyor qabullar',
    'Tadbirlar',
    'Yangiliklar',
  ];

  @override
  void initState() {
    super.initState();
    _newsFuture = (widget.repository ?? NewsRepository()).fetchNewsResult();
  }

  List<NewsItem> _filteredNews(List<NewsItem> allNews) {
    if (_selectedCategory == 'Barchasi') return allNews;
    if (_selectedCategory == 'Yangiliklar') {
      return allNews
          .where(
            (n) =>
                n.category == 'Obodonlashtirish' ||
                n.category == 'Transport' ||
                n.category == 'Ish o\'rinlari',
          )
          .toList();
    }
    return allNews.where((n) => n.category == _selectedCategory).toList();
  }

  NewsItem _featuredNews(List<NewsItem> allNews) {
    return allNews.firstWhere(
      (item) => item.isFeatured || item.isOfficial,
      orElse: () =>
          allNews.isEmpty ? NewsRepository.fallbackFeaturedNews : allNews.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RepositoryResult<List<NewsItem>>>(
      future: _newsFuture,
      initialData: const RepositoryResult.fallback(
        NewsRepository.fallbackNews,
        message: 'Yangiliklar vaqtincha lokal ma\'lumotlardan ko\'rsatildi.',
      ),
      builder: (context, snapshot) {
        final result =
            snapshot.data ??
            const RepositoryResult.fallback(
              NewsRepository.fallbackNews,
              message:
                  'Yangiliklar vaqtincha lokal ma\'lumotlardan ko\'rsatildi.',
            );
        final allNews = result.data;
        final news = _filteredNews(allNews);
        final featuredNews = _featuredNews(allNews);
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 128),
            children: <Widget>[
              _HeaderRow(),
              if (isLoading) ...[
                const SizedBox(height: 10),
                const LinearProgressIndicator(minHeight: 2),
              ] else if (result.isFallback) ...[
                const SizedBox(height: 10),
                DataStatusBanner(message: result.message!),
              ],
              const SizedBox(height: 6),
              Text(
                'G\'ozg\'on shahri yangiliklari va rasmiy e\'lonlar',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMuted,
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return CategoryChip(
                      label: cat,
                      isSelected: cat == _selectedCategory,
                      onTap: () => setState(() => _selectedCategory = cat),
                    );
                  },
                ),
              ),
              if (_selectedCategory == 'Barchasi' ||
                  _selectedCategory == 'Sayyor qabullar' ||
                  _selectedCategory == 'Rasmiy e\'lonlar') ...[
                const SizedBox(height: 18),
                FeaturedNewsCard(
                  item: featuredNews,
                  onTap: () => debugPrint('Featured: ${featuredNews.id}'),
                  onDetailsTap: () => debugPrint('Details: ${featuredNews.id}'),
                ),
              ],
              const SizedBox(height: 20),
              const SectionHeader(
                title: 'So\'nggi yangiliklar',
                actionLabel: 'Barchasini ko\'rish',
              ),
              const SizedBox(height: 12),
              ...List<Widget>.generate(news.length, (index) {
                final item = news[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < news.length - 1 ? 12 : 0,
                  ),
                  child: NewsListCard(
                    item: item,
                    onTap: () => debugPrint('News: ${item.id}'),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'Yangiliklar',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.screenTitle,
          ),
        ),
        _IconButton(
          icon: LucideIcons.bell,
          onTap: () => debugPrint('Notifications'),
        ),
        const SizedBox(width: 8),
        _IconButton(
          icon: LucideIcons.search,
          onTap: () => debugPrint('Search'),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.marbleGray,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: AppColors.darkNavy),
        ),
      ),
    );
  }
}
