import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/services/phone_launcher_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import 'data/jobs_repository.dart';
import 'models/job_item.dart';
import 'widgets/service_call_feedback.dart';
import 'widgets/service_catalog_scaffold.dart';
import 'widgets/service_info_card.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key, this.repository, this.phoneLauncher});

  final JobsRepository? repository;
  final PhoneLauncherService? phoneLauncher;

  @override
  Widget build(BuildContext context) {
    final jobsRepository = repository ?? JobsRepository();
    final launcher = phoneLauncher ?? const PhoneLauncherService();

    return ServiceCatalogScaffold<JobItem>(
      title: 'Ish o\'rinlari',
      subtitle: 'G\'ozg\'on shahridagi faol bo\'sh ish o\'rinlari',
      loadingTitle: 'Ish o\'rinlari yuklanmoqda',
      loadingMessage: 'Faol bo\'sh ish o\'rinlari tayyorlanmoqda.',
      emptyTitle: 'Ish o\'rinlari topilmadi',
      emptyMessage: 'Hozircha faol ish o\'rinlari mavjud emas.',
      loadItems: jobsRepository.fetchJobsResult,
      itemBuilder: (context, item) {
        return ServiceInfoCard(
          title: item.title,
          subtitle: item.organization,
          phone: item.phone,
          description: item.description,
          icon: LucideIcons.briefcase,
          badge: item.salary.trim().isEmpty ? 'Ish' : item.salary,
          onTap: () => _showJobDetails(context, item, launcher),
          onCall: () => callWithFeedback(context, launcher, item.phone),
        );
      },
    );
  }
}

void _showJobDetails(
  BuildContext context,
  JobItem item,
  PhoneLauncherService phoneLauncher,
) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderGray,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.title, style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 8),
                    _DetailLine(
                      icon: LucideIcons.building2,
                      text: item.organization.trim().isEmpty
                          ? 'Tashkilot kiritilmagan'
                          : item.organization,
                    ),
                    const SizedBox(height: 6),
                    _DetailLine(
                      icon: LucideIcons.wallet,
                      text: item.salary.trim().isEmpty
                          ? 'Maosh kelishiladi'
                          : item.salary,
                    ),
                    const SizedBox(height: 6),
                    _DetailLine(
                      icon: LucideIcons.phone,
                      text: item.phone.trim().isEmpty
                          ? 'Telefon raqam kiritilmagan'
                          : item.phone,
                    ),
                    if (item.description.trim().isNotEmpty) ...<Widget>[
                      const SizedBox(height: 14),
                      Text(item.description, style: AppTextStyles.body),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Qo\'ng\'iroq',
                icon: LucideIcons.phoneCall,
                isExpanded: true,
                onPressed: item.phone.trim().isEmpty
                    ? null
                    : () =>
                          callWithFeedback(context, phoneLauncher, item.phone),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 16, color: AppColors.mutedText),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMuted,
          ),
        ),
      ],
    );
  }
}
