import 'package:flutter/material.dart';

import '../../../../app/responsive/responsive.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text.dart';
import '../course_style.dart';

/// سطر بالای صفحه: عنوان و زیرعنوان در ابتدا، دکمه‌ی «مشاهده همه» در انتها.
class CoursePageHeader extends StatelessWidget {
  const CoursePageHeader({super.key, required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    if (context.isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _titles(),
          const SizedBox(height: AppSizes.md),
          _viewAll(onViewAll)
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _titles()),
        const SizedBox(width: AppSizes.lg),
        _viewAll(onViewAll),
      ],
    );
  }

  static Widget _titles() => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_rounded,
                  size: CourseSizes.titleIconSize, color: CourseColors.green),
              SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  'دوره‌های من',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _pageTitle,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text('دوره‌های خریداری‌شده و مسیر یادگیری شما', style: _pageSubtitle),
        ],
      );

  /// عنوان‌های صفحه از نقش‌های مشترک `AppText` می‌آیند؛ فقط رنگ پالت این صفحه است.
  static const TextStyle _pageTitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: CourseSizes.pageTitleSize,
    fontWeight: FontWeight.w800,
    color: CourseColors.ink,
  );
  static const TextStyle _pageSubtitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: CourseSizes.pageSubtitleSize,
    color: CourseColors.inkSoft,
  );

  static Widget _viewAll(VoidCallback onViewAll) => OutlinedButton.icon(
        onPressed: onViewAll,
        icon: const Icon(Icons.arrow_forward, size: AppSizes.buttonIconSize),
        iconAlignment: IconAlignment.end,
        label: const Text('مشاهده همه دوره‌ها'),
        style: OutlinedButton.styleFrom(
          foregroundColor: CourseColors.ink,
          minimumSize: const Size(0, CourseSizes.viewAllHeight),
          maximumSize: const Size(double.infinity, CourseSizes.viewAllHeight),
          // هدف لمس ۴۸ پیکسلی دور دکمه، قدِ طراحی‌شده را بزرگ‌تر نشان می‌دهد.
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          side: const BorderSide(color: AppColors.borderStrong),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CourseSizes.buttonRadius),
          ),
        ),
      );
}
