import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// خانواده‌ی فونت سراسری؛ فایل‌های آن در `pubspec.yaml` تعریف شده‌اند.
abstract final class AppFonts {
  static const String family = 'IRANYekan';
}

/// اعداد خام مقیاس تایپوگرافی.
///
/// جایی که فقط عدد لازم است (مثلاً `fontSize` در یک `TextStyle` اختصاصی فیچر)
/// از همین ثابت‌ها گرفته می‌شود تا عدد در کل برنامه یکی بماند.
abstract final class AppTextSize {
  static const double display = 24;
  static const double section = 20;
  static const double cardTitle = 18;
  static const double body = 14;
  static const double button = 15;
  static const double caption = 13;
  static const double error = 12;
  static const double number = 28;
}

/// مقیاس تایپوگرافی مشترک هر چهار صفحه.
///
/// هر فیچر به‌جای اختراع اندازه‌ی جدید، یکی از همین نقش‌ها را انتخاب می‌کند.
/// همه ثابت‌اند تا بتوان در ویجت‌های `const` مستقیم به کارشان برد؛
/// رنگ فقط آن‌جا عوض می‌شود که پالت اختصاصی فیچر لازم دارد.
abstract final class AppText {
  /// عنوان صفحه.
  static const TextStyle display = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.display,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  /// عنوان بخش.
  static const TextStyle section = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.section,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  /// عنوان کارت یا گروه.
  static const TextStyle cardTitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.cardTitle,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// متن اصلی.
  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.body,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// متن اصلیِ برجسته.
  static const TextStyle strong = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.body,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// زیرعنوان صفحه، دقیقاً زیر عنوان.
  static const TextStyle pageSubtitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.body,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// توضیح کم‌رنگ زیر عنوان‌ها و ردیف‌ها.
  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.caption,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// برچسب دکمه‌ها.
  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.button,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.15,
  );

  /// متن داخل فیلد.
  static const TextStyle field = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.body,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// راهنمای داخل فیلد.
  static const TextStyle hint = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.caption,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// برچسب برچسک‌ها، بج‌ها و پیوندهای ریز.
  static const TextStyle badge = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.caption,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// پیام خطای زیر فیلد.
  static const TextStyle error = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.error,
    fontWeight: FontWeight.w500,
    color: AppColors.danger,
    height: 1.2,
  );

  /// عدد بزرگ (قیمت، درصد و مانند آن).
  static const TextStyle number = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: AppTextSize.number,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );
}
