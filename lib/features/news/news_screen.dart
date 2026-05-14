import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/section_header.dart';
import 'models/news_item.dart';
import 'widgets/featured_news_card.dart';
import 'widgets/news_list_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String _selectedCategory = 'Barchasi';

  static const List<String> _categories = <String>[
    'Barchasi',
    'Rasmiy e\'lonlar',
    'Sayyor qabullar',
    'Tadbirlar',
    'Yangiliklar',
  ];

  static const NewsItem _featuredNews = NewsItem(
    id: 'featured',
    title: 'Marmarobod MFYda sayyor qabul bo\'lib o\'tadi',
    description:
        'Bugun soat 15:00 da aholi bilan ochiq muloqot tashkil etiladi. Mahalla fuqarolar yig\'inida shahar hokimi ishtirok etadi.',
    date: '08 May 2026',
    category: 'Sayyor qabullar',
    icon: LucideIcons.users,
    imageColor: Color(0xFF1368E8),
    isFeatured: true,
    isOfficial: true,
  );

  static const List<NewsItem> _allNews = <NewsItem>[
    NewsItem(
      id: '1',
      title: 'Shahar hokimiyati tomonidan yangi qaror qabul qilindi',
      description:
          'G\'ozg\'on shahri obodonlashtirish bo\'yicha 2026 yilgi reja tasdiqlandi.',
      date: '08 May 2026',
      category: 'Rasmiy e\'lonlar',
      icon: LucideIcons.fileText,
      imageColor: Color(0xFF1368E8),
      isOfficial: true,
    ),
    NewsItem(
      id: '2',
      title: 'Navoiy MFYda sayyor qabul o\'tkaziladi',
      description:
          'Shu hafta juma kuni soat 14:00 da Navoiy MFYda aholi murojaatlarini tinglash tadbiri.',
      date: '07 May 2026',
      category: 'Sayyor qabullar',
      icon: LucideIcons.users,
      imageColor: Color(0xFF17B26A),
      isOfficial: true,
    ),
    NewsItem(
      id: '3',
      title: 'Yoshlar festivali dasturi tasdiqlandi',
      description:
          '15-may kuni shahar markaziy bog\'ida "Yoshlar ovozi" festivali bo\'lib o\'tadi.',
      date: '06 May 2026',
      category: 'Tadbirlar',
      icon: LucideIcons.music,
      imageColor: Color(0xFFFF7043),
    ),
    NewsItem(
      id: '4',
      title: 'Mustaqillik ko\'chasida obodonlashtirish ishlari yakunlandi',
      description:
          'Ko\'cha bo\'ylab yangi yoritish tizimi o\'rnatildi va piyodalar yo\'laklari ta\'mirlandi.',
      date: '05 May 2026',
      category: 'Obodonlashtirish',
      icon: LucideIcons.trees,
      imageColor: Color(0xFF26A69A),
      isOfficial: true,
    ),
    NewsItem(
      id: '5',
      title: 'Korxonalarda 25 ta yangi ish o\'rni yaratildi',
      description:
          'G\'ozg\'on shahridagi marmar va qurilish korxonalarida yangi ish o\'rinlari e\'lon qilindi.',
      date: '04 May 2026',
      category: 'Ish o\'rinlari',
      icon: LucideIcons.briefcase,
      imageColor: Color(0xFF5C6BC0),
    ),
    NewsItem(
      id: '6',
      title: 'Muhim xabar: suv ta\'minoti bo\'yicha ogohlantirish',
      description:
          '12-may kuni soat 09:00 dan 16:00 gacha suv ta\'minotida vaqtinchalik uzilishlar kutilmoqda.',
      date: '04 May 2026',
      category: 'Muhim xabarlar',
      icon: LucideIcons.alertTriangle,
      imageColor: Color(0xFFF04438),
      isOfficial: true,
    ),
    NewsItem(
      id: '7',
      title: 'Yangi avtobus yo\'nalishi ishga tushdi',
      description:
          'G\'ozg\'on shahri va Navoiy viloyati o\'rtasida yangi avtobus qatnovi yo\'lga qo\'yildi.',
      date: '03 May 2026',
      category: 'Transport',
      icon: LucideIcons.bus,
      imageColor: Color(0xFF42A5F5),
    ),
    NewsItem(
      id: '8',
      title: 'Tibbiy ko\'rik kunlari e\'lon qilindi',
      description:
          'Shahar markaziy poliklinikasida 20-25 may kunlari bepul tibbiy ko\'rik o\'tkaziladi.',
      date: '02 May 2026',
      category: 'Rasmiy e\'lonlar',
      icon: LucideIcons.heartPulse,
      imageColor: Color(0xFFEC407A),
      isOfficial: true,
    ),
  ];

  List<NewsItem> get _filteredNews {
    if (_selectedCategory == 'Barchasi') return _allNews;
    if (_selectedCategory == 'Yangiliklar') {
      return _allNews
          .where((n) => n.category == 'Obodonlashtirish' ||
              n.category == 'Transport' ||
              n.category == 'Ish o\'rinlari')
          .toList();
    }
    return _allNews.where((n) => n.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final news = _filteredNews;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 128),
        children: <Widget>[
          _HeaderRow(),
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
              item: _featuredNews,
              onTap: () => debugPrint('Featured: ${_featuredNews.id}'),
              onDetailsTap: () => debugPrint('Details: ${_featuredNews.id}'),
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
