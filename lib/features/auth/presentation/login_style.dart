import 'package:flutter/material.dart';

import '../../../app/theme/app_sizes.dart';

/// پالت رنگی صفحه‌ی ورود؛ مقدارها مستقیماً از طرح (بوم ۱۲۸۰) نمونه‌برداری شده‌اند.
abstract final class LoginColors {
  static const Color primary = Color(0xFF1477FF);
  static const Color primaryDeep = Color(0xFF0D79FF);
  static const Color logoBlue = Color(0xFF107AFD);
  static const Color logoPurple = Color(0xFF5542FA);

  static const Color ink = Color(0xFF0A1A55);
  static const Color inkSoft = Color(0xFF0C2357);
  static const Color muted = Color(0xFF7987A4);
  static const Color faint = Color(0xFFB4BACD);

  static const Color card = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFE1E7F1);

  static const Color infoBg = Color(0xFFEDF4FE);
  static const Color greenBg = Color(0xFFEEF9F9);
  static const Color green = Color(0xFF0D9A4E);
  static const Color greenIcon = Color(0xFF16A34A);
  static const Color danger = Color(0xFFD9534F);

  static const Color heroTop = Color(0xFFF2F6FD);
  static const Color heroLeft = Color(0xFFDBE6FC);
  static const Color heroBottom = Color(0xFFC7D4F5);
  static const Color heroGlow = Color(0xFFD9CBF6);

  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [logoBlue, logoPurple],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF1E86FF), Color(0xFF0F6BF5)],
  );
}

/// فاصله‌ها و اندازه‌های اختصاصی صفحه‌ی ورود (بوم ۱۲۸۰، پیکسل‌به‌پیکسل).
///
/// ارتفاع و شعاع کنترل‌ها از [AppSizes] می‌آید تا با بقیه‌ی صفحه‌ها یکی باشد.
abstract final class LoginSizes {
  static const double cardWidth = 539;
  static const double cardRadius = AppSizes.radiusCard;
  static const double cardPadding = 38;

  static const double logoSize = 32;
  static const double boxRadius = AppSizes.radiusControl;
  static const double boxHeight = 72;
  static const double fieldHeight = AppSizes.fieldHeight;
  static const double buttonHeight = AppSizes.buttonHeightLg;
  static const double buttonRadius = AppSizes.radiusControl;
  static const double checkboxSize = 23;

  static const double heroCardHeight = 105;
  static const double heroIconTile = 34;
  static const double heroTextMaxWidth = 480;
}
