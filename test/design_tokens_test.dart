import 'package:counseling_dashboard/app/theme/app_sizes.dart';
import 'package:counseling_dashboard/app/theme/app_text.dart';
import 'package:counseling_dashboard/app/theme/app_theme.dart';
import 'package:counseling_dashboard/features/auth/presentation/login_style.dart';
import 'package:counseling_dashboard/features/courses/presentation/course_style.dart';
import 'package:counseling_dashboard/features/exams/presentation/exam_style.dart';
import 'package:counseling_dashboard/features/subscription/presentation/subscription_design.dart';
import 'package:flutter_test/flutter_test.dart';

/// کنترل‌های هم‌نقش در چهار صفحه (ورود، دوره‌ها، آزمون‌ها، اشتراک)
/// باید عددِ یکسانی داشته باشند؛ این آزمون همان یکسانی را قفل می‌کند.
void main() {
  test('IRANYekan فونت تم و همه‌ی نقش‌های مشترک است', () {
    final textTheme = AppTheme.light().textTheme;
    for (final style in [
      textTheme.displaySmall,
      textTheme.titleLarge,
      textTheme.bodyMedium,
      textTheme.labelLarge,
    ]) {
      expect(style!.fontFamily, AppFonts.family);
    }

    for (final style in [
      AppText.display,
      AppText.section,
      AppText.cardTitle,
      AppText.body,
      AppText.button,
      AppText.field,
      AppText.hint,
      AppText.badge,
      AppText.error,
    ]) {
      expect(style.fontFamily, AppFonts.family);
    }
  });

  test('نردبان قد دکمه‌ها در چهار صفحه یکی است', () {
    expect(AppSizes.buttonHeightSm, 44);
    expect(AppSizes.buttonHeightMd, 48);
    expect(AppSizes.buttonHeightLg, 52);

    // کنش کم‌رنگ سرصفحه.
    expect(CourseSizes.viewAllHeight, AppSizes.buttonHeightSm);
    expect(ExamSizes.viewAllHeight, AppSizes.buttonHeightSm);
    // کنش داخل کارت.
    expect(CourseSizes.buttonHeight, AppSizes.buttonHeightMd);
    expect(ExamSizes.buttonHeight, CourseSizes.buttonHeight);
    expect(SubSizes.planButtonHeight, CourseSizes.buttonHeight);
    expect(SubSizes.bannerButtonHeight, CourseSizes.buttonHeight);
    // فراخوان اصلی صفحه.
    expect(LoginSizes.buttonHeight, AppSizes.buttonHeightLg);
    expect(CourseSizes.bannerCtaHeight, LoginSizes.buttonHeight);
    expect(ExamSizes.bannerButtonHeight, LoginSizes.buttonHeight);

    // شعاع همه‌ی دکمه‌ها یکی است.
    expect(CourseSizes.buttonRadius, AppSizes.radiusControl);
    expect(ExamSizes.buttonRadius, CourseSizes.buttonRadius);
    expect(SubSizes.buttonRadius, CourseSizes.buttonRadius);
    expect(LoginSizes.buttonRadius, CourseSizes.buttonRadius);

    // آیکون داخل دکمه‌ها هم هم‌اندازه‌اند.
    expect(AppSizes.buttonIconSize, 20);
  });

  test('تکست‌فیلدها قد، شعاع و عرض مشترک دارند', () {
    // فیلد فرم (ورود) بلند و فیلد جست‌وجو فشرده است؛ در هر صفحه همین دو عدد.
    expect(LoginSizes.fieldHeight, 52);
    expect(CourseSizes.filterHeight, 44);
    expect(ExamSizes.filterHeight, CourseSizes.filterHeight);

    expect(LoginSizes.boxRadius, AppSizes.radiusControl);
    expect(CourseSizes.filterRadius, LoginSizes.boxRadius);
    expect(ExamSizes.filterRadius, CourseSizes.filterRadius);

    expect(CourseSizes.searchWidth, ExamSizes.searchWidth);
    expect(CourseSizes.sortWidth, ExamSizes.sortWidth);
    expect(CourseSizes.filterGap, ExamSizes.filterGap);

    expect(AppSizes.fieldIconSize, 20);
    expect(AppSizes.fieldIconBox, 40);
  });

  test('مقیاس حروف و بج‌ها در چهار صفحه یکی است', () {
    expect(CourseSizes.pageTitleSize, AppTextSize.display);
    expect(ExamSizes.pageTitleSize, CourseSizes.pageTitleSize);
    expect(CourseSizes.pageSubtitleSize, AppTextSize.body);
    expect(ExamSizes.pageSubtitleSize, CourseSizes.pageSubtitleSize);
    expect(CourseSizes.cardTitleSize, AppTextSize.cardTitle);
    expect(ExamSizes.cardTitleSize, CourseSizes.cardTitleSize);
    expect(CourseSizes.badgeTextSize, AppTextSize.caption);
    expect(ExamSizes.badgeTextSize, CourseSizes.badgeTextSize);
    expect(ExamSizes.chipTextSize, CourseSizes.badgeTextSize);
    expect(ExamSizes.filterLabelSize, CourseSizes.filterTextSize);

    // بج‌ها و چیپ‌ها.
    expect(CourseSizes.badgeHeight, AppSizes.pillHeight);
    expect(ExamSizes.chipHeight, CourseSizes.badgeHeight);
    expect(ExamSizes.artBadgeHeight, CourseSizes.badgeHeight);
    expect(ExamSizes.bannerBadgeHeight, CourseSizes.badgeHeight);
    expect(SubSizes.statusPillHeight, CourseSizes.badgeHeight);
    expect(SubSizes.planBadgeHeight, CourseSizes.badgeHeight);
    expect(SubSizes.tierPillHeight, AppSizes.pillHeightSm);
    expect(CourseSizes.badgeIconSize, AppSizes.badgeIconSize);
    expect(ExamSizes.badgeIconSize, CourseSizes.badgeIconSize);

    // کارت‌ها، نوار پیشرفت و آیکون عنوان صفحه.
    expect(CourseSizes.cardRadius, AppSizes.radiusCard);
    expect(ExamSizes.cardRadius, CourseSizes.cardRadius);
    expect(SubSizes.cardRadius, CourseSizes.cardRadius);
    expect(LoginSizes.cardRadius, CourseSizes.cardRadius);
    expect(CourseSizes.progressHeight, AppSizes.progressHeight);
    expect(ExamSizes.progressHeight, CourseSizes.progressHeight);
    expect(SubSizes.progressHeight, CourseSizes.progressHeight);
    expect(CourseSizes.titleIconSize, AppSizes.titleIconSize);
    expect(ExamSizes.titleIconSize, CourseSizes.titleIconSize);
    expect(SubSizes.headerCrown, CourseSizes.titleIconSize);
  });
}
