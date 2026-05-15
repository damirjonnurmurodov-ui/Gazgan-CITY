import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../auth/data/auth_repository.dart';
import '../auth/models/auth_user.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_support_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.repository});

  final AuthRepository? repository;

  @override
  Widget build(BuildContext context) {
    final authRepository = repository ?? SupabaseAuthRepository();

    return StreamBuilder<AuthUser?>(
      stream: authRepository.authStateChanges,
      initialData: authRepository.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 128),
            children: <Widget>[
              _HeaderRow(),
              const SizedBox(height: 6),
              Text(
                user == null
                    ? 'Shaxsiy kabinetdan foydalanish uchun tizimga kiring'
                    : 'Shaxsiy kabinet va foydali bo\'limlar',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMuted,
              ),
              const SizedBox(height: 18),
              if (user == null)
                const _SignedOutCard()
              else
                _SignedInContent(user: user, onLogout: authRepository.signOut),
              const SizedBox(height: 24),
              const ProfileSupportCard(),
            ],
          ),
        );
      },
    );
  }
}

class _SignedOutCard extends StatelessWidget {
  const _SignedOutCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  LucideIcons.user,
                  color: AppColors.primaryBlue,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Profilga kiring',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'E\'lon berish va saqlanganlarni ko\'rish uchun login kerak.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: AppButton(
                  label: 'Kirish',
                  icon: LucideIcons.logIn,
                  isExpanded: true,
                  onPressed: () => context.push('/login'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: 'Ro\'yxatdan o\'tish',
                  icon: LucideIcons.userPlus,
                  variant: AppButtonVariant.secondary,
                  isExpanded: true,
                  onPressed: () => context.push('/register'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ProfileMenuGroup(
            title: 'Sozlamalar',
            items: <Widget>[
              ProfileMenuItem(
                icon: LucideIcons.globe,
                label: 'Til',
                trailingText: 'O\'zbekcha',
              ),
              ProfileMenuItem(
                icon: LucideIcons.fileText,
                label: 'Foydalanish shartlari',
              ),
              ProfileMenuItem(
                icon: LucideIcons.shield,
                label: 'Maxfiylik siyosati',
              ),
              ProfileMenuItem(
                icon: LucideIcons.info,
                label: 'Ilova versiyasi',
                trailingText: 'v1.0.0',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignedInContent extends StatelessWidget {
  const _SignedInContent({required this.user, required this.onLogout});

  final AuthUser user;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ProfileHeaderCard(name: user.displayName, contact: user.contactLabel),
        const SizedBox(height: 16),
        _ActionButtonsRow(
          onEdit: () => debugPrint('Edit profile'),
          onPhoto: () => debugPrint('Change photo'),
          onSettings: () => debugPrint('Settings'),
        ),
        const SizedBox(height: 24),
        ProfileMenuGroup(
          title: 'Asosiy',
          items: <Widget>[
            const ProfileMenuItem(
              icon: LucideIcons.user,
              label: 'Shaxsiy ma\'lumotlar',
            ),
            ProfileMenuItem(
              icon: LucideIcons.megaphone,
              label: 'Mening e\'lonlarim',
              onTap: () => context.push('/my-listings'),
            ),
            ProfileMenuItem(
              icon: LucideIcons.bookmark,
              label: 'Saqlanganlar',
              onTap: () => context.push('/saved'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ProfileMenuGroup(
          title: 'Xabarlar va yordam',
          items: <Widget>[
            ProfileMenuItem(
              icon: LucideIcons.messageSquare,
              label: 'Admin xabarlari',
              onTap: () => context.push('/admin-messages'),
            ),
            const ProfileMenuItem(
              icon: LucideIcons.send,
              label: 'Telegram orqali yordam',
            ),
          ],
        ),
        const SizedBox(height: 20),
        ProfileMenuGroup(
          title: 'Sozlamalar',
          items: <Widget>[
            const ProfileMenuItem(
              icon: LucideIcons.globe,
              label: 'Til',
              trailingText: 'O\'zbekcha',
            ),
            ProfileMenuItem(
              icon: LucideIcons.fileText,
              label: 'Foydalanish shartlari',
              onTap: () => context.push('/terms'),
            ),
            ProfileMenuItem(
              icon: LucideIcons.shield,
              label: 'Maxfiylik siyosati',
              onTap: () => context.push('/privacy'),
            ),
            const ProfileMenuItem(
              icon: LucideIcons.info,
              label: 'Ilova versiyasi',
              trailingText: 'v1.0.0',
            ),
          ],
        ),
        const SizedBox(height: 20),
        ProfileMenuItem(
          icon: LucideIcons.logOut,
          label: 'Chiqish',
          isDestructive: true,
          onTap: () async => onLogout(),
        ),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'Profil',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.screenTitle,
          ),
        ),
        _IconButton(
          icon: LucideIcons.bell,
          onTap: () => debugPrint('Notifications'),
        ),
        const SizedBox(width: 8),
        _IconButton(
          icon: LucideIcons.settings,
          onTap: () => debugPrint('Settings'),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.marbleGray,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: AppColors.darkNavy),
        ),
      ),
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  const _ActionButtonsRow({this.onEdit, this.onPhoto, this.onSettings});

  final VoidCallback? onEdit;
  final VoidCallback? onPhoto;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _ActionButton(
            icon: LucideIcons.pencil,
            label: 'Tahrirlash',
            onTap: onEdit,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: LucideIcons.camera,
            label: 'Rasm tanlash',
            onTap: onPhoto,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: LucideIcons.settings2,
            label: 'Sozlamalar',
            onTap: onSettings,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.marbleGray,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 20, color: AppColors.primaryBlue),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.darkNavy,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
