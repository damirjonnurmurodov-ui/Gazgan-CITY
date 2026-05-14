import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get largeTitle => GoogleFonts.inter(
        fontSize: 32,
        height: 1.15,
        fontWeight: FontWeight.w800,
        color: AppColors.darkNavy,
      );

  static TextStyle get screenTitle => GoogleFonts.inter(
        fontSize: 26,
        height: 1.2,
        fontWeight: FontWeight.w800,
        color: AppColors.darkNavy,
      );

  static TextStyle get sectionTitle => GoogleFonts.inter(
        fontSize: 20,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: AppColors.darkNavy,
      );

  static TextStyle get cardTitle => GoogleFonts.inter(
        fontSize: 17,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: AppColors.darkNavy,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 15,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: AppColors.darkNavy,
      );

  static TextStyle get bodyMuted => GoogleFonts.inter(
        fontSize: 15,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: AppColors.mutedText,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: AppColors.mutedText,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 15,
        height: 1.2,
        fontWeight: FontWeight.w700,
      );
}
