import 'package:flutter/material.dart';

import 'quick_action_card.dart';

export 'quick_action_card.dart' show QuickActionItem;

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({
    super.key,
    required this.items,
  });

  final List<QuickActionItem> items;

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
            mainAxisExtent: 108,
          ),
          itemBuilder: (context, index) {
            return QuickActionCard(item: items[index]);
          },
        );
      },
    );
  }
}
