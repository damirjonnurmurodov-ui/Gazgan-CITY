import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_state_card.dart';

class MobileReceptionsScreen extends StatelessWidget {
  const MobileReceptionsScreen({super.key});

  static const List<_ReceptionItem> _items = <_ReceptionItem>[
    _ReceptionItem(
      title: 'Hokim sayyor qabuli',
      address: 'Marmarobod MFY, 12-maktab binosi',
      dateTime: 'Bugun, 15:00',
      responsible: 'Shahar hokimligi mas\'ul xodimi',
      status: 'Rejalashtirilgan',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: <Widget>[
            Row(
              children: <Widget>[
                AppButton(
                  label: 'Ortga',
                  icon: LucideIcons.chevronLeft,
                  variant: AppButtonVariant.ghost,
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Sayyor qabullar',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.screenTitle,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'G\'ozg\'on shahri bo\'yicha rejalashtirilgan qabullar',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (_items.isEmpty)
              const AppStateCard(
                title: 'Hozircha sayyor qabullar mavjud emas',
                message: 'Yangi qabullar e\'lon qilinganda shu yerda chiqadi.',
                icon: LucideIcons.calendarX,
              )
            else
              ..._items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ReceptionListCard(item: item),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReceptionListCard extends StatelessWidget {
  const _ReceptionListCard({required this.item});

  final _ReceptionItem item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  LucideIcons.users,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle,
                ),
              ),
              const SizedBox(width: 8),
              _StatusPill(label: item.status),
            ],
          ),
          const SizedBox(height: 14),
          _InfoLine(icon: LucideIcons.mapPin, text: item.address),
          const SizedBox(height: 8),
          _InfoLine(icon: LucideIcons.clock, text: item.dateTime),
          const SizedBox(height: 8),
          _InfoLine(icon: LucideIcons.userCheck, text: item.responsible),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 17, color: AppColors.primaryBlue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body,
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.goldAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.goldAccent,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ReceptionItem {
  const _ReceptionItem({
    required this.title,
    required this.address,
    required this.dateTime,
    required this.responsible,
    required this.status,
  });

  final String title;
  final String address;
  final String dateTime;
  final String responsible;
  final String status;
}
