import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/data/repository_result.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_search_field.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/data_status_banner.dart';
import '../../core/widgets/section_header.dart';
import '../auth/data/auth_repository.dart';
import '../auth/models/auth_user.dart';
import '../saved/data/saved_items_repository.dart';
import '../saved/models/saved_item.dart';
import 'data/map_places_repository.dart';
import 'models/map_place.dart';
import 'widgets/mock_map_widget.dart';
import 'widgets/quick_place_card.dart';
import 'widgets/selected_place_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.repository,
    this.authRepository,
    this.savedRepository,
  });

  final MapPlacesRepository? repository;
  final AuthRepository? authRepository;
  final SavedItemsRepository? savedRepository;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _selectedPlaceId;
  String _selectedCategory = 'Barchasi';
  final Map<String, bool> _savedOverrides = <String, bool>{};
  late final AuthRepository _authRepository;
  late final SavedItemsRepository _savedRepository;
  late final Future<RepositoryResult<List<MapPlace>>> _placesFuture;
  late final Future<Set<String>> _savedMapPlaceIdsFuture;

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

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? SupabaseAuthRepository();
    _savedRepository = widget.savedRepository ?? SavedItemsRepository();
    _placesFuture = (widget.repository ?? MapPlacesRepository())
        .fetchPlacesResult();
    final user = _currentUserOrNull(_authRepository);
    _savedMapPlaceIdsFuture = user == null
        ? Future<Set<String>>.value(<String>{})
        : _savedRepository.fetchSavedItemIds(
            userId: user.id,
            type: SavedItemType.mapPlace,
          );
  }

  List<MapPlace> _filteredPlaces(List<MapPlace> places) {
    if (_selectedCategory == 'Barchasi') return places;
    return places
        .where((place) => place.category == _selectedCategory)
        .toList();
  }

  MapPlace? _selectedPlace(List<MapPlace> places) {
    if (_selectedPlaceId == null) return null;
    for (final place in places) {
      if (place.id == _selectedPlaceId) return place;
    }
    return null;
  }

  void _onPlaceSelected(String id) {
    setState(() {
      _selectedPlaceId = _selectedPlaceId == id ? null : id;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedPlaceId = null;
    });
  }

  void _onQuickPlaceTap(String id, List<MapPlace> places) {
    final selectedId = _findQuickPlaceId(id, places);
    setState(() {
      _selectedPlaceId = selectedId;
    });
  }

  String? _findQuickPlaceId(String id, List<MapPlace> places) {
    bool match(MapPlace place, List<String> terms) {
      final text = '${place.name} ${place.category}'.toLowerCase();
      return terms.any(text.contains);
    }

    final terms = switch (id) {
      'gov' => <String>['hokim', 'davlat'],
      'police' => <String>['iib', 'polits', 'shield'],
      'hospital' => <String>['kasal', 'tibb'],
      'school' => <String>['maktab', 'ta\'lim'],
      'market' => <String>['bozor', 'savdo'],
      'park' => <String>['park', 'bog', 'dam'],
      _ => <String>[],
    };

    for (final place in places) {
      if (match(place, terms)) return place.id;
    }
    return places.isEmpty ? null : places.first.id;
  }

  Future<void> _toggleSavedPlace(String id, bool isSaved) async {
    final user = _currentUserOrNull(_authRepository);
    if (user == null) {
      final redirect = Uri.encodeComponent('/map');
      context.push('/login?redirect=$redirect');
      return;
    }

    final next = !isSaved;
    setState(() => _savedOverrides[id] = next);

    try {
      await _savedRepository.setSaved(
        userId: user.id,
        type: SavedItemType.mapPlace,
        itemId: id,
        isSaved: next,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _savedOverrides.remove(id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saqlash holatini yangilab bo\'lmadi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Set<String>>(
      future: _savedMapPlaceIdsFuture,
      initialData: const <String>{},
      builder: (context, savedSnapshot) {
        final savedIds = savedSnapshot.data ?? const <String>{};

        return FutureBuilder<RepositoryResult<List<MapPlace>>>(
          future: _placesFuture,
          initialData: const RepositoryResult.fallback(
            MapPlacesRepository.fallbackPlaces,
            message: 'Xarita vaqtincha lokal obyektlardan ko\'rsatildi.',
          ),
          builder: (context, snapshot) {
            final result =
                snapshot.data ??
                const RepositoryResult.fallback(
                  MapPlacesRepository.fallbackPlaces,
                  message: 'Xarita vaqtincha lokal obyektlardan ko\'rsatildi.',
                );
            final places = result.data;
            final filteredPlaces = _filteredPlaces(places);
            final selectedPlace = _selectedPlace(places);
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting;

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
                  if (isLoading) ...[
                    const SizedBox(height: 10),
                    const LinearProgressIndicator(minHeight: 2),
                  ] else if (result.isFallback) ...[
                    const SizedBox(height: 10),
                    DataStatusBanner(message: result.message!),
                  ],
                  const SizedBox(height: 14),
                  const AppSearchField(hintText: 'Xaritadan qidirish...'),
                  const SizedBox(height: 12),
                  _CategoryChipRow(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: _onCategorySelected,
                  ),
                  const SizedBox(height: 16),
                  MockMapWidget(
                    places: filteredPlaces,
                    selectedPlaceId: _selectedPlaceId,
                    onPlaceSelected: _onPlaceSelected,
                  ),
                  if (selectedPlace != null) ...[
                    const SizedBox(height: 16),
                    SelectedPlaceCard(
                      place: selectedPlace,
                      isSaved:
                          _savedOverrides[selectedPlace.id] ??
                          savedIds.contains(selectedPlace.id),
                      onClose: () {
                        setState(() {
                          _selectedPlaceId = null;
                        });
                      },
                      onDirections: () {
                        debugPrint('Directions to: ${selectedPlace.name}');
                      },
                      onSave: () {
                        final isSaved =
                            _savedOverrides[selectedPlace.id] ??
                            savedIds.contains(selectedPlace.id);
                        _toggleSavedPlace(selectedPlace.id, isSaved);
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  const SectionHeader(title: 'Tezkor joylar'),
                  const SizedBox(height: 12),
                  QuickPlaceGrid(
                    items: _quickPlaces,
                    onItemTap: (id) => _onQuickPlaceTap(id, places),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

AuthUser? _currentUserOrNull(AuthRepository repository) {
  try {
    return repository.currentUser;
  } catch (_) {
    return null;
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
