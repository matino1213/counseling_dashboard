import 'package:flutter/widgets.dart';

import '../responsive/responsive.dart';

/// مقیاس فاصله: `mobile` برای گوشی، `desktop` برای ویندوز/تبلت افقی.
class Spacing {
  const Spacing(this.mobile, this.desktop);

  final double mobile;
  final double desktop;

  double resolve(BuildContext context) => context.isCompact ? mobile : desktop;
}

/// اندازه‌های پایه‌ی سراسری برنامه.
abstract final class AppSizes {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  static const double radiusSm = 10;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusPill = 999;

  /// شعاع‌های نقش‌محور؛ همه‌ی کارت‌ها و کنترل‌ها از همین سه عددند.
  static const double radiusCard = radiusLg;
  static const double radiusControl = 12;
  static const double radiusChip = 8;

  /// حداقل ابعاد لمسی.
  static const double touchTarget = 44;

  /// ارتفاع دکمه بر پایه‌ی نقش؛ چهار صفحه دقیقاً همین سه عدد را به کار می‌برند:
  /// `sm` کنش کم‌رنگ سرصفحه و چیپ، `md` کنش داخل کارت، `lg` فراخوان اصلی صفحه.
  static const double buttonHeightSm = touchTarget;
  static const double buttonHeightMd = 48;
  static const double buttonHeightLg = 52;

  /// ارتفاع برچسب‌های کوچک (وضعیت روی تصویر، بج کنار عنوان).
  static const double pillHeight = 26;
  static const double pillHeightSm = 22;

  /// ارتفاع مشترک نوارهای پیشرفت.
  static const double progressHeight = 12;

  /// ضخامت خط دور دکمه‌های رنگی داخل کارت.
  static const double buttonBorderWidth = 1.4;

  /// هندسه‌ی مشترک فیلدهای متنی.
  static const double fieldHeight = 52;
  static const double searchFieldHeight = 44;
  static const double fieldIconBox = 40;
  static const double fieldIconSize = 20;

  /// عرض کنترل‌های نوار فیلتر؛ در صفحه‌ی دوره‌ها و آزمون‌ها یکی است.
  static const double searchFieldWidth = 290;
  static const double sortButtonWidth = 182;

  /// آیکون کنار عنوان صفحه و آیکون داخل دکمه‌ها.
  static const double titleIconSize = 26;
  static const double buttonIconSize = 20;

  /// آیکون داخل بج‌ها و چیپ‌ها.
  static const double badgeIconSize = 16;

  static const EdgeInsets fieldPadding =
      EdgeInsets.symmetric(horizontal: lg, vertical: 14);

  /// فیلدهای فشرده‌ی نوار فیلتر: فقط حاشیه‌ی افقی، چون ارتفاع از بیرون داده
  /// می‌شود.
  static const EdgeInsets fieldPaddingCompact =
      EdgeInsets.symmetric(horizontal: md);

  static const pagePadding = Spacing(lg, xl);
  static const contentMaxWidth =
      Responsive<double>(double.infinity, expanded: 1080);

  static const menuColumns = Responsive<int>(1, medium: 2, expanded: 2);
  static const menuGap = Spacing(md, lg);
  static const iconBox = Spacing(46, 54);
}
