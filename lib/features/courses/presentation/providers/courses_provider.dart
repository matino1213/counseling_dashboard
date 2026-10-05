import 'package:flutter/material.dart' show Color;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/course.dart';

/// وضعیت قابل‌تغییر صفحه‌ی «دوره‌های من».
class CoursesState {
  const CoursesState({
    required this.courses,
    required this.statusFilter,
    required this.query,
    required this.sort,
  });

  final List<MyCourse> courses;

  /// `null` یعنی «همه دوره‌ها».
  final CourseStatus? statusFilter;
  final String query;
  final CourseSort sort;

  CoursesState copyWith({
    List<MyCourse>? courses,
    CourseStatus? Function()? statusFilter,
    String? query,
    CourseSort? sort,
  }) =>
      CoursesState(
        courses: courses ?? this.courses,
        statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
        query: query ?? this.query,
        sort: sort ?? this.sort,
      );
}

const String _artPath = 'assets/images/courses';

/// فهرست نمونه تا وقتی که داده‌ی واقعی به همین ساختار وصل شود.
List<MyCourse> _seedCourses() => [
      MyCourse(
        id: 'communication',
        title: 'مهارت‌های گفت‌وگو و حل تعارض',
        instructor: 'دکتر مریم رضایی',
        status: CourseStatus.inProgress,
        sessions: 12,
        attendedSessions: 8,
        duration: const Duration(hours: 4, minutes: 20),
        lastActivityAt: _DateTimes.communication,
        illustration: '$_artPath/communication_skills.png',
        tint: const Color(0xFFF3D6C4),
        nextSession: 'شنیدن بدون قضاوت',
      ),
      MyCourse(
        id: 'premarriage',
        title: 'شناخت پیش از ازدواج',
        instructor: 'دکتر امیر حسینی',
        status: CourseStatus.inProgress,
        sessions: 10,
        attendedSessions: 3,
        duration: const Duration(hours: 3, minutes: 40),
        lastActivityAt: _DateTimes.premarriage,
        illustration: '$_artPath/premarriage.png',
        tint: const Color(0xFFD9E4F7),
      ),
      MyCourse(
        id: 'emotion',
        title: 'مدیریت هیجان و خشم',
        instructor: 'دکتر سارا احمدی',
        status: CourseStatus.notStarted,
        sessions: 8,
        attendedSessions: 0,
        duration: const Duration(hours: 2, minutes: 55),
        lastActivityAt: _DateTimes.emotion,
        illustration: '$_artPath/emotion_management.png',
        tint: const Color(0xFFE4D8F6),
      ),
      MyCourse(
        id: 'finance',
        title: 'سواد مالی در زندگی مشترک',
        instructor: 'دکتر علی کریمی',
        status: CourseStatus.notStarted,
        sessions: 6,
        attendedSessions: 0,
        duration: const Duration(hours: 2, minutes: 10),
        lastActivityAt: _DateTimes.finance,
        illustration: '$_artPath/financial_literacy.png',
        tint: const Color(0xFFD7EEE4),
      ),
      MyCourse(
        id: 'self-growth',
        title: 'خودشناسی و رشد فردی',
        instructor: 'دکتر نازنین محمدی',
        status: CourseStatus.completed,
        sessions: 10,
        attendedSessions: 10,
        duration: const Duration(hours: 3),
        lastActivityAt: _DateTimes.selfGrowth,
        illustration: '$_artPath/self_growth.png',
        tint: const Color(0xFFCFE7E2),
      ),
      MyCourse(
        id: 'attachment',
        title: 'سبک‌های دلبستگی',
        instructor: 'دکتر رضا موسوی',
        status: CourseStatus.completed,
        sessions: 8,
        attendedSessions: 8,
        duration: const Duration(hours: 2, minutes: 40),
        lastActivityAt: _DateTimes.attachment,
        illustration: '$_artPath/attachment_styles.png',
        tint: const Color(0xFFE6DAF2),
      ),
    ];

abstract final class _DateTimes {
  static final DateTime communication = DateTime(2026, 10, 4, 9);
  static final DateTime premarriage = DateTime(2026, 10, 2, 18);
  static final DateTime emotion = DateTime(2026, 9, 28, 11);
  static final DateTime finance = DateTime(2026, 9, 20, 14);
  static final DateTime selfGrowth = DateTime(2026, 9, 12, 10);
  static final DateTime attachment = DateTime(2026, 9, 5, 16);
}

/// منبع واحد حالت صفحه: دوره‌ها + فیلتر وضعیت + جست‌وجو + ترتیب.
class CoursesNotifier extends Notifier<CoursesState> {
  @override
  CoursesState build() => CoursesState(
        courses: _seedCourses(),
        statusFilter: null,
        query: '',
        sort: CourseSort.recent,
      );

  void filterBy(CourseStatus? status) =>
      state = state.copyWith(statusFilter: () => status);

  void search(String query) => state = state.copyWith(query: query);

  void sortBy(CourseSort sort) => state = state.copyWith(sort: sort);

  /// «مشاهده همه دوره‌ها» فیلتر و جست‌وجو را پاک می‌کند.
  void showAll() => state = state.copyWith(
        statusFilter: () => null,
        query: '',
      );

  /// شروع یا ادامه‌ی دوره؛ یک جلسه به پیشرفت اضافه می‌کند.
  void open(String id) {
    state = state.copyWith(
      courses: [
        for (final course in state.courses)
          course.id == id ? _advance(course) : course,
      ],
    );
  }

  MyCourse _advance(MyCourse course) {
    if (course.completed) return course;
    final attended = course.attendedSessions + 1;
    return course.copyWith(
      attendedSessions: attended,
      status: attended >= course.sessions
          ? CourseStatus.completed
          : CourseStatus.inProgress,
    );
  }
}

final coursesProvider =
    NotifierProvider<CoursesNotifier, CoursesState>(CoursesNotifier.new);

/// تعداد هر وضعیت در کل دوره‌های کاربر.
final courseCountsProvider = Provider<Map<CourseStatus, int>>((ref) {
  final courses = ref.watch(coursesProvider).courses;
  return {
    for (final status in CourseStatus.values)
      status: courses.where((course) => course.status == status).length,
  };
});

/// بیشترین پیشرفتِ دوره‌های نیمه‌تمام؛ بنر «ادامه یادگیری» روی آن است.
final continueCourseProvider = Provider<MyCourse?>((ref) {
  final pending = ref
      .watch(coursesProvider)
      .courses
      .where((course) => course.status == CourseStatus.inProgress)
      .toList();
  if (pending.isEmpty) return null;
  pending.sort((a, b) => b.progress.compareTo(a.progress));
  return pending.first;
});

/// فهرست نمایش‌داده‌شده بعد از فیلتر، جست‌وجو و ترتیب.
final visibleCoursesProvider = Provider<List<MyCourse>>((ref) {
  final state = ref.watch(coursesProvider);
  final query = state.query.trim();

  final matches = [
    for (final course in state.courses)
      if (state.statusFilter == null || course.status == state.statusFilter)
        if (query.isEmpty ||
            course.title.contains(query) ||
            course.instructor.contains(query))
          course,
  ];

  matches.sort(switch (state.sort) {
    CourseSort.recent => (a, b) => b.lastActivityAt.compareTo(a.lastActivityAt),
    CourseSort.progress => (a, b) => b.progress.compareTo(a.progress),
    CourseSort.sessions => (a, b) => b.sessions.compareTo(a.sessions),
  });
  return matches;
});
