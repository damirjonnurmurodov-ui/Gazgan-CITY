import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/data/repository_result.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_state_card.dart';
import '../../core/widgets/data_status_banner.dart';
import '../auth/data/auth_repository.dart';
import '../auth/models/auth_user.dart';
import 'data/listings_repository.dart';
import 'models/listing_item.dart';
import 'widgets/listing_card.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key, this.repository, this.authRepository});

  final ListingsRepository? repository;
  final AuthRepository? authRepository;

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  late final ListingsRepository _repository;
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? ListingsRepository();
    _authRepository = widget.authRepository ?? SupabaseAuthRepository();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser?>(
      stream: _authRepository.authStateChanges,
      initialData: _authRepository.currentUser,
      builder: (context, authSnapshot) {
        final user = authSnapshot.data;
        if (user == null) {
          return _MyListingsScaffold(
            child: AppStateCard(
              title: 'Mening e\'lonlarim uchun tizimga kiring',
              message:
                  'Shaxsiy e\'lonlaringizni ko\'rish uchun akkauntingizga kiring.',
              icon: LucideIcons.lock,
              actionLabel: 'Kirish',
              onActionTap: () {
                final redirect = Uri.encodeComponent('/my-listings');
                context.push('/login?redirect=$redirect');
              },
            ),
          );
        }

        return FutureBuilder<RepositoryResult<List<ListingItem>>>(
          future: _repository.fetchMyListingsResult(user.id),
          builder: (context, snapshot) {
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final result = snapshot.data;
            final listings = result?.data ?? const <ListingItem>[];

            if (isLoading && result == null) {
              return const _MyListingsScaffold(
                child: AppStateCard(
                  title: 'E\'lonlar yuklanmoqda',
                  message: 'Siz qo\'shgan e\'lonlar ro\'yxati tayyorlanmoqda.',
                  icon: LucideIcons.loader,
                  isLoading: true,
                ),
              );
            }

            return _MyListingsScaffold(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (result != null && result.isFallback) ...<Widget>[
                    DataStatusBanner(message: result.message!),
                    const SizedBox(height: 14),
                  ],
                  if (listings.isEmpty)
                    AppStateCard(
                      title: 'Hali e\'lon yo\'q',
                      message:
                          'Yangi e\'lon qo\'shganingizdan so\'ng u shu yerda pending holatda ko\'rinadi.',
                      icon: LucideIcons.megaphone,
                      actionLabel: 'Yangi e\'lon qo\'shish',
                      onActionTap: () => context.push('/create-listing'),
                    )
                  else
                    ...List<Widget>.generate(listings.length, (index) {
                      final listing = listings[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index < listings.length - 1 ? 12 : 0,
                        ),
                        child: ListingCard(
                          item: listing,
                          onTap: () => context.push(
                            '/listing-detail/${listing.id}',
                            extra: listing,
                          ),
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _MyListingsScaffold extends StatelessWidget {
  const _MyListingsScaffold({required this.child});

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
                Expanded(
                  child: Text(
                    'Mening e\'lonlarim',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.screenTitle,
                  ),
                ),
                AppButton(
                  label: 'Yangi',
                  icon: LucideIcons.plus,
                  onPressed: () => context.push('/create-listing'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Qo\'shgan e\'lonlaringiz va moderatsiya holati',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}
