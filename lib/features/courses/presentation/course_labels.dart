import '../../../shared/persian_number.dart';
import '../domain/course.dart';

/// ترتیب چیپ‌های فیلتر، مطابق چیدمان طرح نمونه.
const List<CourseStatus> kCourseFilterOrder = [
  CourseStatus.inProgress,
  CourseStatus.notStarted,
  CourseStatus.completed,
];

/// برچسب‌های فارسی وضعیت، ترتیب و مدت دوره.
extension CourseStatusLabel on CourseStatus {
  String get label => switch (this) {
        CourseStatus.notStarted => 'شروع نشده',
        CourseStatus.inProgress => 'در حال یادگیری',
        CourseStatus.completed => 'تکمیل‌شده',
      };
}

extension CourseSortLabel on CourseSort {
  String get label => switch (this) {
        CourseSort.recent => 'آخرین فعالیت',
        CourseSort.progress => 'بیشترین پیشرفت',
        CourseSort.sessions => 'بیشترین جلسه',
      };
}

extension CourseMetaLabel on MyCourse {
  /// «۱۲ جلسه»
  String get sessionsLabel => '${faNumber(sessions)} جلسه';

  /// «۸ از ۱۲ جلسه»
  String get attendedLabel =>
      '${faNumber(attendedSessions)} از ${faNumber(sessions)} جلسه';

  /// «۴ ساعت و ۲۰ دقیقه»؛ ساعت یا دقیقه‌ی صفر حذف می‌شود.
  String get durationLabel {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours == 0) return '${faNumber(minutes)} دقیقه';
    if (minutes == 0) return '${faNumber(hours)} ساعت';
    return '${faNumber(hours)} ساعت و ${faNumber(minutes)} دقیقه';
  }

  /// «۶۷٪»
  String get percentLabel => '${faNumber((progress * 100).round())}٪';
}
