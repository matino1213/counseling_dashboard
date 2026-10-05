import 'package:flutter/material.dart';

import '../../../../app/responsive/responsive.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../shared/persian_number.dart';
import '../../domain/exam.dart';
import '../exam_style.dart';
import 'exam_art.dart';
import 'exam_progress_bar.dart';

/// بنر «ادامه آزمون» برای آزمون نیمه‌تمام.
///
/// در دسکتاپ تصویر کنار متن می‌نشیند؛ در صفحه‌های باریک‌تر بنر عمودی می‌شود
/// تا هیچ‌کدام از نوشته‌ها حذف نشود.
class ExamContinueBanner extends StatelessWidget {
  const ExamContinueBanner(
      {super.key, required this.exam, required this.onTap});

  final Exam exam;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.isExpanded ? ExamSizes.bannerHeight : null,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ExamSizes.bannerRadius),
        gradient: const LinearGradient(
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
          colors: [ExamColors.bannerRight, ExamColors.bannerLeft],
        ),
      ),
      child: context.isExpanded
          ? Row(
              children: [
                const SizedBox(
                  width: ExamSizes.bannerArtWidth,
                  height: double.infinity,
                  child: _art,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 14, 0, 14),
                    child: _text(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 28, 0),
                  child: _button(compact: false),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 0),
                  child: _text(),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 14),
                  child: _button(compact: true),
                ),
              ],
            ),
    );
  }

  static const Widget _art = ExamArt(
    illustration: 'assets/images/exams/cattell_wide.png',
    gradient: ExamColors.cattellArt,
    rounded: false,
  );

  Widget _text() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: ExamSizes.bannerBadgeHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            decoration: BoxDecoration(
              color: ExamColors.bannerBadgeBackground,
              borderRadius:
                  BorderRadius.circular(ExamSizes.bannerBadgeHeight / 2),
            ),
            child: const Text(
              'آزمون نیمه‌تمام دارید',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ExamSizes.badgeTextSize,
                fontWeight: FontWeight.w700,
                color: ExamColors.bannerBadgeInk,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            exam.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: ExamSizes.bannerTitleSize,
              fontWeight: FontWeight.w800,
              color: ExamColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'پاسخ‌های شما ذخیره شده‌اند؛ از همان‌جا ادامه دهید.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ExamSizes.bannerBodySize,
              color: ExamColors.inkSoft,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ExamProgressBar(
                  value: exam.progress,
                  trackColor: Colors.white.withOpacity(.65),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${faPercent(exam.progress)} تکمیل شده',
                maxLines: 1,
                style: const TextStyle(
                  fontSize: ExamSizes.bannerBodySize,
                  fontWeight: FontWeight.w700,
                  color: ExamColors.ink,
                ),
              ),
            ],
          ),
        ],
      );

  Widget _button({required bool compact}) => FilledButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.play_arrow_outlined,
            size: AppSizes.buttonIconSize),
        label: const Text('ادامه آزمون'),
        style: FilledButton.styleFrom(
          backgroundColor: ExamColors.green,
          foregroundColor: ExamColors.surface,
          minimumSize: compact
              ? const Size(0, ExamSizes.bannerButtonHeight - 6)
              : const Size(
                  ExamSizes.bannerButtonWidth, ExamSizes.bannerButtonHeight),
          maximumSize: Size(
              double.infinity,
              compact
                  ? ExamSizes.bannerButtonHeight - 6
                  : ExamSizes.bannerButtonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ExamSizes.buttonRadius),
          ),
        ),
      );
}
