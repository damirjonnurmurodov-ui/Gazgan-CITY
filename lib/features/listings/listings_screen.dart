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
import 'data/listings_repository.dart';
import 'models/listing_item.dart';
import 'widgets/listing_card.dart';
import 'widgets/safety_banner.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key, this.repository, this.authRepository});

  final ListingsRepository? repository;
  final AuthRepository? authRepository;

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  final _searchController = TextEditingController();
  final Set<String> _favoriteIds = <String>{};
  String _selectedCategory = 'Barchasi';
  String _query = '';

  late final ListingsRepository _repository;
  late final AuthRepository _authRepository;
  late final Future<RepositoryResult<List<ListingItem>>> _listingsFuture;
  late final Future<RepositoryResult<List<ListingCategory>>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? ListingsRepository();
    _authRepository = widget.authRepository ?? SupabaseAuthRepository();
    _listingsFuture = _repository.fetchListingsResult();
    _categoriesFuture = _repository.fetchCategoriesResult();
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

  void _toggleFavorite(String id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
  }

  void _openCreateListing() {
    if (_authRepository.currentUser == null) {
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
                      message: 'Mahalliy e\'lonlar ro\'yxati tayyorlanmoqda.',
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
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < listings.length - 1 ? 12 : 0,
                          ),
                          child: ListingCard(
                            item: listing,
                            isFavorite: _favoriteIds.contains(listing.id),
                            onTap: () => context.push(
                              '/listing-detail/${listing.id}',
                              extra: listing,
                            ),
                            onFavoriteTap: () => _toggleFavorite(listing.id),
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
