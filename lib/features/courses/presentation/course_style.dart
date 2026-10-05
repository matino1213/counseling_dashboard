import 'package:flutter/material.dart';

import '../../../app/responsive/responsive.dart';
import '../../../app/theme/app_sizes.dart';
import '../../../app/theme/app_text.dart';
import '../domain/course.dart';

/// پالت رنگی صفحه‌ی «دوره‌های من»؛ همه‌ی مقدارها از طرح نمونه‌برداری شده‌اند.
abstract final class CourseColors {
  static const Color pageBackground = Color(0xFFF3FAFA);
  static const Color surface = Color(0xFFFFFFFF);

  /// خط دور روشنِ کادرها و جداکننده‌ها.
  static const Color border = Color(0xFFE7EDF2);

  /// خط دور دکمه‌های بدون رنگ (مثل «شروع دوره»); پررنگ‌تر از [border].
  static const Color buttonBorder = Color(0xFF6B7690);

  static const Color ink = Color(0xFF0B1030);
  static const Color inkSoft = Color(0xFF5A6488);
  static const Color inkMedium = Color(0xFF3A416B);

  /// سبز اصلی: برچسب فعال، دکمه‌ها و پیشرفت.
  static const Color green = Color(0xFF08A165);
  static const Color greenDeep = Color(0xFF0A9160);
  static const Color greenOutline = Color(0xFF45B086);
  static const Color greenInk = Color(0xFF006F3A);
  static const Color greenSoft = Color(0xFFE0F9EE);
  static const Color bannerLeft = Color(0xFFEAF9F2);
  static const Color bannerRight = Color(0xFFF2FBF7);

  static const Color blue = Color(0xFF0B62F5);
  static const Color blueSoft = Color(0xFFE4F1FE);
  static const Color graySoft = Color(0xFFEEF2F4);

  /// رنگ دو طرف نوار پیشرفت.
  static const Color progressTrack = Color(0xFFD9ECE3);
  static const Color progressFill = Color(0xFF0DA969);

  /// دکمه‌ی خاکستری «دریافت گواهی».
  static const Color certificateBackground = Color(0xFFEEF1F7);

  /// بنر: سمت چپ پررنگ‌تر و سمت راست روشن‌تر است، همان‌طور که در طرح آمده.
  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [bannerLeft, bannerRight],
  );
}

/// اندازه‌های صفحه‌ی «دوره‌های من» (بوم ۱۳۸۰×۱۱۴۰، پیکسل‌به‌پیکسل).
///
/// ارتفاع و شعاع کنترل‌ها از [AppSizes] می‌آید تا با بقیه‌ی صفحه‌ها یکسان بماند؛
/// اندازه‌های متنی هم همان نقش‌های `AppText` را عددی می‌کنند.
abstract final class CourseSizes {
  static const double contentMaxWidth = 1091;
  static const Responsive<double> pagePadding =
      Responsive<double>(16, expanded: 24);

  static const double pageTitleSize = AppTextSize.display;
  static const double pageSubtitleSize = AppTextSize.body;
  static const double titleIconSize = AppSizes.titleIconSize;
  static const double viewAllHeight = AppSizes.buttonHeightSm;

  static const double bannerHeight = 163;
  static const double bannerRadius = AppSizes.radiusCard;
  static const double bannerArtInset = 6;
  static const double bannerArtWidth = 373;
  static const double bannerArtRadius = AppSizes.radiusMd;

  /// ارتفاع تصویر بنر؛ با حاشیه‌ی ۶ و خط دور ۱ مجموعاً ۱۶۳ می‌شود.
  static const double bannerArtHeight = 149;
  static const double bannerStartPadding = 18;
  static const double bannerInnerGap = 14;
  static const double bannerTextPadding = 16;
  static const double bannerPlaySize = 46;
  static const double bannerTitleSize = AppTextSize.section;
  static const double bannerBodySize = AppTextSize.body;
  static const double bannerCtaWidth = 140;
  static const double bannerCtaHeight = AppSizes.buttonHeightLg;
  static const double bannerCtaRadius = AppSizes.radiusControl;

  static const double filterHeight = AppSizes.searchFieldHeight;
  static const double filterRadius = AppSizes.radiusControl;
  static const double filterGap = AppSizes.md;
  static const double filterTextSize = AppTextSize.body;
  static const double searchWidth = AppSizes.searchFieldWidth;
  static const double sortWidth = AppSizes.sortButtonWidth;

  static const double gridGap = 14;
  static const double sectionGap = 20;

  static const double cardRadius = AppSizes.radiusCard;
  static const double artInset = 6;
  static const double artHeight = 136;
  static const double artRadius = AppSizes.radiusMd;
  static const double badgeInset = 16;
  static const double badgeHeight = AppSizes.pillHeight;
  static const double badgeTextSize = AppTextSize.caption;
  static const double badgeIconSize = AppSizes.badgeIconSize;

  /// فاصله‌ی محتوای کارت تا لبه‌ی تصویر؛ به‌علاوه‌ی `artInset` می‌شود ۱۶.
  static const double cardPadding = 10;
  static const double cardTitleSize = AppTextSize.cardTitle;
  static const double cardBodySize = AppTextSize.body;
  static const double avatarSize = 30;
  static const double metaIconSize = AppSizes.badgeIconSize;
  static const double progressHeight = AppSizes.progressHeight;
  static const double buttonHeight = AppSizes.buttonHeightMd;
  static const double buttonRadius = AppSizes.radiusControl;

  static const double gapTitleToArt = 9;
  static const double gapTitleToInstructor = 9;
  static const double gapInstructorToMeta = 10;
  static const double gapMetaToProgress = 15;
  static const double gapProgressToButton = 16;
  static const double cardBottomPadding = 12;

  static const Responsive<int> columns =
      Responsive<int>(1, medium: 2, expanded: 3);
}

/// رنگ، پس‌زمینه و آیکون هر وضعیت، همان‌طور که در طرح آمده است.
extension CourseStatusVisual on CourseStatus {
  Color get ink => switch (this) {
        CourseStatus.notStarted => CourseColors.ink,
        CourseStatus.inProgress => CourseColors.blue,
        CourseStatus.completed => CourseColors.green,
      };

  Color get soft => switch (this) {
        CourseStatus.notStarted => CourseColors.surface,
        CourseStatus.inProgress => CourseColors.blueSoft,
        CourseStatus.completed => CourseColors.greenSoft,
      };

  IconData? get icon => switch (this) {
        CourseStatus.notStarted => null,
        CourseStatus.inProgress => null,
        CourseStatus.completed => Icons.check_circle,
      };
}
