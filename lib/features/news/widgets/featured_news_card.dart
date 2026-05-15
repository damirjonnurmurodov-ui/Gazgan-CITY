import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/news_item.dart';

class FeaturedNewsCard extends StatelessWidget {
  const FeaturedNewsCard({
    super.key,
    required this.item,
    this.onTap,
    this.onDetailsTap,
  });

  final NewsItem item;
  final VoidCallback? onTap;
  final VoidCallback? onDetailsTap;

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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _FeaturedImage(color: item.imageColor, icon: item.icon),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.goldAccent.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        LucideIcons.star,
                        size: 12,
                        color: AppColors.goldAccent,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Asosiy xabar',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.goldAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMuted.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    const Icon(
                      LucideIcons.calendar,
                      size: 13,
                      color: AppColors.mutedText,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        item.date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      LucideIcons.eye,
                      size: 13,
                      color: AppColors.mutedText,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${item.viewsCount}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(width: 10),
                    TextButton.icon(
                      onPressed: onDetailsTap,
                      icon: const Icon(LucideIcons.arrowRight, size: 16),
                      label: const Text('Batafsil'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryBlue,
                        textStyle: AppTextStyles.button.copyWith(fontSize: 14),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedImage extends StatelessWidget {
  const _FeaturedImage({required this.color, required this.icon});
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.15)),
        child: Stack(
          children: <Widget>[
            Center(
              child: Icon(icon, size: 64, color: color.withValues(alpha: 0.45)),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      color.withValues(alpha: 0.6),
                      color.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
