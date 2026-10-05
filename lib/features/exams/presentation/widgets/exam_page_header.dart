import 'package:flutter/material.dart';

import '../../../../app/responsive/responsive.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text.dart';
import '../exam_style.dart';

/// سطر بالای صفحه: عنوان و زیرعنوان در ابتدا، دکمه‌ی «مشاهده همه» در انتها.
class ExamPageHeader extends StatelessWidget {
  const ExamPageHeader({super.key, required this.onViewAll});

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
              Icon(Icons.leaderboard,
                  size: ExamSizes.titleIconSize, color: ExamColors.green),
              SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  'آزمون‌های من',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _pageTitle,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text('آزمون‌های خریداری‌شده و نتایج شما', style: _pageSubtitle),
        ],
      );

  /// عنوان‌های صفحه از نقش‌های مشترک `AppText` می‌آیند؛ فقط رنگ پالت این صفحه است.
  static const TextStyle _pageTitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: ExamSizes.pageTitleSize,
    fontWeight: FontWeight.w800,
    color: ExamColors.ink,
  );
  static const TextStyle _pageSubtitle = TextStyle(
    fontFamily: AppFonts.family,
    fontSize: ExamSizes.pageSubtitleSize,
    color: ExamColors.inkSoft,
  );

  static Widget _viewAll(VoidCallback onViewAll) => OutlinedButton.icon(
        onPressed: onViewAll,
        icon: const Icon(Icons.arrow_forward, size: AppSizes.buttonIconSize),
        label: const Text('مشاهده همه آزمون‌ها'),
        iconAlignment: IconAlignment.end,
        style: OutlinedButton.styleFrom(
          foregroundColor: ExamColors.ink,
          minimumSize: const Size(0, ExamSizes.viewAllHeight),
          maximumSize: const Size(double.infinity, ExamSizes.viewAllHeight),
          // هدف لمس ۴۸ پیکسلی دور دکمه، قدِ طراحی‌شده را بزرگ‌تر نشان می‌دهد.
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          side: const BorderSide(color: AppColors.borderStrong),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ExamSizes.buttonRadius),
          ),
        ),
      );
}
