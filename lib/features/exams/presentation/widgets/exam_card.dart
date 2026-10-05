import 'package:flutter/material.dart';

import '../../../../app/theme/app_sizes.dart';
import '../../../../shared/persian_number.dart';
import '../../domain/exam.dart';
import '../exam_labels.dart';
import '../exam_style.dart';
import 'exam_art.dart';
import 'exam_progress_bar.dart';

/// کارت یک آزمون: تصویر، عنوان، وضعیت و دو دکمه.
class ExamCard extends StatelessWidget {
  const ExamCard(
      {super.key,
      required this.exam,
      required this.onOpen,
      required this.onDetails});

  final Exam exam;
  final VoidCallback onOpen;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final status = exam.status;
    final reportReady = status == ExamStatus.completed;
    return Material(
      color: ExamColors.surface,
      borderRadius: BorderRadius.circular(ExamSizes.cardRadius),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ExamSizes.cardRadius),
          border: Border.all(color: ExamColors.border),
        ),
        padding: const EdgeInsets.all(ExamSizes.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ExamSizes.artHeight,
              child: ExamArt(
                illustration: exam.illustration,
                gradient: exam.artGradient,
                badge: ExamArtBadge(
                  icon: status.icon,
                  label: status.label,
                  color: status.ink,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    exam.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: ExamSizes.cardTitleSize,
                      fontWeight: FontWeight.w800,
                      color: ExamColors.ink,
                    ),
                  ),
                ),
                if (exam.purchased) ...[
                  const SizedBox(width: 8),
                  const _PurchasedChip(),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              exam.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: ExamSizes.cardBodySize,
                color: ExamColors.inkSoft,
              ),
            ),
            const SizedBox(height: 14),
            _StatusLine(exam: exam),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onOpen,
                    icon: const Icon(Icons.play_arrow_outlined,
                        size: AppSizes.buttonIconSize),
                    label: Text(switch (status) {
                      ExamStatus.ready => 'شروع آزمون',
                      ExamStatus.inProgress => 'ادامه آزمون',
                      ExamStatus.completed => 'مشاهده نتیجه',
                    }),
                    style: _buttonStyle(
                      background: ExamColors.green,
                      foreground: ExamColors.surface,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDetails,
                    icon: Icon(
                      reportReady
                          ? Icons.download_outlined
                          : Icons.description_outlined,
                      size: AppSizes.buttonIconSize,
                    ),
                    label: Text(reportReady ? 'دریافت گزارش' : 'جزئیات آزمون'),
                    style: _buttonStyle(
                      background: ExamColors.surface,
                      foreground: ExamColors.ink,
                      border: ExamColors.border,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static ButtonStyle _buttonStyle({
    required Color background,
    required Color foreground,
    Color? border,
  }) =>
      FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        minimumSize: const Size(0, ExamSizes.buttonHeight),
        maximumSize: const Size(double.infinity, ExamSizes.buttonHeight),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ExamSizes.buttonRadius),
          side: BorderSide(
              color: border ?? Colors.transparent,
              width: AppSizes.buttonBorderWidth),
        ),
      );
}

/// برچسب «خریداری‌شده» کنار عنوان کارت.
class _PurchasedChip extends StatelessWidget {
  const _PurchasedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ExamSizes.chipHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        color: ExamColors.greenSoft,
        borderRadius: BorderRadius.circular(ExamSizes.chipHeight / 2),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle,
              size: ExamSizes.badgeIconSize, color: ExamColors.green),
          SizedBox(width: 5),
          Text(
            'خریداری‌شده',
            style: TextStyle(
              fontSize: ExamSizes.chipTextSize,
              fontWeight: FontWeight.w700,
              color: ExamColors.green,
            ),
          ),
        ],
      ),
    );
  }
}

/// سطر وضعیت کارت: نوار پیشرفت، راهنمای شروع، یا آماده بودن گزارش.
class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    if (exam.status == ExamStatus.inProgress) {
      return Row(
        children: [
          Expanded(child: ExamProgressBar(value: exam.progress)),
          const SizedBox(width: 12),
          Text(
            '${faPercent(exam.progress)} تکمیل شده',
            style: const TextStyle(
              fontSize: ExamSizes.cardBodySize,
              fontWeight: FontWeight.w700,
              color: ExamColors.ink,
            ),
          ),
        ],
      );
    }

    final reportReady = exam.reportReady;
    return Row(
      children: [
        Icon(
          reportReady ? Icons.description_outlined : Icons.event_note_outlined,
          size: 18,
          color: reportReady ? ExamColors.green : ExamColors.inkSoft,
        ),
        const SizedBox(width: 6),
        Text(
          reportReady ? 'گزارش شما آماده است' : 'هنوز شروع نکرده‌اید',
          style: TextStyle(
            fontSize: ExamSizes.cardBodySize,
            fontWeight: reportReady ? FontWeight.w700 : FontWeight.w400,
            color: reportReady ? ExamColors.green : ExamColors.inkSoft,
          ),
        ),
      ],
    );
  }
}
