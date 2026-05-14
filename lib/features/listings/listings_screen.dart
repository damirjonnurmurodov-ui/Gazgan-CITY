import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';


import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_search_field.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/section_header.dart';
import 'models/listing_item.dart';
import 'widgets/listing_card.dart';
import 'widgets/safety_banner.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  String _selectedCategory = 'Barchasi';
  final Set<String> _favoriteIds = <String>{};

  static const List<String> _categories = <String>[
    'Barchasi',
    'Xizmatlar',
    'Savdo',
    'Ish o\'rinlari',
    'Ko\'chmas mulk',
    'Transport',
    'Elektronika',
  ];

  static const List<ListingItem> _listings = <ListingItem>[
    ListingItem(
      id: '1',
      title: '3 xonali kvartira ijaraga beriladi',
      price: '2 500 000 so\'m/oy',
      location: "Mustaqillik ko'chasi, 12-uy",
      date: 'Bugun, 14:25',
      category: "Ko'chmas mulk",
      icon: LucideIcons.building2,
      imageColor: Color(0xFF4A90D9),
      isFeatured: true,
      isOfficial: true,
    ),
    ListingItem(
      id: '2',
      title: 'iPhone 15 Pro Max 256 GB yangi',
      price: '18 500 000 so\'m',
      location: "Bozor ko'chasi, 5-uy",
      date: 'Bugun, 11:10',
      category: 'Elektronika',
      icon: LucideIcons.smartphone,
      imageColor: Color(0xFF5C6BC0),
      isFeatured: false,
      isOfficial: false,
    ),
    ListingItem(
      id: '3',
      title: 'Santexnik xizmatlari — arzon va sifatli',
      price: '500 000 so\'m',
      location: "Bunyodkor ko'chasi, 22-uy",
      date: 'Kecha, 18:45',
      category: 'Xizmatlar',
      icon: LucideIcons.wrench,
      imageColor: Color(0xFF26A69A),
      isFeatured: false,
      isOfficial: true,
    ),
    ListingItem(
      id: '4',
      title: 'Bozorda savdo rastasi ijaraga beriladi',
      price: '8 000 000 so\'m/oy',
      location: "Markaziy bozor, 3-qator",
      date: 'Kecha, 15:30',
      category: 'Savdo',
      icon: LucideIcons.store,
      imageColor: Color(0xFFFF7043),
      isFeatured: true,
      isOfficial: false,
    ),
    ListingItem(
      id: '5',
      title: 'Yuk tashish xizmati — Gazgan bo\'ylab',
      price: '300 000 so\'m',
      location: "Tinchlik ko'chasi, 8-uy",
      date: '07.05.2026',
      category: 'Transport',
      icon: LucideIcons.truck,
      imageColor: Color(0xFF42A5F5),
    ),
    ListingItem(
      id: '6',
      title: 'Ofitsiant qabul qilinadi — restoranga',
      price: '6 500 000 so\'m/oy',
      location: "Navoiy ko'chasi, 30-uy",
      date: '07.05.2026',
      category: 'Ish o\'rinlari',
      icon: LucideIcons.briefcase,
      imageColor: Color(0xFF8D6E63),
      isOfficial: true,
    ),
    ListingItem(
      id: '7',
      title: 'Elektrik ta\'mirlash — barcha tumanlarda',
      price: '350 000 so\'m',
      location: "Tabiat ko'chasi, 14-uy",
      date: '06.05.2026',
      category: 'Xizmatlar',
      icon: LucideIcons.zap,
      imageColor: Color(0xFFFFC107),
    ),
    ListingItem(
      id: '8',
      title: 'Samsung Galaxy S25 Ultra sotiladi',
      price: '15 000 000 so\'m',
      location: "Bozor ko'chasi, 7-uy",
      date: '06.05.2026',
      category: 'Elektronika',
      icon: LucideIcons.smartphone,
      imageColor: Color(0xFF7E57C2),
      isFeatured: true,
    ),
  ];

  List<ListingItem> get _filteredListings {
    if (_selectedCategory == 'Barchasi') {
      return _listings;
    }
    return _listings.where((l) => l.category == _selectedCategory).toList();
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final listings = _filteredListings;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 128),
        children: <Widget>[
          Text(
            'E\'lonlar',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.screenTitle,
          ),
          const SizedBox(height: 14),
          const AppSearchField(
            hintText: 'E\'lonlardan qidirish...',
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 16),
          const SafetyBanner(),
          const SizedBox(height: 18),
          const SectionHeader(
            title: 'So\'nggi e\'lonlar',
            actionLabel: 'Barchasini ko\'rish',
          ),
          const SizedBox(height: 12),
          ...List<Widget>.generate(listings.length, (index) {
            final listing = listings[index];
            return Padding(
              padding: EdgeInsets.only(bottom: index < listings.length - 1 ? 12 : 0),
              child: ListingCard(
                item: listing,
                isFavorite: _favoriteIds.contains(listing.id),
                onTap: () {
                  debugPrint('Listing tapped: ${listing.id}');
                },
                onFavoriteTap: () => _toggleFavorite(listing.id),
              ),
            );
          }),
        ],
      ),
    );
  }
}
