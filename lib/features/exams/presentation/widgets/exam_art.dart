import 'package:flutter/material.dart';

import '../../../../app/theme/app_sizes.dart';
import '../exam_style.dart';

/// برچسب سفید روی تصویر هر آزمون که وضعیت را نشان می‌دهد.
class ExamArtBadge extends StatelessWidget {
  const ExamArtBadge(
      {super.key,
      required this.icon,
      required this.label,
      required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: ExamSizes.artBadgeMinWidth),
      child: Container(
        height: ExamSizes.artBadgeHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        decoration: BoxDecoration(
          color: ExamColors.surface,
          borderRadius: BorderRadius.circular(ExamSizes.artBadgeHeight / 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: ExamSizes.badgeIconSize, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ExamSizes.badgeTextSize,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// تصویر آزمون: برشِ خودِ طرح نمونه، با گرادیانِ همان طرح به‌عنوان پشت‌صحنه.
///
/// نام آزمون درون همین تصویر است، پس روی آن متن نوشته نمی‌شود.
class ExamArt extends StatelessWidget {
  const ExamArt({
    super.key,
    required this.illustration,
    required this.gradient,
    this.badge,
    this.rounded = true,
  });

  final String illustration;
  final LinearGradient gradient;
  final Widget? badge;

  /// `false` برای تصویری که تا لبه‌ی بنر کشیده می‌شود.
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius:
            rounded ? BorderRadius.circular(ExamSizes.artRadius) : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            illustration,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => const _FallbackArt(),
          ),
          if (badge case final chip?)
            PositionedDirectional(
              top: ExamSizes.artBadgeTop,
              start: ExamSizes.artBadgeInset,
              child: chip,
            ),
        ],
      ),
    );
  }
}

/// تا وقتی فایل تصویر ساخته نشده، جای آن را گرادیان و دایره‌های طرح می‌گیرد.
class _FallbackArt extends StatelessWidget {
  const _FallbackArt();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: -26,
          right: 62,
          child: _Blob(size: 74, opacity: .28),
        ),
        Positioned(
          bottom: -34,
          left: 34,
          child: _Blob(size: 96, opacity: .18),
        ),
        Positioned(
          top: 26,
          left: -18,
          child: _Blob(size: 58, opacity: .22),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}
