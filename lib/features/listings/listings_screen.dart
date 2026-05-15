import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/data/repository_result.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_search_field.dart';
import '../../core/widgets/app_state_card.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/data_status_banner.dart';
import '../../core/widgets/section_header.dart';
import '../auth/data/auth_repository.dart';
import '../auth/models/auth_user.dart';
import '../saved/data/saved_items_repository.dart';
import '../saved/models/saved_item.dart';
import 'data/listings_repository.dart';
import 'models/listing_item.dart';
import 'widgets/listing_card.dart';
import 'widgets/safety_banner.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({
    super.key,
    this.repository,
    this.authRepository,
    this.savedRepository,
  });

  final ListingsRepository? repository;
  final AuthRepository? authRepository;
  final SavedItemsRepository? savedRepository;

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  final _searchController = TextEditingController();
  final Map<String, bool> _favoriteOverrides = <String, bool>{};
  String _selectedCategory = 'Barchasi';
  String _query = '';

  late final ListingsRepository _repository;
  late final AuthRepository _authRepository;
  late final SavedItemsRepository _savedRepository;
  late final Future<RepositoryResult<List<ListingItem>>> _listingsFuture;
  late final Future<RepositoryResult<List<ListingCategory>>> _categoriesFuture;
  late final Future<Set<String>> _savedListingIdsFuture;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? ListingsRepository();
    _authRepository = widget.authRepository ?? SupabaseAuthRepository();
    _savedRepository = widget.savedRepository ?? SavedItemsRepository();
    _listingsFuture = _repository.fetchListingsResult();
    _categoriesFuture = _repository.fetchCategoriesResult();
    final user = _currentUserOrNull(_authRepository);
    _savedListingIdsFuture = user == null
        ? Future<Set<String>>.value(<String>{})
        : _savedRepository.fetchSavedItemIds(
            userId: user.id,
            type: SavedItemType.listing,
          );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ListingItem> _filteredListings(List<ListingItem> listings) {
    return listings.where((item) {
      final matchesCategory =
          _selectedCategory == 'Barchasi' || item.category == _selectedCategory;
      return matchesCategory && item.matchesQuery(_query);
    }).toList();
  }

  Future<void> _toggleFavorite(String id, bool isFavorite) async {
    final user = _currentUserOrNull(_authRepository);
    if (user == null) {
      final redirect = Uri.encodeComponent('/listings');
      context.push('/login?redirect=$redirect');
      return;
    }

    final next = !isFavorite;
    setState(() => _favoriteOverrides[id] = next);

    try {
      await _savedRepository.setSaved(
        userId: user.id,
        type: SavedItemType.listing,
        itemId: id,
        isSaved: next,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _favoriteOverrides.remove(id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saqlash holatini yangilab bo\'lmadi.')),
      );
    }
  }

  void _openCreateListing() {
    if (_currentUserOrNull(_authRepository) == null) {
      final redirect = Uri.encodeComponent('/create-listing');
      context.push('/login?redirect=$redirect');
      return;
    }

    context.push('/create-listing');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RepositoryResult<List<ListingCategory>>>(
      future: _categoriesFuture,
      initialData: const RepositoryResult.live(
        ListingsRepository.fallbackCategories,
      ),
      builder: (context, categoriesSnapshot) {
        final categories =
            categoriesSnapshot.data?.data ??
            ListingsRepository.fallbackCategories;

        return FutureBuilder<Set<String>>(
          future: _savedListingIdsFuture,
          initialData: const <String>{},
          builder: (context, savedSnapshot) {
            final savedIds = savedSnapshot.data ?? const <String>{};

            return FutureBuilder<RepositoryResult<List<ListingItem>>>(
              future: _listingsFuture,
              builder: (context, snapshot) {
                final result = snapshot.data;
                final isLoading =
                    snapshot.connectionState == ConnectionState.waiting &&
                    result == null;
                final listings = _filteredListings(
                  result?.data ?? const <ListingItem>[],
                );

                return SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 128),
                    children: <Widget>[
                      _ListingsHeader(onCreateTap: _openCreateListing),
                      const SizedBox(height: 14),
                      AppSearchField(
                        controller: _searchController,
                        hintText: 'E\'lonlardan qidirish...',
                        onChanged: (value) => setState(() => _query = value),
                      ),
                      const SizedBox(height: 12),
                      _CategoryList(
                        categories: categories,
                        selectedCategory: _selectedCategory,
                        onSelected: (category) {
                          setState(() => _selectedCategory = category);
                        },
                      ),
                      const SizedBox(height: 16),
                      const SafetyBanner(),
                      if (isLoading) ...<Widget>[
                        const SizedBox(height: 18),
                        const AppStateCard(
                          title: 'E\'lonlar yuklanmoqda',
                          message:
                              'Mahalliy e\'lonlar ro\'yxati tayyorlanmoqda.',
                          icon: LucideIcons.loader,
                          isLoading: true,
                        ),
                      ] else ...<Widget>[
                        if (result != null && result.isFallback) ...<Widget>[
                          const SizedBox(height: 10),
                          DataStatusBanner(message: result.message!),
                        ],
                        const SizedBox(height: 18),
                        SectionHeader(
                          title: 'So\'nggi e\'lonlar',
                          actionLabel: 'Yangisini qo\'shish',
                          onActionTap: _openCreateListing,
                        ),
                        const SizedBox(height: 12),
                        if (listings.isEmpty)
                          AppStateCard(
                            title: 'E\'lonlar topilmadi',
                            message:
                                'Tanlangan kategoriya yoki qidiruv bo\'yicha e\'lon yo\'q.',
                            icon: LucideIcons.searchX,
                            actionLabel: 'Yangi e\'lon qo\'shish',
                            onActionTap: _openCreateListing,
                          )
                        else
                          ...List<Widget>.generate(listings.length, (index) {
                            final listing = listings[index];
                            final isFavorite =
                                _favoriteOverrides[listing.id] ??
                                savedIds.contains(listing.id);
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index < listings.length - 1 ? 12 : 0,
                              ),
                              child: ListingCard(
                                item: listing,
                                isFavorite: isFavorite,
                                onTap: () => context.push(
                                  '/listing-detail/${listing.id}',
                                  extra: listing,
                                ),
                                onFavoriteTap: () =>
                                    _toggleFavorite(listing.id, isFavorite),
                              ),
                            );
                          }),
                      ],
                    ],
                  ),
                );
              },
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

class _ListingsHeader extends StatelessWidget {
  const _ListingsHeader({required this.onCreateTap});

  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'E\'lonlar',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.screenTitle,
              ),
              const SizedBox(height: 2),
              Text(
                'Mahalliy e\'lonlar va xizmatlar',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMuted,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        AppButton(
          label: 'E\'lon berish',
          icon: LucideIcons.plus,
          onPressed: onCreateTap,
        ),
      ],
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<ListingCategory> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final labels = <String>{
      'Barchasi',
      ...categories.map((category) => category.name),
    }.toList();

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = labels[index];
          return CategoryChip(
            label: category,
            isSelected: category == selectedCategory,
            onTap: () => onSelected(category),
          );
        },
      ),
    );
  }
}
