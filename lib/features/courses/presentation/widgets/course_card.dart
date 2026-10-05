import 'package:flutter/material.dart';

import '../../../../app/theme/app_sizes.dart';
import '../course_labels.dart';
import '../course_style.dart';
import '../../domain/course.dart';
import 'course_primitives.dart';

/// کارت یک دوره: تصویر، وضعیت، مدرس، پیشرفت و دکمه‌ی اقدام.
class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.onOpen,
    required this.onCertificate,
  });

  final MyCourse course;
  final VoidCallback onOpen;
  final VoidCallback onCertificate;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CourseColors.surface,
      borderRadius: BorderRadius.circular(CourseSizes.cardRadius),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: CourseSizes.artInset),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: CourseSizes.artInset),
            child: CourseArt(course: course, height: CourseSizes.artHeight),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              CourseSizes.cardPadding,
              CourseSizes.gapTitleToArt,
              CourseSizes.cardPadding,
              CourseSizes.cardBottomPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: CourseSizes.cardTitleSize,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                    color: CourseColors.ink,
                  ),
                ),
                const SizedBox(height: CourseSizes.gapTitleToInstructor),
                _InstructorRow(course: course),
                const SizedBox(height: CourseSizes.gapInstructorToMeta),
                Row(
                  children: [
                    CourseMeta(
                      icon: Icons.event_available_outlined,
                      text: course.sessionsLabel,
                    ),
                    const SizedBox(width: 28),
                    Expanded(
                      child: CourseMeta(
                        icon: Icons.schedule,
                        text: course.durationLabel,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: CourseSizes.gapMetaToProgress),
                CourseProgressRow(course: course),
                const SizedBox(height: CourseSizes.gapProgressToButton),
                _Actions(
                    course: course,
                    onOpen: onOpen,
                    onCertificate: onCertificate),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructorRow extends StatelessWidget {
  const _InstructorRow({required this.course});

  final MyCourse course;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CourseAvatar(name: course.instructor, tint: course.tint),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            course.instructor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: CourseSizes.cardBodySize,
              fontWeight: FontWeight.w600,
              color: CourseColors.inkSoft,
            ),
          ),
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions(
      {required this.course,
      required this.onOpen,
      required this.onCertificate});

  final MyCourse course;
  final VoidCallback onOpen;
  final VoidCallback onCertificate;

  @override
  Widget build(BuildContext context) {
    if (course.completed) {
      return Row(
        children: [
          Expanded(
            child: _OpenButton(
              course: course,
              label: 'مشاهده دوره',
              onTap: onOpen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onCertificate,
              icon: const Icon(Icons.workspace_premium_outlined,
                  size: AppSizes.buttonIconSize),
              iconAlignment: IconAlignment.start,
              label: const Text('دریافت گواهی'),
              style: OutlinedButton.styleFrom(
                foregroundColor: CourseColors.ink,
                backgroundColor: CourseColors.certificateBackground,
                minimumSize: const Size(0, CourseSizes.buttonHeight),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CourseSizes.buttonRadius),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: _OpenButton(
        course: course,
        label: course.status == CourseStatus.notStarted
            ? 'شروع دوره'
            : 'ادامه دوره',
        onTap: onOpen,
      ),
    );
  }
}

class _OpenButton extends StatelessWidget {
  const _OpenButton(
      {required this.course, required this.label, required this.onTap});

  final MyCourse course;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final started = course.status != CourseStatus.notStarted;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.play_arrow, size: AppSizes.buttonIconSize),
      iconAlignment: IconAlignment.start,
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: started ? CourseColors.green : CourseColors.ink,
        minimumSize: const Size(0, CourseSizes.buttonHeight),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        side: BorderSide(
          color:
              started ? CourseColors.greenOutline : CourseColors.buttonBorder,
          width: AppSizes.buttonBorderWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CourseSizes.buttonRadius),
        ),
      ),
    );
  }
}
