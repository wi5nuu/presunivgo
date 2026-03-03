import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Outfit for Headings (Modern/Tech)
  static TextStyle get display => GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      );

  // Inter for Body (Clean/Readable)
  static TextStyle get body => GoogleFonts.inter(
        color: AppColors.textPrimary,
      );

   static TextStyle get mono => GoogleFonts.jetBrainsMono(
        color: AppColors.textPrimary,
      );
}
