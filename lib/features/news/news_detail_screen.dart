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
import 'data/news_repository.dart';
import 'models/news_item.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({
    super.key,
    required this.newsId,
    this.initialItem,
    this.repository,
    this.authRepository,
    this.savedRepository,
  });

  final String newsId;
  final NewsItem? initialItem;
  final NewsRepository? repository;
  final AuthRepository? authRepository;
  final SavedItemsRepository? savedRepository;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late final NewsRepository _repository;
  late final AuthRepository _authRepository;
  late final SavedItemsRepository _savedRepository;
  late final Future<RepositoryResult<NewsItem?>>? _newsFuture;
  bool _viewsUpdateFailed = false;
  bool _isSaved = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? NewsRepository();
    _authRepository = widget.authRepository ?? SupabaseAuthRepository();
    _savedRepository = widget.savedRepository ?? SavedItemsRepository();
    _newsFuture = widget.initialItem == null
        ? _repository.fetchNewsItemResult(widget.newsId)
        : null;
    _incrementViews();
    _loadSavedState();
  }

  Future<void> _incrementViews() async {
    try {
      await _repository.incrementViews(widget.newsId);
    } catch (_) {
      if (!mounted) return;
      setState(() => _viewsUpdateFailed = true);
    }
  }

  Future<void> _loadSavedState() async {
    final user = _authRepository.currentUser;
    if (user == null) return;

    final savedIds = await _savedRepository.fetchSavedItemIds(
      userId: user.id,
      type: SavedItemType.news,
    );
    if (!mounted) return;
    setState(() => _isSaved = savedIds.contains(widget.newsId));
  }

  Future<void> _toggleSaved() async {
    final user = _authRepository.currentUser;
    if (user == null) {
      final redirect = Uri.encodeComponent('/news-detail/${widget.newsId}');
      context.push('/login?redirect=$redirect');
      return;
    }

    final next = !_isSaved;
    setState(() {
      _isSaved = next;
      _isSaving = true;
    });

    try {
      await _savedRepository.setSaved(
        userId: user.id,
        type: SavedItemType.news,
        itemId: widget.newsId,
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
    if (widget.initialItem != null) {
      return _NewsDetailBody(
        item: widget.initialItem!,
        viewsUpdateFailed: _viewsUpdateFailed,
        isSaved: _isSaved,
        isSaving: _isSaving,
        onSaveTap: _toggleSaved,
      );
    }

    return FutureBuilder<RepositoryResult<NewsItem?>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final result = snapshot.data;
        final item = result?.data;

        if (isLoading) {
          return const _NewsDetailScaffold(
            child: AppStateCard(
              title: 'Yangilik yuklanmoqda',
              message: 'Rasmiy yangilik ma\'lumotlari tayyorlanmoqda.',
              icon: LucideIcons.loader,
              isLoading: true,
            ),
          );
        }

        if (item == null) {
          return _NewsDetailScaffold(
            child: AppStateCard(
              title: 'Yangilik topilmadi',
              message: 'Bu yangilik mavjud emas yoki arxivlangan.',
              icon: LucideIcons.searchX,
              actionLabel: 'Ortga qaytish',
              onActionTap: () => context.pop(),
            ),
          );
        }

        return _NewsDetailBody(
          item: item,
          fallbackMessage: result?.message,
          viewsUpdateFailed: _viewsUpdateFailed,
          isSaved: _isSaved,
          isSaving: _isSaving,
          onSaveTap: _toggleSaved,
        );
      },
    );
  }
}

class _NewsDetailBody extends StatelessWidget {
  const _NewsDetailBody({
    required this.item,
    required this.viewsUpdateFailed,
    required this.isSaved,
    required this.isSaving,
    required this.onSaveTap,
    this.fallbackMessage,
  });

  final NewsItem item;
  final String? fallbackMessage;
  final bool viewsUpdateFailed;
  final bool isSaved;
  final bool isSaving;
  final VoidCallback onSaveTap;

  @override
  Widget build(BuildContext context) {
    return _NewsDetailScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (fallbackMessage != null) ...<Widget>[
            DataStatusBanner(message: fallbackMessage!),
            const SizedBox(height: 12),
          ],
          if (viewsUpdateFailed) ...<Widget>[
            const DataStatusBanner(
              message: 'Ko\'rishlar sonini yangilab bo\'lmadi.',
            ),
            const SizedBox(height: 12),
          ],
          AppCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                    color: item.imageColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    item.icon,
                    size: 64,
                    color: item.imageColor.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _Badge(label: item.category, color: AppColors.primaryBlue),
                    if (item.isOfficial)
                      const _Badge(
                        label: 'Rasmiy manba',
                        color: AppColors.goldAccent,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(item.title, style: AppTextStyles.sectionTitle),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    const Icon(
                      LucideIcons.calendar,
                      size: 14,
                      color: AppColors.mutedText,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        item.date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ),
                    const Icon(
                      LucideIcons.eye,
                      size: 14,
                      color: AppColors.mutedText,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${item.viewsCount} ko\'rildi',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: isSaved ? 'Saqlangan' : 'Saqlash',
            icon: isSaved ? LucideIcons.check : LucideIcons.bookmark,
            variant: isSaved
                ? AppButtonVariant.secondary
                : AppButtonVariant.ghost,
            isExpanded: true,
            onPressed: isSaving ? null : onSaveTap,
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Yangilik matni', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 8),
                Text(
                  item.content.trim().isEmpty ? item.description : item.content,
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
                  LucideIcons.badgeCheck,
                  color: AppColors.primaryBlue,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Rasmiy manba: Gazgan City',
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

class _NewsDetailScaffold extends StatelessWidget {
  const _NewsDetailScaffold({required this.child});

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
                    'Yangilik',
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
