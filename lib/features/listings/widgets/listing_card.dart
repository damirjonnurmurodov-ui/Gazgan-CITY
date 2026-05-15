import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/listing_item.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.item,
    this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  final ListingItem item;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.7)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ListingImage(
                  color: item.imageColor,
                  icon: item.icon,
                  imageUrl: item.imageUrl,
                  isFeatured: item.isFeatured,
                  isOfficial: item.isOfficial,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _ListingInfo(
                    item: item,
                    isFavorite: isFavorite,
                    onFavoriteTap: onFavoriteTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListingImage extends StatelessWidget {
  const _ListingImage({
    required this.color,
    required this.icon,
    this.imageUrl,
    required this.isFeatured,
    required this.isOfficial,
  });

  final Color color;
  final IconData icon;
  final String? imageUrl;
  final bool isFeatured;
  final bool isOfficial;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: imageUrl == null || imageUrl!.trim().isEmpty
              ? Icon(icon, size: 42, color: color.withValues(alpha: 0.65))
              : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      icon,
                      size: 42,
                      color: color.withValues(alpha: 0.65),
                    );
                  },
                ),
        ),
        if (isFeatured)
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.goldAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Premium',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        if (isOfficial)
          Positioned(
            bottom: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    LucideIcons.badgeCheck,
                    size: 10,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'Rasmiy',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ListingInfo extends StatelessWidget {
  const _ListingInfo({
    required this.item,
    required this.isFavorite,
    this.onFavoriteTap,
  });

  final ListingItem item;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onFavoriteTap,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isFavorite
                      ? AppColors.redDanger.withValues(alpha: 0.1)
                      : AppColors.marbleGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isFavorite ? LucideIcons.heart : LucideIcons.heartOff,
                  size: 16,
                  color: isFavorite ? AppColors.redDanger : AppColors.mutedText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.marbleGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            item.category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primaryBlue,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.price,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.primaryBlue,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: <Widget>[
            const Icon(
              LucideIcons.mapPin,
              size: 12,
              color: AppColors.mutedText,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                item.location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: <Widget>[
            const Icon(LucideIcons.clock, size: 12, color: AppColors.mutedText),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                item.date,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(LucideIcons.eye, size: 12, color: AppColors.mutedText),
            const SizedBox(width: 4),
            Text(
              '${item.viewsCount}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption,
            ),
            if (item.status != ListingStatus.active) ...<Widget>[
              const SizedBox(width: 8),
              Flexible(child: _StatusBadge(status: item.statusLabel)),
            ],
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.goldAccent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.goldAccent,
          fontSize: 10,
        ),
      ),
    );
  }
}
