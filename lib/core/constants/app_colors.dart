import 'package:flutter/material.dart';

class AppColors {
  // Premium Theme (Vibrant Magenta & White)
  // Based on high-fidelity social networking reference
  static const primary = Color(0xFFE91E63); // Vibrant Magenta
  static const primaryDark = Color(0xFFC2185B);
  static const secondary = Color(0xFFF06292); // Lighter Pink
  static const accent = Color(0xFFFF4081); // Bright Pink Accent

  static const background = Color(0xFFF8F9FA); // Ultra-light neutral background
  static const surface = Color(0xFFFFFFFF); // Pure White Cards
  static const surfaceVariant =
      Color(0xFFFFF1F5); // Very soft pink tint for highlights

  // Brand / Semantic
  static const navy = Color(0xFF880E4F); // Deep Magenta for solid headers
  static const royalBlue = Color(0xFFE91E63); // Reusing Primary
  static const orange = Color(0xFFFF8911); // Professional Warning/Action

  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFD32F2F);
  static const info = Color(0xFF2196F3);

  // Neutral Scale
  static const border = Color(0xFFEEEEEE);
  static const divider = Color(0xFFF5F5F5);

  // Text Scale (High Contrast for Professor Review)
  static const textPrimary = Color(0xFF1A1A1A); // Almost Black
  static const textSecondary = Color(0xFF616161); // Dark Grey
  static const textHint = Color(0xFF9E9E9E); // Medium Grey
  static const textOnDark = Color(0xFFFFFFFF); // Pure White on Pink

  // Gradients
  static const primaryGradient = [Color(0xFFE91E63), Color(0xFFF06292)];
  static const darkGradient = [Color(0xFF880E4F), Color(0xFFC2185B)];
}
