import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/news_item.dart';

class NewsListCard extends StatelessWidget {
  const NewsListCard({super.key, required this.item, this.onTap});

  final NewsItem item;
  final VoidCallback? onTap;

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
                _NewsImage(
                  color: item.imageColor,
                  icon: item.icon,
                  isOfficial: item.isOfficial,
                ),
                const SizedBox(width: 14),
                Expanded(child: _NewsContent(item: item)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewsImage extends StatelessWidget {
  const _NewsImage({
    required this.color,
    required this.icon,
    required this.isOfficial,
  });
  final Color color;
  final IconData icon;
  final bool isOfficial;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 30, color: color.withValues(alpha: 0.55)),
        ),
        if (isOfficial)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                LucideIcons.badgeCheck,
                size: 12,
                color: AppColors.white,
              ),
            ),
          ),
      ],
    );
  }
}

class _NewsContent extends StatelessWidget {
  const _NewsContent({required this.item});
  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 6),
        Text(
          item.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(LucideIcons.clock, size: 11, color: AppColors.mutedText),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                item.date,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(fontSize: 11),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(LucideIcons.eye, size: 11, color: AppColors.mutedText),
            const SizedBox(width: 3),
            Text(
              '${item.viewsCount}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}
