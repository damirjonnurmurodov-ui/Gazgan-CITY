import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';

class ReceptionCard extends StatelessWidget {
  const ReceptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: <Widget>[
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.goldAccent.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              LucideIcons.calendar,
              color: AppColors.goldAccent,
              size: 34,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Hokim sayyor qabuli',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: 5),
                Text(
                  'Marmarobod MFY',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMuted,
                ),
                const SizedBox(height: 7),
                Row(
                  children: <Widget>[
                    const Icon(
                      LucideIcons.clock,
                      color: AppColors.mutedText,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Bugun, 15:00',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 170,
            child: Column(
              children: <Widget>[
                AppButton(
                  label: "Ro'yxatdan o'tish",
                  icon: LucideIcons.chevronRight,
                  isExpanded: true,
                  onPressed: () {},
                ),
                const SizedBox(height: 8),
                AppButton(
                  label: "Xaritada ko'rish",
                  icon: LucideIcons.map,
                  variant: AppButtonVariant.ghost,
                  isExpanded: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
