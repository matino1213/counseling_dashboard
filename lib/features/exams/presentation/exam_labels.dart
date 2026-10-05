import '../domain/exam.dart';

/// برچسب‌های فارسی وضعیت و ترتیب آزمون.
extension ExamStatusLabel on ExamStatus {
  String get label => switch (this) {
        ExamStatus.ready => 'آماده شروع',
        ExamStatus.inProgress => 'در حال انجام',
        ExamStatus.completed => 'تکمیل‌شده',
      };
}

extension ExamSortLabel on ExamSort {
  String get label => switch (this) {
        ExamSort.recent => 'آخرین فعالیت',
        ExamSort.progress => 'بیشترین پیشرفت',
      };
}
