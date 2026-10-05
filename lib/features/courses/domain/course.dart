import 'package:flutter/material.dart';

/// وضعیت یک دوره‌ی خریداری‌شده.
enum CourseStatus { notStarted, inProgress, completed }

/// ترتیب نمایش فهرست دوره‌ها.
enum CourseSort { recent, progress, sessions }

/// یک دوره‌ی آموزشی که کاربر آن را خریداری کرده است.
class MyCourse {
  const MyCourse({
    required this.id,
    required this.title,
    required this.instructor,
    required this.status,
    required this.sessions,
    required this.attendedSessions,
    required this.duration,
    required this.lastActivityAt,
    required this.illustration,
    required this.tint,
    this.nextSession,
  });

  final String id;
  final String title;
  final String instructor;
  final CourseStatus status;

  /// تعداد کل جلسه‌ها و جلسه‌های دیده‌شده؛ درصد پیشرفت از همین‌ها ساخته می‌شود.
  final int sessions;
  final int attendedSessions;
  final Duration duration;
  final DateTime lastActivityAt;

  /// مسیر تصویر سربرگ کارت.
  final String illustration;

  /// رنگ پس‌زمینه‌ی دایره‌ی نام مدرس.
  final Color tint;

  /// عنوان جلسه‌ی بعد؛ فقط در بنر «ادامه یادگیری» نمایش داده می‌شود.
  final String? nextSession;

  double get progress =>
      sessions == 0 ? 0 : (attendedSessions / sessions).clamp(0.0, 1.0);

  bool get started => attendedSessions > 0;

  bool get completed => status == CourseStatus.completed;

  MyCourse copyWith({CourseStatus? status, int? attendedSessions}) => MyCourse(
        id: id,
        title: title,
        instructor: instructor,
        status: status ?? this.status,
        sessions: sessions,
        attendedSessions: attendedSessions ?? this.attendedSessions,
        duration: duration,
        lastActivityAt: lastActivityAt,
        illustration: illustration,
        tint: tint,
        nextSession: nextSession,
      );
}
