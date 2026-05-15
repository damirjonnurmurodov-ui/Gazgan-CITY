import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_state_card.dart';
import 'data/prayer_times_repository.dart';
import 'models/prayer_time.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key, this.repository});

  final PrayerTimesRepository? repository;

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late final PrayerTimesRepository _repository;
  late Future<DailyPrayerTimes> _future;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? PrayerTimesRepository();
    _future = _repository.fetchTodayPrayerTimes();
  }

  void _refresh() {
    setState(() {
      _future = _repository.fetchTodayPrayerTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: <Widget>[
            _Header(onBack: () => context.pop(), onRefresh: _refresh),
            const SizedBox(height: 18),
            FutureBuilder<DailyPrayerTimes>(
              future: _future,
              initialData: PrayerTimesRepository.defaultGazganTimes(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return AppStateCard(
                    title: 'Namoz vaqtlari vaqtincha mavjud emas',
                    message:
                        'Default vaqtlar ham yuklanmadi. Keyinroq qayta urinib ko\'ring.',
                    icon: LucideIcons.alertCircle,
                    actionLabel: 'Yangilash',
                    onActionTap: _refresh,
                  );
                }

                final day =
                    snapshot.data ?? PrayerTimesRepository.defaultGazganTimes();
                final next = _repository.getCurrentOrNextPrayer(day);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _LocationCard(day: day),
                    const SizedBox(height: 14),
                    _SummaryCard(next: next),
                    const SizedBox(height: 14),
                    _PrayerList(times: day.times, highlighted: next),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack, required this.onRefresh});

  final VoidCallback onBack;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        AppButton(
          label: 'Ortga',
          icon: LucideIcons.chevronLeft,
          variant: AppButtonVariant.ghost,
          onPressed: onBack,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Namoz vaqtlari',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.screenTitle,
              ),
              const SizedBox(height: 3),
              Text(
                'Joylashuvingizga qarab kunlik namoz vaqtlari',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _RefreshButton(onTap: onRefresh),
      ],
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.marbleGray,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(11),
          child: Icon(
            LucideIcons.refreshCw,
            size: 20,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.day});

  final DailyPrayerTimes day;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.marbleGray,
      borderColor: AppColors.borderGray,
      child: Row(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              LucideIcons.mapPin,
              color: AppColors.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  day.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(day.date),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
                if (day.isDefaultLocation) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    "Default G'ozg'on vaqtlari ko'rsatilmoqda.",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.goldAccent,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.next});

  final PrayerTime next;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.lightBlue,
      borderColor: AppColors.primaryBlue.withValues(alpha: 0.16),
      child: Row(
        children: <Widget>[
          const Icon(LucideIcons.clock, color: AppColors.primaryBlue, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Keyingi namoz',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 4),
                Text(
                  next.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          Text(
            next.time,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.largeTitle.copyWith(
              color: AppColors.primaryBlue,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerList extends StatelessWidget {
  const _PrayerList({required this.times, required this.highlighted});

  final List<PrayerTime> times;
  final PrayerTime highlighted;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: times
            .map(
              (time) => _PrayerRow(
                time: time,
                isHighlighted: time.name == highlighted.name,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({required this.time, required this.isHighlighted});

  final PrayerTime time;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final color = isHighlighted ? AppColors.goldAccent : AppColors.darkNavy;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.goldAccent.withValues(alpha: 0.12)
            : AppColors.marbleGray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            isHighlighted ? LucideIcons.badgeCheck : LucideIcons.clock3,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              time.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            time.time,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardTitle.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}
