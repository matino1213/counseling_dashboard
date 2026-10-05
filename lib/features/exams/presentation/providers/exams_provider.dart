import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/exam.dart';
import '../exam_style.dart';

/// وضعیت قابل‌تغییر صفحه‌ی «آزمون‌های من».
class ExamsState {
  const ExamsState({
    required this.exams,
    required this.statusFilter,
    required this.query,
    required this.sort,
  });

  final List<Exam> exams;

  /// `null` یعنی «همه آزمون‌ها».
  final ExamStatus? statusFilter;
  final String query;
  final ExamSort sort;

  ExamsState copyWith({
    List<Exam>? exams,
    ExamStatus? Function()? statusFilter,
    String? query,
    ExamSort? sort,
  }) =>
      ExamsState(
        exams: exams ?? this.exams,
        statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
        query: query ?? this.query,
        sort: sort ?? this.sort,
      );
}

/// فهرست نمونه تا وقتی که داده‌ی واقعی به همین ساختار وصل شود.
const String _artPath = 'assets/images/exams';

List<Exam> _seedExams() => [
      Exam(
        id: 'neo',
        title: 'آزمون شخصیت NEO',
        subtitle: 'شناخت پنج عامل اصلی شخصیت',
        status: ExamStatus.ready,
        purchased: true,
        progress: 0,
        reportReady: false,
        lastActivityAt: _DateTimes.neo,
        illustration: '$_artPath/neo.png',
        artGradient: ExamColors.neoArt,
      ),
      Exam(
        id: 'cattell',
        title: 'آزمون شخصیت کتل',
        subtitle: 'شناخت ویژگی‌های فردی و الگوهای رفتاری',
        status: ExamStatus.inProgress,
        purchased: true,
        progress: 0.45,
        reportReady: false,
        lastActivityAt: _DateTimes.cattell,
        illustration: '$_artPath/cattell.png',
        artGradient: ExamColors.cattellArt,
      ),
      Exam(
        id: 'shakle',
        title: 'آزمون شاکله',
        subtitle: 'آشنایی با الگوهای شخصیتی شما',
        status: ExamStatus.completed,
        purchased: true,
        progress: 1,
        reportReady: true,
        lastActivityAt: _DateTimes.shakle,
        illustration: '$_artPath/shakle.png',
        artGradient: ExamColors.shakleArt,
      ),
      Exam(
        id: 'mbti',
        title: 'آزمون تیپ شخصیتی MBTI',
        subtitle: 'آشنایی با ترجیحات و تیپ شخصیتی',
        status: ExamStatus.ready,
        purchased: true,
        progress: 0,
        reportReady: false,
        lastActivityAt: _DateTimes.mbti,
        illustration: '$_artPath/mbti.png',
        artGradient: ExamColors.mbtiArt,
      ),
    ];

abstract final class _DateTimes {
  static final DateTime neo = DateTime(2026, 10, 3, 11);
  static final DateTime cattell = DateTime(2026, 10, 2, 18);
  static final DateTime shakle = DateTime(2026, 9, 28, 9);
  static final DateTime mbti = DateTime(2026, 9, 20, 14);
}

/// منبع واحد حالت صفحه: آزمون‌ها + فیلتر وضعیت + جست‌وجو + ترتیب.
class ExamsNotifier extends Notifier<ExamsState> {
  @override
  ExamsState build() => ExamsState(
        exams: _seedExams(),
        statusFilter: null,
        query: '',
        sort: ExamSort.recent,
      );

  void filterBy(ExamStatus? status) =>
      state = state.copyWith(statusFilter: () => status);

  void search(String query) => state = state.copyWith(query: query);

  void sortBy(ExamSort sort) => state = state.copyWith(sort: sort);

  /// «مشاهده همه آزمون‌ها» فیلتر و جست‌وجو را پاک می‌کند.
  void showAll() => state = state.copyWith(
        statusFilter: () => null,
        query: '',
      );

  /// شروع یا ادامه‌ی آزمون؛ وضعیت و پیشرفت را به‌روز می‌کند.
  void open(String id) {
    state = state.copyWith(
      exams: [
        for (final exam in state.exams)
          exam.id == id && exam.status == ExamStatus.ready
              ? exam.copyWith(status: ExamStatus.inProgress, progress: 0.05)
              : exam,
      ],
    );
  }
}

final examsProvider =
    NotifierProvider<ExamsNotifier, ExamsState>(ExamsNotifier.new);

/// تعداد هر وضعیت در کل آزمون‌های کاربر.
final examCountsProvider = Provider<Map<ExamStatus, int>>((ref) {
  final exams = ref.watch(examsProvider).exams;
  return {
    for (final status in ExamStatus.values)
      status: exams.where((exam) => exam.status == status).length,
  };
});

/// آزمون نیمه‌تمامی که بنر «ادامه آزمون» روی آن است.
final continueExamProvider = Provider<Exam?>((ref) {
  final pending = ref
      .watch(examsProvider)
      .exams
      .where((exam) => exam.status == ExamStatus.inProgress);
  return pending.isEmpty ? null : pending.first;
});

/// فهرست نمایش‌داده‌شده بعد از فیلتر، جست‌وجو و ترتیب.
final visibleExamsProvider = Provider<List<Exam>>((ref) {
  final state = ref.watch(examsProvider);
  final query = state.query.trim();

  final matches = [
    for (final exam in state.exams)
      if (state.statusFilter == null || exam.status == state.statusFilter)
        if (query.isEmpty ||
            exam.title.contains(query) ||
            exam.subtitle.contains(query))
          exam,
  ];

  matches.sort(switch (state.sort) {
    ExamSort.recent => (a, b) => b.lastActivityAt.compareTo(a.lastActivityAt),
    ExamSort.progress => (a, b) => b.progress.compareTo(a.progress),
  });
  return matches;
});
