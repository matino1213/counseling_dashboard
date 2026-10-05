import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/empty_state.dart';
import '../domain/exam.dart';
import 'exam_style.dart';
import 'providers/exams_provider.dart';
import 'widgets/exam_card.dart';
import 'widgets/exam_consultation_strip.dart';
import 'widgets/exam_continue_banner.dart';
import 'widgets/exam_filter_bar.dart';
import 'widgets/exam_page_header.dart';

/// بخش «آزمون‌های من»: بنر ادامه، فیلترها، شبکه‌ی کارت‌ها و نوار مشاور.
class ExamsPage extends ConsumerWidget {
  const ExamsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(continueExamProvider);
    final exams = ref.watch(visibleExamsProvider);
    final notifier = ref.read(examsProvider.notifier);

    return Scaffold(
      backgroundColor: ExamColors.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: ExamSizes.pagePadding, vertical: 20),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: ExamSizes.contentMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ExamPageHeader(onViewAll: notifier.showAll),
                  const SizedBox(height: 16),
                  if (pending case final exam?) ...[
                    ExamContinueBanner(
                        exam: exam, onTap: () => notifier.open(exam.id)),
                    const SizedBox(height: 20),
                  ],
                  const ExamFilterBar(),
                  const SizedBox(height: ExamSizes.sectionGap),
                  if (exams.isEmpty)
                    EmptyState(
                      icon: Icons.search_off,
                      title: 'آزمونی با این فیلترها نیست',
                      message: 'عبارت جست‌وجو یا وضعیت انتخابی را عوض کنید '
                          'تا همه‌ی آزمون‌های خریداری‌شده را ببینید.',
                      onRetry: notifier.showAll,
                    )
                  else
                    _ExamGrid(exams: exams),
                  const SizedBox(height: ExamSizes.sectionGap),
                  ExamConsultationStrip(
                    onContact: () =>
                        _openLaterPage(context, 'گفت‌وگو با مشاور'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// پیام موقت برای عملیاتی که صفحه‌ی مقصدشان هنوز ساخته نشده است.
void _openLaterPage(BuildContext context, String label) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
        SnackBar(content: Text('صفحه‌ی «$label» بعداً وصل می‌شود.')));
}

/// دو ستون در تبلت و ویندوز، یک ستون در گوشی؛ کارت‌های هر ردیف هم‌ارتفاع‌اند.
class _ExamGrid extends StatelessWidget {
  const _ExamGrid({required this.exams});

  final List<Exam> exams;

  @override
  Widget build(BuildContext context) {
    final columns = ExamSizes.columns.resolve(context);
    return Column(
      children: [
        for (var start = 0; start < exams.length; start += columns)
          Padding(
            padding: const EdgeInsets.only(bottom: ExamSizes.gridGap),
            child: _ExamRow(
              exams: exams.sublist(
                start,
                start + columns > exams.length ? exams.length : start + columns,
              ),
            ),
          ),
      ],
    );
  }
}

class _ExamRow extends ConsumerWidget {
  const _ExamRow({required this.exams});

  final List<Exam> exams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(examsProvider.notifier);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, exam) in exams.indexed) ...[
            if (index > 0) const SizedBox(width: ExamSizes.gridGap),
            Expanded(
              child: ExamCard(
                exam: exam,
                onOpen: () => exam.status == ExamStatus.completed
                    ? _openLaterPage(context, 'گزارش آزمون')
                    : notifier.open(exam.id),
                onDetails: () => _openLaterPage(context, 'جزئیات آزمون'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
