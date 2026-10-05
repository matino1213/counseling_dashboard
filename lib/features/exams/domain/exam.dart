import 'package:flutter/material.dart';

/// وضعیت یک آزمون خریداری‌شده.
enum ExamStatus { ready, inProgress, completed }

/// ترتیب نمایش فهرست آزمون‌ها.
enum ExamSort { recent, progress }

/// یک آزمون شخصیت با وضعیت پیشرفت کاربر.
class Exam {
  const Exam({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.purchased,
    required this.progress,
    required this.reportReady,
    required this.lastActivityAt,
    required this.illustration,
    required this.artGradient,
  });

  final String id;
  final String title;
  final String subtitle;
  final ExamStatus status;

  /// برچسب «خریداری‌شده» فقط برای آزمون‌های فعال نمایش داده می‌شود.
  final bool purchased;

  /// fraction پیشرفت پاسخ‌دهی؛ از ۰ تا ۱.
  final double progress;
  final bool reportReady;
  final DateTime lastActivityAt;

  /// تصویر برش‌خورده از طرح؛ نام آزمون بخشی از همین تصویر است.
  final String illustration;

  /// پس‌زمینه‌ی گرادیانی تا وقتی تصویر در دسترس نباشد کارت خالی نماند.
  final LinearGradient artGradient;

  Exam copyWith({ExamStatus? status, double? progress}) => Exam(
        id: id,
        title: title,
        subtitle: subtitle,
        status: status ?? this.status,
        purchased: purchased,
        progress: progress ?? this.progress,
        reportReady: reportReady,
        lastActivityAt: lastActivityAt,
        illustration: illustration,
        artGradient: artGradient,
      );
}
