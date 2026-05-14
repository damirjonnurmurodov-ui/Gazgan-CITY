import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class UsefulSectionItem {
  const UsefulSectionItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

class UsefulSectionGrid extends StatelessWidget {
  const UsefulSectionGrid({
    super.key,
    required this.items,
  });

  final List<UsefulSectionItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 340 ? 2 : 4;

        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 88,
          ),
          itemBuilder: (context, index) {
            return UsefulSectionCard(item: items[index]);
          },
        );
      },
    );
  }
}

class UsefulSectionCard extends StatelessWidget {
  const UsefulSectionCard({
    super.key,
    required this.item,
  });

  final UsefulSectionItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(item.icon, color: AppColors.primaryBlue, size: 24),
          const SizedBox(height: 7),
          Flexible(
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
