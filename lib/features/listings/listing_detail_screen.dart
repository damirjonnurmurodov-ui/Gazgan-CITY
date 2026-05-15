import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/data/repository_result.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_state_card.dart';
import '../../core/widgets/data_status_banner.dart';
import '../auth/data/auth_repository.dart';
import '../saved/data/saved_items_repository.dart';
import '../saved/models/saved_item.dart';
import 'data/listings_repository.dart';
import 'models/listing_item.dart';

class ListingDetailScreen extends StatefulWidget {
  const ListingDetailScreen({
    super.key,
    required this.listingId,
    this.initialItem,
    this.repository,
    this.authRepository,
    this.savedRepository,
  });

  final String listingId;
  final ListingItem? initialItem;
  final ListingsRepository? repository;
  final AuthRepository? authRepository;
  final SavedItemsRepository? savedRepository;

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  late final ListingsRepository _repository;
  late final AuthRepository _authRepository;
  late final SavedItemsRepository _savedRepository;
  late final Future<RepositoryResult<ListingItem?>>? _listingFuture;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? ListingsRepository();
    _authRepository = widget.authRepository ?? SupabaseAuthRepository();
    _savedRepository = widget.savedRepository ?? SavedItemsRepository();
    _listingFuture = widget.initialItem == null
        ? _repository.fetchListingResult(widget.listingId)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialItem != null) {
      return _ListingDetailBody(
        item: widget.initialItem!,
        authRepository: _authRepository,
        savedRepository: _savedRepository,
      );
    }

    return FutureBuilder<RepositoryResult<ListingItem?>>(
      future: _listingFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final result = snapshot.data;
        final item = result?.data;

        if (isLoading) {
          return const _DetailScaffold(
            child: AppStateCard(
              title: 'E\'lon yuklanmoqda',
              message: 'E\'lon ma\'lumotlari tayyorlanmoqda.',
              icon: LucideIcons.loader,
              isLoading: true,
            ),
          );
        }

        if (item == null) {
          return _DetailScaffold(
            child: AppStateCard(
              title: 'E\'lon topilmadi',
              message: 'Bu e\'lon o\'chirilgan yoki hali tasdiqlanmagan.',
              icon: LucideIcons.searchX,
              actionLabel: 'Ortga qaytish',
              onActionTap: () => context.pop(),
            ),
          );
        }

        return _ListingDetailBody(
          item: item,
          fallbackMessage: result?.message,
          authRepository: _authRepository,
          savedRepository: _savedRepository,
        );
      },
    );
  }
}

class _ListingDetailBody extends StatefulWidget {
  const _ListingDetailBody({
    required this.item,
    required this.authRepository,
    required this.savedRepository,
    this.fallbackMessage,
  });

  final ListingItem item;
  final AuthRepository authRepository;
  final SavedItemsRepository savedRepository;
  final String? fallbackMessage;

  @override
  State<_ListingDetailBody> createState() => _ListingDetailBodyState();
}

class _ListingDetailBodyState extends State<_ListingDetailBody> {
  bool _isSaved = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final user = widget.authRepository.currentUser;
    if (user == null) return;

    final savedIds = await widget.savedRepository.fetchSavedItemIds(
      userId: user.id,
      type: SavedItemType.listing,
    );
    if (!mounted) return;
    setState(() => _isSaved = savedIds.contains(widget.item.id));
  }

  Future<void> _toggleSaved() async {
    final user = widget.authRepository.currentUser;
    if (user == null) {
      final redirect = Uri.encodeComponent('/listing-detail/${widget.item.id}');
      context.push('/login?redirect=$redirect');
      return;
    }

    final next = !_isSaved;
    setState(() {
      _isSaving = true;
      _isSaved = next;
    });

    try {
      await widget.savedRepository.setSaved(
        userId: user.id,
        type: SavedItemType.listing,
        itemId: widget.item.id,
        isSaved: next,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaved = !next);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saqlash holatini yangilab bo\'lmadi.')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.fallbackMessage != null) ...<Widget>[
            DataStatusBanner(message: widget.fallbackMessage!),
            const SizedBox(height: 14),
          ],
          _HeroCard(item: widget.item),
          const SizedBox(height: 12),
          AppButton(
            label: _isSaved ? 'Saqlangan' : 'Saqlash',
            icon: _isSaved ? LucideIcons.check : LucideIcons.bookmark,
            variant: _isSaved
                ? AppButtonVariant.secondary
                : AppButtonVariant.ghost,
            isExpanded: true,
            onPressed: _isSaving ? null : _toggleSaved,
          ),
          const SizedBox(height: 16),
          _InfoGrid(item: widget.item),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Tavsif', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 8),
                Text(
                  widget.item.description.trim().isEmpty
                      ? 'E\'lon egasi qo\'shimcha tavsif kiritmagan.'
                      : widget.item.description,
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            backgroundColor: AppColors.lightBlue,
            borderColor: AppColors.primaryBlue.withValues(alpha: 0.12),
            child: Row(
              children: <Widget>[
                const Icon(
                  LucideIcons.phone,
                  color: AppColors.primaryBlue,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.item.phone.trim().isEmpty
                        ? 'Telefon raqam kiritilmagan'
                        : widget.item.phone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailScaffold extends StatelessWidget {
  const _DetailScaffold({required this.child});

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
                AppButton(
                  label: 'Ortga',
                  icon: LucideIcons.chevronLeft,
                  variant: AppButtonVariant.ghost,
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'E\'lon tafsilotlari',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.screenTitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.item});

  final ListingItem item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              color: item.imageColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(22),
            ),
            clipBehavior: Clip.antiAlias,
            child: item.imageUrl == null || item.imageUrl!.trim().isEmpty
                ? Icon(
                    item.icon,
                    size: 64,
                    color: item.imageColor.withValues(alpha: 0.75),
                  )
                : Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        item.icon,
                        size: 64,
                        color: item.imageColor.withValues(alpha: 0.75),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _Badge(label: item.category, color: AppColors.primaryBlue),
              if (item.status != ListingStatus.active)
                _Badge(label: item.statusLabel, color: AppColors.goldAccent),
              if (item.isOfficial)
                const _Badge(label: 'Rasmiy', color: AppColors.goldAccent),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Text(
            item.price,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.primaryBlue,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.item});

  final ListingItem item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: <Widget>[
          _InfoRow(icon: LucideIcons.mapPin, label: item.location),
          const SizedBox(height: 12),
          _InfoRow(icon: LucideIcons.clock, label: item.date),
          const SizedBox(height: 12),
          _InfoRow(
            icon: LucideIcons.eye,
            label: '${item.viewsCount} ko\'rildi',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: AppColors.primaryBlue),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(color: color),
      ),
    );
  }
}
