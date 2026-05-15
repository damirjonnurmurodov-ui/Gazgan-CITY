import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';

class ServiceInfoCard extends StatelessWidget {
  const ServiceInfoCard({
    super.key,
    required this.title,
    required this.phone,
    required this.description,
    required this.icon,
    this.badge,
    this.subtitle,
    this.official = false,
    this.onCall,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final String? badge;
  final String phone;
  final String description;
  final IconData icon;
  final bool official;
  final VoidCallback? onCall;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: official ? AppColors.lightBlue : AppColors.marbleGray,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, size: 24, color: AppColors.primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle,
                    ),
                    if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (badge != null && badge!.trim().isNotEmpty) ...<Widget>[
                const SizedBox(width: 8),
                _Badge(label: badge!, official: official),
              ],
            ],
          ),
          if (description.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMuted,
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              const Icon(
                LucideIcons.phone,
                size: 15,
                color: AppColors.mutedText,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  phone.trim().isEmpty ? 'Telefon raqam kiritilmagan' : phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.darkNavy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Qo\'ng\'iroq',
            icon: LucideIcons.phoneCall,
            isExpanded: true,
            onPressed: phone.trim().isEmpty ? null : onCall,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.official});

  final String label;
  final bool official;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 104),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: official ? AppColors.goldAccent : AppColors.lightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: official ? AppColors.darkNavy : AppColors.primaryBlue,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
