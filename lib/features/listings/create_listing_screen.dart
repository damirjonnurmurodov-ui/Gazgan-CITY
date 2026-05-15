import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/data/repository_result.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_state_card.dart';
import '../auth/data/auth_repository.dart';
import '../auth/models/auth_user.dart';
import 'data/listings_repository.dart';
import 'models/listing_item.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key, this.repository, this.authRepository});

  final ListingsRepository? repository;
  final AuthRepository? authRepository;

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategoryKey;
  String? _errorMessage;
  bool _isSubmitting = false;

  late final ListingsRepository _repository;
  late final AuthRepository _authRepository;
  late final Future<RepositoryResult<List<ListingCategory>>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? ListingsRepository();
    _authRepository = widget.authRepository ?? SupabaseAuthRepository();
    _categoriesFuture = _repository.fetchCategoriesResult();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthUser user, List<ListingCategory> categories) async {
    final title = _titleController.text.trim();
    final phone = _phoneController.text.trim();
    final description = _descriptionController.text.trim();
    final category = _selectedCategory(categories);

    if (title.isEmpty ||
        phone.isEmpty ||
        description.isEmpty ||
        category == null) {
      setState(() {
        _errorMessage =
            'Sarlavha, kategoriya, telefon va tavsif maydonlarini to\'ldiring.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await _repository.createListing(
        CreateListingInput(
          userId: user.id,
          categoryId: category.id,
          title: title,
          description: description,
          price: _priceController.text,
          location: _locationController.text,
          phone: phone,
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E\'lon moderatsiyaga yuborildi.')),
      );
      context.go('/my-listings');
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'E\'lonni saqlab bo\'lmadi. Keyinroq qayta urinib ko\'ring.';
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  ListingCategory? _selectedCategory(List<ListingCategory> categories) {
    final key = _selectedCategoryKey;
    if (key == null) return null;
    return categories
        .where((category) => _categoryKey(category) == key)
        .firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    final user = _authRepository.currentUser;

    if (user == null) {
      return _CreateListingScaffold(
        child: AppStateCard(
          title: 'E\'lon berish uchun tizimga kiring',
          message:
              'Yangi e\'lon qo\'shish faqat ro\'yxatdan o\'tgan foydalanuvchilar uchun.',
          icon: LucideIcons.lock,
          actionLabel: 'Kirish',
          onActionTap: () {
            final redirect = Uri.encodeComponent('/create-listing');
            context.push('/login?redirect=$redirect');
          },
        ),
      );
    }

    return FutureBuilder<RepositoryResult<List<ListingCategory>>>(
      future: _categoriesFuture,
      initialData: const RepositoryResult.live(
        ListingsRepository.fallbackCategories,
      ),
      builder: (context, snapshot) {
        final categories =
            snapshot.data?.data ?? ListingsRepository.fallbackCategories;

        return _CreateListingScaffold(
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Yangi e\'lon', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 14),
                _FormTextField(
                  controller: _titleController,
                  label: 'Sarlavha',
                  icon: LucideIcons.megaphone,
                ),
                const SizedBox(height: 12),
                _CategoryDropdown(
                  categories: categories,
                  value: _selectedCategoryKey,
                  onChanged: (value) {
                    setState(() => _selectedCategoryKey = value);
                  },
                ),
                const SizedBox(height: 12),
                _FormTextField(
                  controller: _priceController,
                  label: 'Narx',
                  icon: LucideIcons.badgeDollarSign,
                ),
                const SizedBox(height: 12),
                _FormTextField(
                  controller: _locationController,
                  label: 'Manzil',
                  icon: LucideIcons.mapPin,
                ),
                const SizedBox(height: 12),
                _FormTextField(
                  controller: _phoneController,
                  label: 'Telefon',
                  icon: LucideIcons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _FormTextField(
                  controller: _descriptionController,
                  label: 'Tavsif',
                  icon: LucideIcons.fileText,
                  maxLines: 4,
                ),
                if (_errorMessage != null) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.redDanger,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                AppButton(
                  label: _isSubmitting
                      ? 'Yuborilmoqda...'
                      : 'E\'lonni yuborish',
                  icon: LucideIcons.send,
                  isExpanded: true,
                  onPressed: _isSubmitting
                      ? null
                      : () => _submit(user, categories),
                ),
                const SizedBox(height: 10),
                Text(
                  'E\'lon pending holatda saqlanadi va tasdiqlangandan keyin ko\'rinadi.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CreateListingScaffold extends StatelessWidget {
  const _CreateListingScaffold({required this.child});

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
                    'E\'lon berish',
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

class _FormTextField extends StatelessWidget {
  const _FormTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textInputAction: maxLines > 1
          ? TextInputAction.newline
          : TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.categories,
    required this.value,
    required this.onChanged,
  });

  final List<ListingCategory> categories;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: categories
          .map(
            (category) => DropdownMenuItem<String>(
              value: _categoryKey(category),
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Kategoriya',
        prefixIcon: Icon(LucideIcons.layers, size: 20),
      ),
    );
  }
}

String _categoryKey(ListingCategory category) => category.id ?? category.name;
