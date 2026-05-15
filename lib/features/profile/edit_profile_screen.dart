import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/storage/image_picker_service.dart';
import '../../core/storage/image_upload_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_state_card.dart';
import '../auth/data/auth_repository.dart';
import '../auth/models/auth_user.dart';
import 'data/profile_repository.dart';
import 'models/user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    this.authRepository,
    this.profileRepository,
    this.imagePicker,
    this.imageUploadRepository,
  });

  final AuthRepository? authRepository;
  final ProfileRepository? profileRepository;
  final AppImagePicker? imagePicker;
  final ImageUploadRepository? imageUploadRepository;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  late final AuthRepository _authRepository;
  late final ProfileRepository _profileRepository;
  late final AppImagePicker _imagePicker;
  late final ImageUploadRepository _imageUploadRepository;
  late final Future<UserProfile?> _profileFuture;

  LocalImageFile? _selectedAvatar;
  String? _errorMessage;
  String? _successMessage;
  String? _avatarMessage;
  bool _isSaving = false;
  bool _isPicking = false;
  bool _didBindProfile = false;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? SupabaseAuthRepository();
    _profileRepository = widget.profileRepository ?? ProfileRepository();
    _imagePicker = widget.imagePicker ?? DeviceImagePicker();
    _imageUploadRepository =
        widget.imageUploadRepository ?? ImageUploadRepository();
    _profileFuture = _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<UserProfile?> _loadProfile() async {
    final user = _authRepository.currentUser;
    if (user == null) return null;

    final profile = await _profileRepository.fetchProfile(user.id);
    return profile ?? _profileFromAuthUser(user);
  }

  void _bindProfile(UserProfile profile) {
    if (_didBindProfile) return;
    _didBindProfile = true;
    _nameController.text = profile.fullName ?? '';
    _phoneController.text = profile.phone ?? '';
    _addressController.text = profile.address ?? '';
  }

  Future<void> _pickAvatar() async {
    setState(() {
      _isPicking = true;
      _avatarMessage = null;
    });

    try {
      final image = await _imagePicker.pickImage();
      if (!mounted || image == null) return;
      setState(() {
        _selectedAvatar = image;
        _avatarMessage = 'Rasm tanlandi.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _avatarMessage = 'Rasm tanlab bo\'lmadi.';
      });
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  Future<void> _save(UserProfile initialProfile) async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Ism familiya bo\'sh bo\'lmasin.';
        _successMessage = null;
      });
      return;
    }

    if (phone.isNotEmpty && !_isValidPhone(phone)) {
      setState(() {
        _errorMessage = 'Telefon raqamini to\'g\'ri formatda kiriting.';
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
      _successMessage = null;
    });

    String? avatarUrl = initialProfile.avatarUrl;
    String? avatarWarning;
    final selectedAvatar = _selectedAvatar;
    if (selectedAvatar != null) {
      final uploadResult = await _imageUploadRepository.uploadProfileAvatar(
        userId: initialProfile.id,
        file: selectedAvatar,
      );
      if (uploadResult.isSuccess) {
        avatarUrl = uploadResult.publicUrl;
      } else {
        avatarWarning = uploadResult.message;
      }
    }

    try {
      await _profileRepository.upsertProfile(
        UserProfile(
          id: initialProfile.id,
          fullName: name,
          phone: phone.isEmpty ? null : phone,
          address: address.isEmpty ? null : address,
          avatarUrl: avatarUrl,
        ),
      );

      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
        return;
      }

      setState(() {
        _successMessage = avatarWarning ?? 'Profil saqlandi.';
        _avatarMessage = avatarWarning;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Profilni saqlab bo\'lmadi. Keyinroq urinib ko\'ring.';
      });
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: <Widget>[
            _EditHeader(onBack: () => Navigator.of(context).maybePop()),
            const SizedBox(height: 18),
            FutureBuilder<UserProfile?>(
              future: _profileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AppStateCard(
                    title: 'Profil yuklanmoqda',
                    message: 'Shaxsiy ma\'lumotlar tayyorlanmoqda.',
                    icon: LucideIcons.loader,
                    isLoading: true,
                  );
                }

                final profile = snapshot.data;
                if (profile == null) {
                  return const AppStateCard(
                    title: 'Tizimga kirish kerak',
                    message: 'Profilni tahrirlash uchun avval kiring.',
                    icon: LucideIcons.lock,
                  );
                }

                _bindProfile(profile);
                return _EditForm(
                  nameController: _nameController,
                  phoneController: _phoneController,
                  addressController: _addressController,
                  profile: profile,
                  isPicking: _isPicking,
                  isSaving: _isSaving,
                  errorMessage: _errorMessage,
                  successMessage: _successMessage,
                  avatarMessage: _avatarMessage,
                  hasSelectedAvatar: _selectedAvatar != null,
                  onPickAvatar: _isSaving ? null : _pickAvatar,
                  onSave: _isSaving ? null : () => _save(profile),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EditHeader extends StatelessWidget {
  const _EditHeader({required this.onBack});

  final VoidCallback onBack;

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
          child: Text(
            'Profilni tahrirlash',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.screenTitle,
          ),
        ),
      ],
    );
  }
}

class _EditForm extends StatelessWidget {
  const _EditForm({
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.profile,
    required this.isPicking,
    required this.isSaving,
    required this.hasSelectedAvatar,
    required this.onPickAvatar,
    required this.onSave,
    this.errorMessage,
    this.successMessage,
    this.avatarMessage,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final UserProfile profile;
  final bool isPicking;
  final bool isSaving;
  final bool hasSelectedAvatar;
  final VoidCallback? onPickAvatar;
  final VoidCallback? onSave;
  final String? errorMessage;
  final String? successMessage;
  final String? avatarMessage;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _AvatarPreview(
                avatarUrl: profile.avatarUrl,
                hasSelectedAvatar: hasSelectedAvatar,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Profil rasmi', style: AppTextStyles.cardTitle),
                    const SizedBox(height: 4),
                    Text(
                      'Rasm ixtiyoriy. Profil ma\'lumotlari rasmsiz ham saqlanadi.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      label: isPicking ? 'Tanlanmoqda...' : 'Rasm tanlash',
                      icon: LucideIcons.camera,
                      variant: AppButtonVariant.ghost,
                      onPressed: onPickAvatar,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (avatarMessage != null) ...<Widget>[
            const SizedBox(height: 10),
            _StatusText(message: avatarMessage!, isError: true),
          ],
          const SizedBox(height: 18),
          _ProfileTextField(
            controller: nameController,
            label: 'Ism familiya',
            icon: LucideIcons.user,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          _ProfileTextField(
            controller: phoneController,
            label: 'Telefon',
            icon: LucideIcons.phone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          _ProfileTextField(
            controller: addressController,
            label: 'Mahalla yoki manzil',
            icon: LucideIcons.mapPin,
            textInputAction: TextInputAction.done,
          ),
          if (errorMessage != null) ...<Widget>[
            const SizedBox(height: 12),
            _StatusText(message: errorMessage!, isError: true),
          ],
          if (successMessage != null) ...<Widget>[
            const SizedBox(height: 12),
            _StatusText(message: successMessage!, isError: false),
          ],
          const SizedBox(height: 18),
          AppButton(
            label: isSaving ? 'Saqlanmoqda...' : 'Saqlash',
            icon: LucideIcons.save,
            isExpanded: true,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}

class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview({
    required this.avatarUrl,
    required this.hasSelectedAvatar,
  });

  final String? avatarUrl;
  final bool hasSelectedAvatar;

  @override
  Widget build(BuildContext context) {
    final url = avatarUrl?.trim();
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        color: hasSelectedAvatar ? AppColors.lightBlue : AppColors.marbleGray,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderGray),
      ),
      clipBehavior: Clip.antiAlias,
      child: url == null || url.isEmpty
          ? Icon(
              hasSelectedAvatar ? LucideIcons.check : LucideIcons.user,
              color: AppColors.primaryBlue,
              size: 32,
            )
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  LucideIcons.user,
                  color: AppColors.primaryBlue,
                  size: 32,
                );
              },
            ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.textInputAction,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText({required this.message, required this.isError});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.caption.copyWith(
        color: isError ? AppColors.redDanger : AppColors.greenSuccess,
      ),
    );
  }
}

UserProfile _profileFromAuthUser(AuthUser user) {
  return UserProfile(
    id: user.id,
    fullName: user.fullName,
    phone: user.phone,
  );
}

bool _isValidPhone(String phone) {
  return RegExp(r'^\+?[0-9\s()-]{7,20}$').hasMatch(phone);
}
