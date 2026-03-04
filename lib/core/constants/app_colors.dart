import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand
  static const navy = Color(0xFF0A1931);
  static const royalBlue = Color(0xFF185ADB);
  static const accentBlue = Color(0xFF1F6FEB);

  // Semantic Colors
  static const success = Color(0xFF16C79A);
  static const warning = Color(0xFFFFA726);
  static const error = Color(0xFFEF5350);
  static const info = Color(0xFF42A5F5);

  // Neutral Scale
  static const background = Color(0xFFF5F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFEEF2F7);
  static const border = Color(0xFFE2E8F0);

  // Text Scale
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textHint = Color(0xFF94A3B8);

  // Role Colors
  static const studentColor = Color(0xFF6366F1);
  static const alumniColor = Color(0xFF0EA5E9);
  static const lecturerColor = Color(0xFF10B981);
  static const adminColor = Color(0xFFF59E0B);

  // Backward compatibility alias (to not break everything immediately)
  static const primary = royalBlue;
  static const secondary = accentBlue;
  static const divider = border;
  static const cyberMagenta = royalBlue;
  static const electricNavy = navy;
}
