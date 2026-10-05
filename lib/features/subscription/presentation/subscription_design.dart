import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_sizes.dart';
import '../../../app/theme/app_text.dart';

/// رنگ‌های اختصاصی صفحه‌ی اشتراک؛ عیناً از طرح مرجس گرفته شده‌اند.
abstract final class SubColors {
  static const Color mintPage = Color(0xFFF3FAF8);
  static const Color mintCardTop = Color(0xFFF1FBF6);
  static const Color mintCardBottom = Color(0xFFE8F7F0);
  static const Color mintDivider = Color(0xFFD8EAE2);

  static const Color green = Color(0xFF0D945D);
  static const Color greenTop = Color(0xFF12A063);
  static const Color greenBottom = Color(0xFF0A8B57);
  static const Color greenTrack = Color(0xFFD2ECE2);
  static const Color greenTint = Color(0xFFE3F6EC);

  static const Color gold = Color(0xFFD7951F);
  static const Color goldBright = Color(0xFFF5A61D);
  static const Color goldBorder = Color(0xFFE8B04E);
  static const Color goldRing = Color(0xFFF3C878);
  static const Color goldTint = Color(0xFFFDF9F1);
  static const Color goldBubble = Color(0xFFFEF3DC);
  static const Color cream = Color(0xFFFFF9EE);

  static const Color violet = Color(0xFF7C3AED);
  static const Color violetTint = Color(0xFFF4EDFD);

  static const Color blue = Color(0xFF2492FB);
  static const Color blueTint = Color(0xFFE5F4FD);

  static const Color tableHeader = Color(0xFFF2F5F8);
  static const Color tableLine = Color(0xFFEDF0F4);

  static const Color danger = AppColors.danger;
  static const Color ink = AppColors.textPrimary;
  static const Color muted = AppColors.textSecondary;
}

/// اندازه‌های ثابت صفحه‌ی اشتراک (پیکسل‌های طرح مرجع در عرض ۱۰۸۴).
///
/// ارتفاع و شعاع کنترل‌ها از [AppSizes] می‌آید تا با سه صفحه‌ی دیگر یکسان بماند.
abstract final class SubSizes {
  static const double cardRadius = AppSizes.radiusCard;
  static const double chipRadius = AppSizes.radiusChip;
  static const double bubbleRadius = AppSizes.radiusSm;
  static const double buttonRadius = AppSizes.radiusControl;

  static const double cardPadding = AppSizes.xl;
  static const double sectionGap = AppSizes.xl;
  static const double planGap = AppSizes.md;

  static const double headerCrown = AppSizes.titleIconSize;
  static const double statusHeight = 126;
  static const double statusCircle = 88;
  static const double statusPillHeight = AppSizes.pillHeight;
  static const double tierPillHeight = AppSizes.pillHeightSm;
  static const double progressHeight = AppSizes.progressHeight;

  static const double planBubble = 56;
  static const double planButtonHeight = AppSizes.buttonHeightMd;
  static const double planBadgeHeight = AppSizes.pillHeight;
  static const double planStarCircle = 32;

  static const double tableHeadingHeight = 60;
  static const double tableHeaderRow = 45;
  static const double tableRow = 35;
  static const double tableRowTall = 45;
  static const double tableIconBubble = 32;

  static const double bannerHeight = 102;
  static const double bannerButtonHeight = AppSizes.buttonHeightMd;
  static const double bannerArtHeight = 100;

  /// کمینه‌ی عرض ستون‌ها وقتی جدول در حالت اسکرول افقی است.
  static const double minFeatureColumn = 168;
  static const double minPlanColumn = 112;
}

/// ارقام فارسی برای تبدیل عدد انگلیسی به رشته‌ی خوانا.
const List<String> _faDigits = [
  '۰',
  '۱',
  '۲',
  '۳',
  '۴',
  '۵',
  '۶',
  '۷',
  '۸',
  '۹'
];

/// عدد را با ارقام فارسی و جداکننده‌ی هزارگان می‌نویسد: ۱,۶۹۰,۰۰۰
String faNumber(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  final remainder = digits.length % 3;
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (i - remainder) % 3 == 0) buffer.write(',');
    buffer.write(_faDigits[digits.codeUnitAt(i) - 0x30]);
  }
  return buffer.toString();
}

/// سبک‌های متنی صفحه‌ی اشتراک؛ همه از مقیاس مشترک `AppText` می‌آیند و
/// فقط رنگ پالت این صفحه را می‌گیرند. پارامتر `context` برای سازگاری با
/// فراخوان‌ها نگه داشته شده است.
abstract final class SubText {
  static TextStyle _ink(TextStyle base) => base.copyWith(color: SubColors.ink);
  static TextStyle _muted(TextStyle base) =>
      base.copyWith(color: SubColors.muted);

  static TextStyle pageTitle(BuildContext context) => _ink(AppText.display);

  static TextStyle pageSubtitle(BuildContext context) =>
      _muted(AppText.pageSubtitle);

  static TextStyle sectionTitle(BuildContext context) => _ink(AppText.section);

  static TextStyle tierName(BuildContext context) => _ink(AppText.number);

  static TextStyle cardTitle(BuildContext context) => _ink(AppText.cardTitle);

  static TextStyle planName(BuildContext context) => _ink(AppText.cardTitle);

  static TextStyle caption(BuildContext context) => _muted(AppText.caption);

  static TextStyle body(BuildContext context) => _muted(AppText.body);

  static TextStyle price(BuildContext context) =>
      _ink(AppText.number).copyWith(fontSize: 34);

  static TextStyle unit(BuildContext context) => _muted(AppText.body);

  static TextStyle button(BuildContext context) => AppText.button;

  static TextStyle pill(BuildContext context) => AppText.badge;

  static TextStyle tableHeading(BuildContext context) => _ink(AppText.section);

  static TextStyle tableHeaderCell(BuildContext context) =>
      _ink(AppText.cardTitle);

  static TextStyle tableCell(BuildContext context) =>
      _ink(AppText.body).copyWith(fontWeight: FontWeight.w600);

  static TextStyle featureLabel(BuildContext context) => _ink(AppText.strong);

  static TextStyle featureHint(BuildContext context) => _muted(AppText.caption);

  static TextStyle bannerTitle(BuildContext context) =>
      AppText.section.copyWith(color: SubColors.greenBottom);

  static TextStyle guide(BuildContext context) => _ink(AppText.body);
}
