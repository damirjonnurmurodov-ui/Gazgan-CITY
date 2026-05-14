import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_search_field.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/section_header.dart';
import 'models/map_place.dart';
import 'widgets/mock_map_widget.dart';
import 'widgets/quick_place_card.dart';
import 'widgets/selected_place_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _selectedPlaceId;
  String _selectedCategory = 'Barchasi';

  static const List<MapPlace> _places = <MapPlace>[
    MapPlace(
      id: '1',
      name: "Hokimiyat",
      category: "Davlat idorasi",
      address: "Mustaqillik ko'chasi, 1-uy, G'ozg'on shahri",
      icon: LucideIcons.building2,
      x: 0.27,
      y: 0.30,
    ),
    MapPlace(
      id: '2',
      name: 'IIB bo\'limi',
      category: "Davlat idorasi",
      address: "Tinchlik ko'chasi, 15-uy, G'ozg'on shahri",
      icon: LucideIcons.shield,
      x: 0.73,
      y: 0.28,
    ),
    MapPlace(
      id: '3',
      name: 'Markaziy kasalxona',
      category: 'Tibbiyot',
      address: "Bunyodkor ko'chasi, 42-uy, G'ozg'on shahri",
      icon: LucideIcons.heartPulse,
      x: 0.13,
      y: 0.58,
    ),
    MapPlace(
      id: '4',
      name: '1-sonli maktab',
      category: 'Ta\'lim',
      address: "Navoiy ko'chasi, 8-uy, G'ozg'on shahri",
      icon: LucideIcons.graduationCap,
      x: 0.50,
      y: 0.42,
    ),
    MapPlace(
      id: '5',
      name: 'Markaziy bozor',
      category: 'Savdo',
      address: "Bozor ko'chasi, 3-uy, G'ozg'on shahri",
      icon: LucideIcons.shoppingBag,
      x: 0.68,
      y: 0.68,
    ),
    MapPlace(
      id: '6',
      name: 'Istirohat bog\'i',
      category: 'Dam olish',
      address: "Tabiat ko'chasi, 10-uy, G'ozg'on shahri",
      icon: LucideIcons.trees,
      x: 0.16,
      y: 0.84,
    ),
  ];

  static const List<String> _categories = <String>[
    'Barchasi',
    'Davlat idorasi',
    'Transport',
    'Dam olish',
    'Savdo',
    'Tibbiyot',
    'Ta\'lim',
  ];

  static const List<QuickPlaceItem> _quickPlaces = <QuickPlaceItem>[
    QuickPlaceItem(
      id: 'gov',
      icon: LucideIcons.building2,
      label: 'Hokimiyat',
      color: AppColors.primaryBlue,
    ),
    QuickPlaceItem(
      id: 'police',
      icon: LucideIcons.shield,
      label: 'Politsiya',
      color: AppColors.primaryBlue,
    ),
    QuickPlaceItem(
      id: 'hospital',
      icon: LucideIcons.heartPulse,
      label: 'Kasalxona',
      color: AppColors.redDanger,
    ),
    QuickPlaceItem(
      id: 'school',
      icon: LucideIcons.graduationCap,
      label: 'Maktab',
      color: AppColors.primaryBlue,
    ),
    QuickPlaceItem(
      id: 'market',
      icon: LucideIcons.shoppingBag,
      label: 'Bozor',
      color: AppColors.goldAccent,
    ),
    QuickPlaceItem(
      id: 'park',
      icon: LucideIcons.trees,
      label: 'Park',
      color: AppColors.greenSuccess,
    ),
  ];

  List<MapPlace> get _filteredPlaces {
    if (_selectedCategory == 'Barchasi') {
      return _places;
    }
    return _places.where((p) => p.category == _selectedCategory).toList();
  }

  MapPlace? get _selectedPlace {
    if (_selectedPlaceId == null) return null;
    try {
      return _places.firstWhere((p) => p.id == _selectedPlaceId);
    } catch (_) {
      return null;
    }
  }

  void _onPlaceSelected(String id) {
    setState(() {
      if (_selectedPlaceId == id) {
        _selectedPlaceId = null;
      } else {
        _selectedPlaceId = id;
      }
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedPlaceId = null;
    });
  }

  void _onQuickPlaceTap(String id) {
    setState(() {
      _selectedPlaceId = id == 'gov'
          ? '1'
          : id == 'police'
              ? '2'
              : id == 'hospital'
                  ? '3'
                  : id == 'school'
                      ? '4'
                      : id == 'market'
                          ? '5'
                          : id == 'park'
                              ? '6'
                              : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 128),
        children: <Widget>[
          Text(
            'Xarita',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.screenTitle,
          ),
          const SizedBox(height: 14),
          const AppSearchField(
            hintText: 'Xaritadan qidirish...',
          ),
          const SizedBox(height: 12),
          _CategoryChipRow(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: _onCategorySelected,
          ),
          const SizedBox(height: 16),
          MockMapWidget(
            places: _filteredPlaces,
            selectedPlaceId: _selectedPlaceId,
            onPlaceSelected: _onPlaceSelected,
          ),
          if (_selectedPlace != null) ...[
            const SizedBox(height: 16),
            SelectedPlaceCard(
              place: _selectedPlace!,
              onClose: () {
                setState(() {
                  _selectedPlaceId = null;
                });
              },
              onDirections: () {
                debugPrint('Directions to: ${_selectedPlace!.name}');
              },
            ),
          ],
          const SizedBox(height: 20),
          const SectionHeader(title: 'Tezkor joylar'),
          const SizedBox(height: 12),
          QuickPlaceGrid(
            items: _quickPlaces,
            onItemTap: _onQuickPlaceTap,
          ),
        ],
      ),
    );
  }
}

class _CategoryChipRow extends StatelessWidget {
  const _CategoryChipRow({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryChip(
            label: category,
            isSelected: category == selectedCategory,
            onTap: () => onCategorySelected(category),
          );
        },
      ),
    );
  }
}
