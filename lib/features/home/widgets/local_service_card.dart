import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LocalServiceItem {
  const LocalServiceItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

class LocalServiceGrid extends StatelessWidget {
  const LocalServiceGrid({
    super.key,
    required this.items,
  });

  final List<LocalServiceItem> items;

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
            mainAxisExtent: 64,
          ),
          itemBuilder: (context, index) {
            return LocalServiceCard(item: items[index]);
          },
        );
      },
    );
  }
}

class LocalServiceCard extends StatelessWidget {
  const LocalServiceCard({
    super.key,
    required this.item,
  });

  final LocalServiceItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(item.icon, color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
