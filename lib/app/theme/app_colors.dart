import 'package:flutter/material.dart';

/// رنگ‌های پایه‌ی برند. برای هماهنگی با پروژه‌ی اصلی، فقط همین فایل را تغییر دهید.
abstract final class AppColors {
  static const Color primary = Color(0xFF0F7A73);
  static const Color primaryDark = Color(0xFF0A5B56);
  static const Color primarySoft = Color(0xFFE4F1EF);

  static const Color accent = Color(0xFFF2A33C);
  static const Color accentSoft = Color(0xFFFDF1DE);

  static const Color background = Color(0xFFF4F6F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);

  /// خط دور پررنگ‌تر برای دکمه‌های outlined.
  static const Color borderStrong = Color(0xFFC9CFE0);

  static const Color textPrimary = Color(0xFF16263C);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF2E9E6B);
  static const Color danger = Color(0xFFD9534F);
}
