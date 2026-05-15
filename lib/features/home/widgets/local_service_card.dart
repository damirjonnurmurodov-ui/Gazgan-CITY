import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LocalServiceItem {
  const LocalServiceItem({required this.icon, required this.label, this.route});

  final IconData icon;
  final String label;
  final String? route;
}

class LocalServiceGrid extends StatelessWidget {
  const LocalServiceGrid({super.key, required this.items});

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
  const LocalServiceCard({super.key, required this.item});

  final LocalServiceItem item;

  @override
  Widget build(BuildContext context) {
    final card = Container(
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

    final route = item.route;
    if (route == null || route.isEmpty) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push(route),
        child: card,
      ),
    );
  }
}
