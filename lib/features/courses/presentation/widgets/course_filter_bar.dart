import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/responsive/responsive.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../shared/persian_number.dart';
import '../../domain/course.dart';
import '../course_labels.dart';
import '../course_style.dart';
import '../providers/courses_provider.dart';

/// نوار فیلتر: چیپ‌های وضعیت در ابتدا، جست‌وجو و ترتیب در انتها.
class CourseFilterBar extends ConsumerStatefulWidget {
  const CourseFilterBar({super.key});

  @override
  ConsumerState<CourseFilterBar> createState() => _CourseFilterBarState();
}

class _CourseFilterBarState extends ConsumerState<CourseFilterBar> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chips = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _StatusChip(
            label: 'همه دوره‌ها',
            count: ref
                .watch(courseCountsProvider)
                .values
                .fold<int>(0, (sum, value) => sum + value),
            selected: ref.watch(coursesProvider).statusFilter == null,
            background: CourseColors.green,
            ink: CourseColors.ink,
            onTap: () => ref.read(coursesProvider.notifier).filterBy(null),
          ),
          for (final status in kCourseFilterOrder)
            _StatusChip(
              label: status.label,
              count: ref.watch(courseCountsProvider)[status] ?? 0,
              selected: ref.watch(coursesProvider).statusFilter == status,
              background: status.soft,
              ink: status.ink,
              onTap: () => ref.read(coursesProvider.notifier).filterBy(status),
            ),
        ],
      ),
    );

    final controls = Row(
      children: [
        Expanded(child: _SearchField(controller: _search)),
        const SizedBox(width: CourseSizes.filterGap),
        const SizedBox(width: CourseSizes.sortWidth, child: _SortButton()),
      ],
    );

    if (context.isExpanded) {
      return Row(
        children: [
          Expanded(child: chips),
          const SizedBox(width: 24),
          SizedBox(
            width: CourseSizes.searchWidth +
                CourseSizes.filterGap +
                CourseSizes.sortWidth,
            child: controls,
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        chips,
        const SizedBox(height: 12),
        controls,
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.background,
    required this.ink,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final Color background;
  final Color ink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? CourseColors.surface : ink;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: CourseSizes.filterGap),
      child: Material(
        color: selected ? CourseColors.green : background,
        borderRadius: BorderRadius.circular(CourseSizes.filterRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(CourseSizes.filterRadius),
          onTap: onTap,
          child: Container(
            height: CourseSizes.filterHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(CourseSizes.filterRadius),
              border: Border.all(
                color: selected ? CourseColors.green : CourseColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: CourseSizes.filterTextSize,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  faNumber(count),
                  style: TextStyle(
                    fontSize: CourseSizes.filterTextSize,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends ConsumerWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: CourseSizes.filterHeight,
      decoration: BoxDecoration(
        color: CourseColors.surface,
        borderRadius: BorderRadius.circular(CourseSizes.filterRadius),
        border: Border.all(color: CourseColors.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) => ref.read(coursesProvider.notifier).search(value),
        style: const TextStyle(
            fontSize: CourseSizes.filterTextSize, color: CourseColors.ink),
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          hintText: 'جستجو در دوره‌های من',
          hintStyle: TextStyle(
              fontSize: CourseSizes.filterTextSize,
              color: CourseColors.inkSoft),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          contentPadding: AppSizes.fieldPaddingCompact,
          prefixIcon: Icon(Icons.search,
              size: AppSizes.fieldIconSize, color: CourseColors.inkSoft),
          prefixIconConstraints: BoxConstraints(
              minWidth: AppSizes.fieldIconBox,
              minHeight: AppSizes.fieldIconBox),
        ),
      ),
    );
  }
}

class _SortButton extends ConsumerWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(coursesProvider).sort;
    return PopupMenuButton<CourseSort>(
      position: PopupMenuPosition.under,
      initialValue: sort,
      onSelected: (value) => ref.read(coursesProvider.notifier).sortBy(value),
      itemBuilder: (context) => [
        for (final option in CourseSort.values)
          PopupMenuItem(value: option, child: Text(option.label)),
      ],
      child: Container(
        height: CourseSizes.filterHeight,
        padding: AppSizes.fieldPaddingCompact,
        decoration: BoxDecoration(
          color: CourseColors.surface,
          borderRadius: BorderRadius.circular(CourseSizes.filterRadius),
          border: Border.all(color: CourseColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                sort.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: CourseSizes.filterTextSize,
                  fontWeight: FontWeight.w700,
                  color: CourseColors.ink,
                ),
              ),
            ),
            const Icon(Icons.swap_vert,
                size: AppSizes.fieldIconSize, color: CourseColors.ink),
            const Icon(Icons.expand_more,
                size: AppSizes.fieldIconSize, color: CourseColors.inkSoft),
          ],
        ),
      ),
    );
  }
}
