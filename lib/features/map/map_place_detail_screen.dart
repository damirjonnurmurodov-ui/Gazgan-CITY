import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/data/repository_result.dart';
import '../../core/services/phone_launcher_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_state_card.dart';
import '../../core/widgets/data_status_banner.dart';
import '../services/widgets/service_call_feedback.dart';
import 'data/map_places_repository.dart';
import 'models/map_place.dart';

class MapPlaceDetailScreen extends StatefulWidget {
  const MapPlaceDetailScreen({
    super.key,
    required this.placeId,
    this.initialPlace,
    this.repository,
    this.phoneLauncher,
  });

  final String placeId;
  final MapPlace? initialPlace;
  final MapPlacesRepository? repository;
  final PhoneLauncherService? phoneLauncher;

  @override
  State<MapPlaceDetailScreen> createState() => _MapPlaceDetailScreenState();
}

class _MapPlaceDetailScreenState extends State<MapPlaceDetailScreen> {
  late final MapPlacesRepository _repository;
  late final PhoneLauncherService _phoneLauncher;
  late final Future<RepositoryResult<MapPlace?>>? _placeFuture;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? MapPlacesRepository();
    _phoneLauncher = widget.phoneLauncher ?? const PhoneLauncherService();
    _placeFuture = widget.initialPlace == null
        ? _repository.fetchPlaceDetailResult(widget.placeId)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialPlace != null) {
      return _MapPlaceDetailBody(
        place: widget.initialPlace!,
        phoneLauncher: _phoneLauncher,
      );
    }

    return FutureBuilder<RepositoryResult<MapPlace?>>(
      future: _placeFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final result = snapshot.data;
        final place = result?.data;

        if (isLoading) {
          return const _MapPlaceDetailScaffold(
            child: AppStateCard(
              title: 'Joy ma\'lumotlari yuklanmoqda',
              message: 'Xarita obyekti bo\'yicha ma\'lumotlar tayyorlanmoqda.',
              icon: LucideIcons.loader,
              isLoading: true,
            ),
          );
        }

        if (place == null) {
          return _MapPlaceDetailScaffold(
            child: AppStateCard(
              title: 'Joy topilmadi',
              message: result?.message ?? 'Bu xarita obyekti mavjud emas.',
              icon: LucideIcons.searchX,
              actionLabel: 'Ortga qaytish',
              onActionTap: () => context.pop(),
            ),
          );
        }

        return _MapPlaceDetailBody(
          place: place,
          fallbackMessage: result?.message,
          phoneLauncher: _phoneLauncher,
        );
      },
    );
  }
}

class _MapPlaceDetailBody extends StatelessWidget {
  const _MapPlaceDetailBody({
    required this.place,
    required this.phoneLauncher,
    this.fallbackMessage,
  });

  final MapPlace place;
  final PhoneLauncherService phoneLauncher;
  final String? fallbackMessage;

  @override
  Widget build(BuildContext context) {
    return _MapPlaceDetailScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (fallbackMessage != null) ...<Widget>[
            DataStatusBanner(message: fallbackMessage!),
            const SizedBox(height: 12),
          ],
          AppCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _PlaceVisual(place: place),
                const SizedBox(height: 14),
                _Badge(label: place.category),
                const SizedBox(height: 12),
                Text(place.name, style: AppTextStyles.sectionTitle),
                const SizedBox(height: 12),
                _DetailLine(icon: LucideIcons.mapPin, text: place.address),
                const SizedBox(height: 8),
                _DetailLine(
                  icon: LucideIcons.phone,
                  text: place.phone.trim().isEmpty
                      ? 'Telefon raqam kiritilmagan'
                      : place.phone,
                ),
                if (place.description.trim().isNotEmpty) ...<Widget>[
                  const SizedBox(height: 14),
                  Text(place.description, style: AppTextStyles.body),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Qo\'ng\'iroq',
            icon: LucideIcons.phoneCall,
            isExpanded: true,
            onPressed: place.phone.trim().isEmpty
                ? null
                : () => callWithFeedback(context, phoneLauncher, place.phone),
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Yo\'nalish',
            icon: LucideIcons.navigation,
            variant: AppButtonVariant.ghost,
            isExpanded: true,
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

class _PlaceVisual extends StatelessWidget {
  const _PlaceVisual({required this.place});

  final MapPlace place;

  @override
  Widget build(BuildContext context) {
    final imageUrl = place.imageUrl?.trim();
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.network(
          imageUrl,
          height: 170,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _IconVisual(place: place),
        ),
      );
    }

    return _IconVisual(place: place);
  }
}

class _IconVisual extends StatelessWidget {
  const _IconVisual({required this.place});

  final MapPlace place;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Icon(place.icon, size: 64, color: AppColors.primaryBlue),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 16, color: AppColors.mutedText),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMuted,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MapPlaceDetailScaffold extends StatelessWidget {
  const _MapPlaceDetailScaffold({required this.child});

  final Widget child;

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
                  child: Text(
                    'Joy detali',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.screenTitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}
