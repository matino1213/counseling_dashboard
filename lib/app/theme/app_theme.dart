import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_text.dart';

/// تم سراسری برنامه؛ راست‌چین، فارسی، با چگالی جدا برای ویندوز و گوشی.
abstract final class AppTheme {
  static ThemeData light() {
    final isDesktop = !kIsWeb &&
        const {
          TargetPlatform.windows,
          TargetPlatform.linux,
          TargetPlatform.macOS
        }.contains(defaultTargetPlatform);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      secondary: AppColors.accent,
      onSecondary: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.danger,
    ).copyWith(brightness: Brightness.light);

    final base =
        ThemeData(colorScheme: colorScheme, useMaterial3: true).textTheme;

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: isDesktop ? VisualDensity.compact : VisualDensity.standard,
      textTheme: base.apply(
          fontFamily: AppFonts.family,
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary),
      cardTheme: CardTheme(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(
          color: AppColors.border, thickness: 1, space: 1),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.primary,
        textColor: AppColors.textPrimary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppSizes.buttonHeightLg),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusControl)),
          textStyle: AppText.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppSizes.buttonHeightMd),
          side: const BorderSide(color: AppColors.border),
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusControl)),
          textStyle: AppText.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(0, AppSizes.buttonHeightSm),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusControl)),
          textStyle: AppText.button,
        ),
      ),
      // همه‌ی فیلدهای متنی برنامه از همین قالب پیروی می‌کنند.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: AppSizes.fieldPadding,
        hintStyle: AppText.hint,
        labelStyle: AppText.hint,
        floatingLabelStyle: const TextStyle(color: AppColors.primary),
        errorStyle: AppText.error,
        enabledBorder: _fieldBorder(AppColors.border),
        focusedBorder: _fieldBorder(AppColors.primary, width: 1.6),
        errorBorder: _fieldBorder(AppColors.danger),
        focusedErrorBorder: _fieldBorder(AppColors.danger, width: 1.6),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: TextStyle(color: AppColors.surface),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusControl),
        borderSide: BorderSide(color: color, width: width),
      );
}

/// اسکرول با کشیدن ماوس در ویندوز، همراه با رفتار لمسی گوشی.
/// در Flutter 3.24 از طریق ScrollConfiguration در ریشه‌ی برنامه نصب می‌شود.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}
