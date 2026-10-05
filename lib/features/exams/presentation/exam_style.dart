import 'package:flutter/material.dart';

import '../../../app/responsive/responsive.dart';
import '../../../app/theme/app_sizes.dart';
import '../../../app/theme/app_text.dart';
import '../domain/exam.dart';

/// پالت رنگی صفحه‌ی «آزمون‌های من»؛ همه‌ی مقدارها از طرح نمونه‌برداری شده‌اند.
abstract final class ExamColors {
  static const Color pageBackground = Color(0xFFF1F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE3EAF0);

  static const Color ink = Color(0xFF0E1634);
  static const Color inkSoft = Color(0xFF5A6784);
  static const Color inkFaint = Color(0xFF8A94AC);

  /// سبز اصلی دکمه‌ها و وضعیت‌ها.
  static const Color green = Color(0xFF019662);
  static const Color greenDeep = Color(0xFF00824F);
  static const Color greenSoft = Color(0xFFE8F8F3);
  static const Color stripBackground = Color(0xFFE9F8F4);

  /// بنفش پیشرفت آزمون کتل.
  static const Color purple = Color(0xFF9E6DEC);
  static const Color purpleInk = Color(0xFF661FCA);
  static const Color purpleSoft = Color(0xFFF5EFFE);
  static const Color bannerLeft = Color(0xFFF4F3FE);
  static const Color bannerRight = Color(0xFFEDE6FD);

  static const Color blue = Color(0xFF1D40C8);
  static const Color blueSoft = Color(0xFFE4F1FE);
  static const Color graySoft = Color(0xFFECF1F4);

  static const Color progressTrack = Color(0xFFE3EBEC);

  /// نشان «آزمون نیمه‌تمام دارید» روی بنر: بنفش کم‌رنگ با جوهر بنفش پررنگ.
  static const Color bannerBadgeBackground = Color(0xFFE4D6FA);
  static const Color bannerBadgeInk = Color(0xFF5E17C5);

  /// پس‌زمینه‌ی تصویر کارت هر آزمون.
  static const LinearGradient cattellArt = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEFE7FD), Color(0xFFC9B6F5)],
  );
  static const LinearGradient neoArt = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF3F6E9), Color(0xFFBFDCC6)],
  );
  static const LinearGradient mbtiArt = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF3E6), Color(0xFFF3CBA8)],
  );
  static const LinearGradient shakleArt = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE7F7FB), Color(0xFFA6DBEC)],
  );
}

/// اندازه‌های صفحه‌ی «آزمون‌های من» (بوم ۱۴۱۲، پیکسل‌به‌پیکسل).
abstract final class ExamSizes {
  static const double contentMaxWidth = 1100;
  static const double pagePadding = 24;

  static const double pageTitleSize = AppTextSize.display;
  static const double pageSubtitleSize = AppTextSize.body;
  static const double titleIconSize = AppSizes.titleIconSize;
  static const double viewAllHeight = AppSizes.buttonHeightSm;

  static const double bannerHeight = 158;
  static const double bannerRadius = AppSizes.radiusCard;
  static const double bannerArtWidth = 276;
  static const double bannerBadgeHeight = AppSizes.pillHeight;
  static const double bannerTitleSize = AppTextSize.section;
  static const double bannerBodySize = AppTextSize.body;
  static const double bannerButtonWidth = 206;
  static const double bannerButtonHeight = AppSizes.buttonHeightLg;

  static const double filterHeight = AppSizes.searchFieldHeight;
  static const double filterRadius = AppSizes.radiusControl;
  static const double filterGap = AppSizes.md;
  static const double filterLabelSize = AppTextSize.body;
  static const double searchWidth = AppSizes.searchFieldWidth;
  static const double sortWidth = AppSizes.sortButtonWidth;

  static const double cardRadius = AppSizes.radiusCard;
  static const double cardPadding = AppSizes.md;
  static const double artHeight = 133;
  static const double artRadius = AppSizes.radiusMd;
  static const double artBadgeHeight = AppSizes.pillHeight;
  static const double artBadgeTop = 8;
  static const double artBadgeInset = 10;
  static const double badgeIconSize = AppSizes.badgeIconSize;
  static const double badgeTextSize = AppTextSize.caption;

  /// نشانِ روی تصویر کمی پهن‌تر از نشانِ داخل برشِ طرح (۱۱۰ تا ۱۱۷) است تا
  /// همیشه روی آن را بپوشاند و دو نشان کنار هم دیده نشود.
  static const double artBadgeMinWidth = 124;
  static const double cardTitleSize = AppTextSize.cardTitle;
  static const double cardBodySize = AppTextSize.body;
  static const double chipHeight = AppSizes.pillHeight;
  static const double chipTextSize = AppTextSize.caption;
  static const double progressHeight = AppSizes.progressHeight;
  static const double buttonHeight = AppSizes.buttonHeightMd;
  static const double buttonRadius = AppSizes.radiusControl;

  static const double gridGap = 16;
  static const double sectionGap = 16;

  static const double stripHeight = AppSizes.buttonHeightLg;
  static const double stripRadius = AppSizes.radiusControl;
  static const double stripTextSize = AppTextSize.body;

  static const Responsive<int> columns =
      Responsive<int>(1, medium: 2, expanded: 2);
}

/// رنگ و آیکون هر وضعیت، همان‌طور که در طرح آمده است.
extension ExamStatusVisual on ExamStatus {
  Color get ink => switch (this) {
        ExamStatus.ready => ExamColors.blue,
        ExamStatus.inProgress => ExamColors.purpleInk,
        ExamStatus.completed => ExamColors.green,
      };

  Color get soft => switch (this) {
        ExamStatus.ready => ExamColors.blueSoft,
        ExamStatus.inProgress => ExamColors.purpleSoft,
        ExamStatus.completed => ExamColors.greenSoft,
      };

  IconData get icon => switch (this) {
        ExamStatus.ready => Icons.play_circle_outline,
        ExamStatus.inProgress => Icons.schedule,
        ExamStatus.completed => Icons.check_circle,
      };
}
