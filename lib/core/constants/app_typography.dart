import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // DM Serif Display for Headings
  static TextStyle get display => GoogleFonts.dmSerifDisplay(
        color: AppColors.textPrimary,
      );

  // Plus Jakarta Sans for Body
  static TextStyle get body => GoogleFonts.plusJakartaSans(
        color: AppColors.textPrimary,
      );

  // JetBrains Mono for Code/IDs
  static TextStyle get mono => GoogleFonts.jetBrainsMono(
        color: AppColors.textPrimary,
      );

  // High-contrast variants for specific UI elements
  static TextStyle get bodySecondary => GoogleFonts.plusJakartaSans(
        color: AppColors.textSecondary,
        fontSize: 14,
      );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        color: AppColors.textHint,
        fontSize: 12,
      );
}
