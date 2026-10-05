import 'package:flutter/material.dart';

import '../../../../app/responsive/responsive.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../domain/course.dart';
import '../course_style.dart';
import 'course_primitives.dart';

/// بنر «ادامه یادگیری»؛ تصویر در انتها (چپ) و متن و دکمه در ابتدا (راست).
///
/// در صفحه‌های باریک تصویر بالای متن می‌نشیند تا چیزی حذف نشود.
class ContinueLearningBanner extends StatelessWidget {
  const ContinueLearningBanner({
    super.key,
    required this.course,
    required this.onTap,
  });

  final MyCourse course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CourseSizes.bannerRadius),
        gradient: CourseColors.bannerGradient,
        border: Border.all(color: CourseColors.border),
      ),
      child: context.isExpanded
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      CourseSizes.bannerStartPadding,
                      CourseSizes.bannerArtInset,
                      CourseSizes.bannerInnerGap,
                      CourseSizes.bannerArtInset),
                  child: _callToAction(compact: false),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: CourseSizes.bannerTextPadding),
                    child: _text(),
                  ),
                ),
                const SizedBox(width: CourseSizes.bannerInnerGap),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0,
                      CourseSizes.bannerArtInset,
                      CourseSizes.bannerArtInset,
                      CourseSizes.bannerArtInset),
                  child: _Art(
                    course: course,
                    width: CourseSizes.bannerArtWidth,
                    height: CourseSizes.bannerArtHeight,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      CourseSizes.bannerArtInset,
                      CourseSizes.bannerArtInset,
                      CourseSizes.bannerArtInset,
                      0),
                  child: _Art(
                    course: course,
                    width: double.infinity,
                    height: context.isCompact ? 150 : 170,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(CourseSizes.bannerTextPadding),
                  child: _text(),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      CourseSizes.bannerTextPadding,
                      0,
                      CourseSizes.bannerTextPadding,
                      CourseSizes.bannerTextPadding),
                  child: _callToAction(compact: true),
                ),
              ],
            ),
    );
  }

  Widget _text() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CourseArtBadge(
            status: course.status,
            label: 'ادامه یادگیری',
          ),
          const SizedBox(height: 8),
          Text(
            course.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: CourseSizes.bannerTitleSize,
              fontWeight: FontWeight.w800,
              color: CourseColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'جلسه بعد: ${course.nextSession ?? course.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: CourseSizes.bannerBodySize,
              fontWeight: FontWeight.w600,
              color: CourseColors.inkSoft,
            ),
          ),
          const SizedBox(height: 14),
          CourseProgressRow(course: course),
        ],
      );

  Widget _callToAction({required bool compact}) => FilledButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.play_circle_outline,
            size: AppSizes.buttonIconSize),
        iconAlignment: IconAlignment.start,
        label: const Text('ادامه یادگیری'),
        style: FilledButton.styleFrom(
          backgroundColor: CourseColors.green,
          foregroundColor: CourseColors.surface,
          minimumSize: compact
              ? const Size(0, CourseSizes.bannerCtaHeight - 8)
              : const Size(
                  CourseSizes.bannerCtaWidth, CourseSizes.bannerCtaHeight),
          maximumSize: const Size(double.infinity, CourseSizes.bannerCtaHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CourseSizes.bannerCtaRadius),
          ),
        ),
      );
}

/// تصویر بنر با دکمه‌ی پخش در میان.
class _Art extends StatelessWidget {
  const _Art({
    required this.course,
    required this.width,
    required this.height,
  });

  final MyCourse course;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(CourseSizes.bannerArtRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              course.illustration,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, __, ___) => ColoredBox(color: course.tint),
            ),
            Center(
              child: Container(
                width: CourseSizes.bannerPlaySize,
                height: CourseSizes.bannerPlaySize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CourseColors.surface.withOpacity(.92),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 12,
                        offset: Offset(0, 3)),
                  ],
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    size: 26, color: CourseColors.greenDeep),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
