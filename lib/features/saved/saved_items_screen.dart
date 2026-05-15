import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/data/repository_result.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_state_card.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/data_status_banner.dart';
import '../auth/data/auth_repository.dart';
import '../auth/models/auth_user.dart';
import 'data/saved_items_repository.dart';
import 'models/saved_item.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key, this.repository, this.authRepository});

  final SavedItemsRepository? repository;
  final AuthRepository? authRepository;

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  SavedItemType? _selectedType;
  late final SavedItemsRepository _repository;
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? SavedItemsRepository();
    _authRepository = widget.authRepository ?? SupabaseAuthRepository();
  }

  List<SavedItem> _filteredItems(List<SavedItem> items) {
    final selectedType = _selectedType;
    if (selectedType == null) return items;
    return items.where((item) => item.type == selectedType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser?>(
      stream: _authRepository.authStateChanges,
      initialData: _authRepository.currentUser,
      builder: (context, authSnapshot) {
        final user = authSnapshot.data;
        if (user == null) {
          return _SavedScaffold(
            child: AppStateCard(
              title: 'Saqlanganlar uchun tizimga kiring',
              message:
                  'E\'lon, yangilik va xarita joylarini saqlash uchun akkauntingizga kiring.',
              icon: LucideIcons.lock,
              actionLabel: 'Kirish',
              onActionTap: () {
                final redirect = Uri.encodeComponent('/saved');
                context.push('/login?redirect=$redirect');
              },
            ),
          );
        }

        return FutureBuilder<RepositoryResult<List<SavedItem>>>(
          future: _repository.fetchSavedItemsResult(user.id),
          builder: (context, snapshot) {
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final result = snapshot.data;
            final allItems = result?.data ?? const <SavedItem>[];
            final items = _filteredItems(allItems);

            if (isLoading && result == null) {
              return const _SavedScaffold(
                child: AppStateCard(
                  title: 'Saqlanganlar yuklanmoqda',
                  message: 'Shaxsiy saqlanganlaringiz tayyorlanmoqda.',
                  icon: LucideIcons.loader,
                  isLoading: true,
                ),
              );
            }

            return _SavedScaffold(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (result != null && result.isFallback) ...<Widget>[
                    DataStatusBanner(message: result.message!),
                    const SizedBox(height: 14),
                  ],
                  _TypeFilters(
                    selectedType: _selectedType,
                    onSelected: (type) => setState(() => _selectedType = type),
                  ),
                  const SizedBox(height: 14),
                  if (items.isEmpty)
                    AppStateCard(
                      title: 'Saqlanganlar yo\'q',
                      message: _selectedType == null
                          ? 'Saqlangan e\'lonlar shu yerda ko\'rinadi.'
                          : 'Tanlangan bo\'limda saqlangan ma\'lumot yo\'q.',
                      icon: LucideIcons.bookmark,
                    )
                  else
                    ...List<Widget>.generate(items.length, (index) {
                      final item = items[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index < items.length - 1 ? 12 : 0,
                        ),
                        child: _SavedItemCard(
                          item: item,
                          onTap: () => _openSavedItem(context, item),
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openSavedItem(BuildContext context, SavedItem item) {
    switch (item.type) {
      case SavedItemType.listing:
        context.push('/listing-detail/${item.itemId}', extra: item.listing);
      case SavedItemType.news:
        context.push('/news-detail/${item.itemId}', extra: item.news);
      case SavedItemType.mapPlace:
        context.go('/map');
    }
  }
}

class _SavedScaffold extends StatelessWidget {
  const _SavedScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Saqlanganlar',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.screenTitle,
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(LucideIcons.x, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.marbleGray,
                    foregroundColor: AppColors.darkNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'E\'lonlar, yangiliklar va xaritadagi joylar',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _TypeFilters extends StatelessWidget {
  const _TypeFilters({required this.selectedType, required this.onSelected});

  final SavedItemType? selectedType;
  final ValueChanged<SavedItemType?> onSelected;

  @override
  Widget build(BuildContext context) {
    final filters = <({String label, SavedItemType? type})>[
      (label: 'Barchasi', type: null),
      (label: 'E\'lonlar', type: SavedItemType.listing),
      (label: 'Yangiliklar', type: SavedItemType.news),
      (label: 'Xarita', type: SavedItemType.mapPlace),
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return CategoryChip(
            label: filter.label,
            isSelected: filter.type == selectedType,
            onTap: () => onSelected(filter.type),
          );
        },
      ),
    );
  }
}

class _SavedItemCard extends StatelessWidget {
  const _SavedItemCard({required this.item, required this.onTap});

  final SavedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _iconForType(item.type),
              color: AppColors.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.marbleGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.typeLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryBlue,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _iconForType(SavedItemType type) {
  switch (type) {
    case SavedItemType.listing:
      return LucideIcons.megaphone;
    case SavedItemType.news:
      return LucideIcons.newspaper;
    case SavedItemType.mapPlace:
      return LucideIcons.mapPin;
  }
}
