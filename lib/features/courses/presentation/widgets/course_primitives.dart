import 'package:flutter/material.dart';

import '../../../../app/theme/app_sizes.dart';
import '../course_labels.dart';
import '../course_style.dart';
import '../../domain/course.dart';

/// برچسب pill‌شکل وضعیت؛ در بنر با [label] سفارشی هم به کار می‌رود.
class CourseArtBadge extends StatelessWidget {
  const CourseArtBadge({
    super.key,
    required this.status,
    this.height = CourseSizes.badgeHeight,
    this.label,
  });

  final CourseStatus status;
  final double height;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        color: status.soft,
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status.icon case final icon?) ...[
            Icon(icon,
                size: CourseSizes.badgeIconSize, color: CourseColors.green),
            const SizedBox(width: 6),
          ],
          Text(
            label ?? status.label,
            style: TextStyle(
              fontSize: CourseSizes.badgeTextSize,
              fontWeight: FontWeight.w700,
              color: status.ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// تصویر سربرگ: کادر گرد، تصویر پوششی و برچسب وضعیت در گوشه.
class CourseArt extends StatelessWidget {
  const CourseArt({
    super.key,
    required this.course,
    required this.height,
    this.radius = CourseSizes.artRadius,
    this.badgeInset = CourseSizes.badgeInset,
  });

  final MyCourse course;
  final double height;
  final double radius;
  final double badgeInset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              course.illustration,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, __, ___) => ColoredBox(color: course.tint),
            ),
            PositionedDirectional(
              top: badgeInset - CourseSizes.artInset,
              end: badgeInset - CourseSizes.artInset,
              child: CourseArtBadge(status: course.status),
            ),
          ],
        ),
      ),
    );
  }
}

/// نوار پیشرفت دوره؛ پرشدگی از سمت چپ شروع می‌شود، مطابق طرح.
class CourseProgressBar extends StatelessWidget {
  const CourseProgressBar({
    super.key,
    required this.value,
    this.height = CourseSizes.progressHeight,
  });

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: CourseColors.progressTrack,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: constraints.maxWidth * value.clamp(0.0, 1.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: CourseColors.progressFill,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// دایره‌ی نام مدرس کنار نام او.
class CourseAvatar extends StatelessWidget {
  const CourseAvatar({super.key, required this.name, required this.tint});

  final String name;
  final Color tint;

  String get _initial {
    final parts = name.split(' ').where((part) => part.isNotEmpty).toList();
    final given = parts.length >= 2 ? parts[1] : name;
    return String.fromCharCodes(given.runes.take(1));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CourseSizes.avatarSize,
      height: CourseSizes.avatarSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tint, Color.lerp(tint, Colors.white, .45)!],
        ),
      ),
      child: Text(
        _initial,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: CourseColors.ink,
        ),
      ),
    );
  }
}

/// «۱۲ جلسه» یا «۴ ساعت و ۲۰ دقیقه» با آیکون.
class CourseMeta extends StatelessWidget {
  const CourseMeta({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: CourseSizes.metaIconSize, color: CourseColors.inkSoft),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: CourseSizes.cardBodySize,
              fontWeight: FontWeight.w600,
              color: CourseColors.inkMedium,
            ),
          ),
        ),
      ],
    );
  }
}

/// سطر پیشرفت: برچسب جلسه‌ها، نوار و درصد.
class CourseProgressRow extends StatelessWidget {
  const CourseProgressRow({super.key, required this.course});

  final MyCourse course;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (course.started) ...[
          Text(
            course.attendedLabel,
            style: const TextStyle(
              fontSize: CourseSizes.cardBodySize,
              fontWeight: FontWeight.w600,
              color: CourseColors.inkMedium,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(child: CourseProgressBar(value: course.progress)),
        const SizedBox(width: 12),
        Text(
          course.percentLabel,
          style: const TextStyle(
            fontSize: CourseSizes.cardBodySize + 1,
            fontWeight: FontWeight.w800,
            color: CourseColors.ink,
          ),
        ),
      ],
    );
  }
}
