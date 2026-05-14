import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CompactNewsItem {
  const CompactNewsItem({
    required this.title,
    required this.category,
    required this.date,
  });

  final String title;
  final String category;
  final String date;
}

class CompactNewsCard extends StatelessWidget {
  const CompactNewsCard({
    super.key,
    required this.item,
  });

  final CompactNewsItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGray),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              LucideIcons.newspaper,
              color: AppColors.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              item.title,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.darkNavy,
                fontSize: 13,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: <Widget>[
              const Icon(
                LucideIcons.calendarDays,
                color: AppColors.mutedText,
                size: 13,
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
            ],
          ),
        ],
      ),
    );
  }
}
