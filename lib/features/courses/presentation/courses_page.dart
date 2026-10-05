import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/empty_state.dart';
import '../domain/course.dart';
import 'course_style.dart';
import 'providers/courses_provider.dart';
import 'widgets/continue_learning_banner.dart';
import 'widgets/course_card.dart';
import 'widgets/course_filter_bar.dart';
import 'widgets/course_page_header.dart';

/// بخش «دوره‌های من»: بنر ادامه، فیلترها و شبکه‌ی کارت‌های دوره.
class CoursesPage extends ConsumerWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(continueCourseProvider);
    final courses = ref.watch(visibleCoursesProvider);
    final notifier = ref.read(coursesProvider.notifier);

    return Scaffold(
      backgroundColor: CourseColors.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: CourseSizes.pagePadding.resolve(context),
              vertical: 20),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: CourseSizes.contentMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CoursePageHeader(onViewAll: notifier.showAll),
                  const SizedBox(height: 18),
                  if (pending case final course?) ...[
                    ContinueLearningBanner(
                        course: course, onTap: () => notifier.open(course.id)),
                    const SizedBox(height: 28),
                  ],
                  const CourseFilterBar(),
                  const SizedBox(height: CourseSizes.sectionGap),
                  if (courses.isEmpty)
                    EmptyState(
                      icon: Icons.search_off,
                      title: 'دوره‌ای با این فیلترها نیست',
                      message: 'عبارت جست‌وجو یا وضعیت انتخابی را عوض کنید '
                          'تا همه‌ی دوره‌های خریداری‌شده را ببینید.',
                      onRetry: notifier.showAll,
                    )
                  else
                    _CourseGrid(courses: courses),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// سه ستون در ویندوز، دو در تبلت و یک در گوشی؛ کارت‌های هر ردیف هم‌ارتفاع‌اند.
class _CourseGrid extends StatelessWidget {
  const _CourseGrid({required this.courses});

  final List<MyCourse> courses;

  @override
  Widget build(BuildContext context) {
    final columns = CourseSizes.columns.resolve(context);
    return Column(
      children: [
        for (var start = 0; start < courses.length; start += columns)
          Padding(
            padding: const EdgeInsets.only(bottom: CourseSizes.gridGap),
            child: _CourseRow(
              courses: courses.sublist(
                start,
                start + columns > courses.length
                    ? courses.length
                    : start + columns,
              ),
            ),
          ),
      ],
    );
  }
}

class _CourseRow extends ConsumerWidget {
  const _CourseRow({required this.courses});

  final List<MyCourse> courses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(coursesProvider.notifier);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, course) in courses.indexed) ...[
            if (index > 0) const SizedBox(width: CourseSizes.gridGap),
            Expanded(
              child: CourseCard(
                course: course,
                onOpen: () => course.completed
                    ? _openLater(context, 'جزئیات دوره')
                    : notifier.open(course.id),
                onCertificate: () => _openLater(context, 'گواهی دوره'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// پیام موقت برای عملیاتی که صفحه‌ی مقصدشان هنوز ساخته نشده است.
void _openLater(BuildContext context, String label) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
        SnackBar(content: Text('صفحه‌ی «$label» بعداً وصل می‌شود.')));
}
