import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_support_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 128),
        children: <Widget>[
          _HeaderRow(),
          const SizedBox(height: 6),
          Text(
            'Shaxsiy kabinet va foydali bo\'limlar',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: 18),
          const ProfileHeaderCard(),
          const SizedBox(height: 16),
          _ActionButtonsRow(
            onEdit: () => debugPrint('Edit profile'),
            onPhoto: () => debugPrint('Change photo'),
            onSettings: () => debugPrint('Settings'),
          ),
          const SizedBox(height: 24),
          const ProfileMenuGroup(
            title: 'Asosiy',
            items: <Widget>[
              ProfileMenuItem(
                icon: LucideIcons.user,
                label: 'Shaxsiy ma\'lumotlar',
              ),
              ProfileMenuItem(
                icon: LucideIcons.megaphone,
                label: 'Mening e\'lonlarim',
              ),
              ProfileMenuItem(
                icon: LucideIcons.bookmark,
                label: 'Saqlanganlar',
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ProfileMenuGroup(
            title: 'Xabarlar va hamkorlik',
            items: <Widget>[
              ProfileMenuItem(
                icon: LucideIcons.messageSquare,
                label: 'Admin xabarlari',
              ),
              ProfileMenuItem(
                icon: LucideIcons.briefcase,
                label: 'Biznes hamkorlik',
              ),
              ProfileMenuItem(
                icon: LucideIcons.send,
                label: 'Telegram orqali yordam',
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
          const SizedBox(height: 20),
          const ProfileMenuItem(
            icon: LucideIcons.logOut,
            label: 'Chiqish',
            isDestructive: true,
          ),
          const SizedBox(height: 24),
          const ProfileSupportCard(),
        ],
      ),
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
  const _ActionButtonsRow({
    this.onEdit,
    this.onPhoto,
    this.onSettings,
  });

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
  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

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
