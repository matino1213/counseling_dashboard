import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/responsive/responsive.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../shared/persian_number.dart';
import '../../domain/exam.dart';
import '../exam_labels.dart';
import '../exam_style.dart';
import '../providers/exams_provider.dart';

/// نوار فیلتر: چیپ‌های وضعیت، جست‌وجو و ترتیب‌بندی.
class ExamFilterBar extends ConsumerStatefulWidget {
  const ExamFilterBar({super.key});

  @override
  ConsumerState<ExamFilterBar> createState() => _ExamFilterBarState();
}

class _ExamFilterBarState extends ConsumerState<ExamFilterBar> {
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
            label: 'همه آزمون‌ها',
            count: ref
                .watch(examCountsProvider)
                .values
                .fold<int>(0, (sum, value) => sum + value),
            selected: ref.watch(examsProvider).statusFilter == null,
            background: ExamColors.green,
            ink: ExamColors.surface,
            onTap: () => ref.read(examsProvider.notifier).filterBy(null),
          ),
          for (final status in ExamStatus.values)
            _StatusChip(
              label: status.label,
              count: ref.watch(examCountsProvider)[status] ?? 0,
              selected: ref.watch(examsProvider).statusFilter == status,
              background: _chipBackground(status),
              ink: status == ExamStatus.inProgress
                  ? ExamColors.blue
                  : ExamColors.ink,
              onTap: () => ref.read(examsProvider.notifier).filterBy(status),
            ),
        ],
      ),
    );

    final controls = Row(
      children: [
        Expanded(child: _SearchField(controller: _search)),
        const SizedBox(width: ExamSizes.filterGap),
        const SizedBox(width: ExamSizes.sortWidth, child: _SortButton()),
      ],
    );

    if (context.isExpanded) {
      return Row(
        children: [
          Expanded(child: chips),
          const SizedBox(width: 24),
          SizedBox(
            width: ExamSizes.searchWidth +
                ExamSizes.filterGap +
                ExamSizes.sortWidth,
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

  static Color _chipBackground(ExamStatus status) => switch (status) {
        ExamStatus.ready => ExamColors.graySoft,
        ExamStatus.inProgress => ExamColors.blueSoft,
        ExamStatus.completed => ExamColors.greenSoft,
      };
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
    final color = selected ? ExamColors.surface : ink;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: ExamSizes.filterGap),
      child: Material(
        color: selected ? ExamColors.green : background,
        borderRadius: BorderRadius.circular(ExamSizes.filterRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(ExamSizes.filterRadius),
          onTap: onTap,
          child: Container(
            height: ExamSizes.filterHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ExamSizes.filterRadius),
              border: Border.all(
                color: selected ? ExamColors.green : ExamColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: ExamSizes.filterLabelSize,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  faNumber(count),
                  style: TextStyle(
                    fontSize: ExamSizes.filterLabelSize,
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
      height: ExamSizes.filterHeight,
      decoration: BoxDecoration(
        color: ExamColors.surface,
        borderRadius: BorderRadius.circular(ExamSizes.filterRadius),
        border: Border.all(color: ExamColors.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) => ref.read(examsProvider.notifier).search(value),
        style: const TextStyle(
            fontSize: ExamSizes.filterLabelSize, color: ExamColors.ink),
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          hintText: 'جستجو در آزمون‌های من',
          hintStyle: TextStyle(
              fontSize: ExamSizes.filterLabelSize, color: ExamColors.inkFaint),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          contentPadding: AppSizes.fieldPaddingCompact,
          prefixIcon: Icon(Icons.search,
              size: AppSizes.fieldIconSize, color: ExamColors.inkSoft),
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
    final sort = ref.watch(examsProvider).sort;
    return PopupMenuButton<ExamSort>(
      position: PopupMenuPosition.under,
      initialValue: sort,
      onSelected: (value) => ref.read(examsProvider.notifier).sortBy(value),
      itemBuilder: (context) => [
        for (final option in ExamSort.values)
          PopupMenuItem(value: option, child: Text(option.label)),
      ],
      child: Container(
        height: ExamSizes.filterHeight,
        padding: AppSizes.fieldPaddingCompact,
        decoration: BoxDecoration(
          color: ExamColors.surface,
          borderRadius: BorderRadius.circular(ExamSizes.filterRadius),
          border: Border.all(color: ExamColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                sort.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: ExamSizes.filterLabelSize,
                  fontWeight: FontWeight.w700,
                  color: ExamColors.ink,
                ),
              ),
            ),
            const Icon(Icons.swap_vert,
                size: AppSizes.fieldIconSize, color: ExamColors.ink),
            const Icon(Icons.expand_more,
                size: AppSizes.fieldIconSize, color: ExamColors.inkSoft),
          ],
        ),
      ),
    );
  }
}
