import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.royalBlue,
        primary: AppColors.royalBlue,
        onPrimary: AppColors.surface,
        secondary: AppColors.accentBlue,
        surface: AppColors.background,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.surface,
        centerTitle: false,
        elevation: 0,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.display.copyWith(fontSize: 32),
        displayMedium: AppTypography.display.copyWith(fontSize: 28),
        displaySmall: AppTypography.display.copyWith(fontSize: 24),
        bodyLarge: AppTypography.body.copyWith(fontSize: 16),
        bodyMedium: AppTypography.body.copyWith(fontSize: 14),
        labelLarge: AppTypography.body
            .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.royalBlue,
          foregroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    // Basic dark theme impl for completeness
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: AppColors.royalBlue,
        primary: AppColors.royalBlue,
      ),
    );
  }
}
