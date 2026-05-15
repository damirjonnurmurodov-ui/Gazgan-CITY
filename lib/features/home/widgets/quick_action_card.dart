import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class QuickActionItem {
  const QuickActionItem({required this.icon, required this.label, this.route});

  final IconData icon;
  final String label;
  final String? route;
}

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key, required this.item});

  final QuickActionItem item;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(item.icon, color: AppColors.primaryBlue, size: 28),
          const SizedBox(height: 8),
          Flexible(
            child: Center(
              child: Text(
                item.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: 13,
                  height: 1.18,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final route = item.route;
    if (route == null || route.isEmpty) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(route),
        child: card,
      ),
    );
  }
}
