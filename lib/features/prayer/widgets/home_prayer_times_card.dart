import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/prayer_times_repository.dart';
import '../models/prayer_time.dart';

class HomePrayerTimesCard extends StatefulWidget {
  const HomePrayerTimesCard({super.key, this.repository});

  final PrayerTimesRepository? repository;

  @override
  State<HomePrayerTimesCard> createState() => _HomePrayerTimesCardState();
}

class _HomePrayerTimesCardState extends State<HomePrayerTimesCard> {
  late final PrayerTimesRepository _repository;
  late final Future<DailyPrayerTimes> _future;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? PrayerTimesRepository();
    _future = _repository.fetchTodayPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DailyPrayerTimes>(
      future: _future,
      initialData: PrayerTimesRepository.defaultGazganTimes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _PrayerCardShell(
            onTap: () => context.push('/prayer-times'),
            child: Row(
              children: <Widget>[
                const _DecorativeIcon(),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Namoz vaqtlari vaqtincha mavjud emas',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  color: AppColors.goldAccent,
                ),
              ],
            ),
          );
        }

        final times =
            snapshot.data ?? PrayerTimesRepository.defaultGazganTimes();
        return _PrayerTimesContent(
          times: times,
          onTap: () => context.push('/prayer-times'),
        );
      },
    );
  }
}

class _PrayerTimesContent extends StatelessWidget {
  const _PrayerTimesContent({required this.times, required this.onTap});

  final DailyPrayerTimes times;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final featured = times.featuredPrayer;
    final next = times.nextAfterFeatured;

    return _PrayerCardShell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _DecorativeIcon(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Namoz vaqtlari',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        const Icon(
                          LucideIcons.mapPin,
                          size: 14,
                          color: AppColors.mutedText,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            times.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const _LocationPill(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      featured.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.goldAccent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      featured.time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.largeTitle.copyWith(
                        color: AppColors.goldAccent,
                        fontSize: 36,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Keyingi: ${next.name} ${next.time}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.darkNavy,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _AllTimesButton(onTap: onTap),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrayerCardShell extends StatelessWidget {
  const _PrayerCardShell({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFFFFFCF3), Color(0xFFFFF4D8)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.goldAccent.withValues(alpha: 0.42),
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _DecorativeIcon extends StatelessWidget {
  const _DecorativeIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.32)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: const <Widget>[
          Icon(LucideIcons.landmark, color: AppColors.goldAccent, size: 25),
          Positioned(
            right: 11,
            top: 10,
            child: Icon(
              LucideIcons.moon,
              color: AppColors.primaryBlue,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationPill extends StatelessWidget {
  const _LocationPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.24)),
      ),
      child: Text(
        'Joylashuv asosida',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.goldAccent,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _AllTimesButton extends StatelessWidget {
  const _AllTimesButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.goldAccent.withValues(alpha: 0.32),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Barcha vaqtlar',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.darkNavy,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              LucideIcons.chevronRight,
              color: AppColors.goldAccent,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
