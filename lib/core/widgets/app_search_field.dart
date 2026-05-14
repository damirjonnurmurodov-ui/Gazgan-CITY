import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/app_colors.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onFilterTap,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(
          LucideIcons.search,
          color: AppColors.mutedText,
          size: 20,
        ),
        suffixIcon: onFilterTap == null
            ? null
            : IconButton(
                tooltip: 'Filtr',
                onPressed: onFilterTap,
                icon: const Icon(
                  LucideIcons.slidersHorizontal,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
      ),
    );
  }
}
