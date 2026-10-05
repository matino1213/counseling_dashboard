import 'package:flutter/material.dart';

import '../../../../app/theme/app_sizes.dart';
import '../providers/subscription_providers.dart';
import '../subscription_design.dart';

/// رنگ‌های هر پلن؛ جدا از مدل نگه داشته شده تا فقط لایه‌ی نمایش باشد.
extension PlanStyle on PlanKind {
  Color get accent => switch (this) {
        PlanKind.diamond => SubColors.blue,
        PlanKind.gold => SubColors.gold,
        PlanKind.basic => SubColors.violet,
      };

  Color get tint => switch (this) {
        PlanKind.diamond => SubColors.blueTint,
        PlanKind.gold => SubColors.goldTint,
        PlanKind.basic => SubColors.violetTint,
      };

  Color get bubble => switch (this) {
        PlanKind.diamond => const Color(0xFFE1F1FC),
        PlanKind.gold => SubColors.goldBubble,
        PlanKind.basic => SubColors.violetTint,
      };

  IconData get icon => switch (this) {
        PlanKind.diamond => Icons.diamond_outlined,
        PlanKind.gold => Icons.workspace_premium_rounded,
        PlanKind.basic => Icons.star_outline_rounded,
      };
}

/// کارت با گوشه‌ی گرد و پس‌زمینه‌ی یکدست یا گرادیانی.
class SubCard extends StatelessWidget {
  const SubCard({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.radius = SubSizes.cardRadius,
    this.color,
    this.gradient,
    this.border,
    this.clip = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double radius;
  final Color? color;
  final Gradient? gradient;
  final BoxBorder? border;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final decorated = Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null
            ? (color ?? Theme.of(context).colorScheme.surface)
            : null,
        gradient: gradient,
        border: border,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
    if (!clip) return decorated;
    return ClipRRect(
        borderRadius: BorderRadius.circular(radius), child: decorated);
  }
}

/// حباب رنگی آیکون: دایره یا مربع گرد.
class SubIconBubble extends StatelessWidget {
  const SubIconBubble({
    super.key,
    required this.icon,
    required this.size,
    required this.color,
    required this.background,
    this.circle = true,
    this.radius = SubSizes.bubbleRadius,
  });

  final IconData icon;
  final double size;
  final Color color;
  final Color background;
  final bool circle;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(radius),
      ),
      child: Icon(icon, size: size * 0.5, color: color),
    );
  }
}

/// برچسب کوچک (پیل) با حاشیه یا پس‌زمینه‌ی رنگی.
class SubPill extends StatelessWidget {
  const SubPill({
    super.key,
    required this.label,
    required this.color,
    this.background = Colors.transparent,
    this.filled = false,
    this.height = SubSizes.statusPillHeight,
  });

  final String label;
  final Color color;
  final Color background;
  final bool filled;
  final double height;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: filled ? color : background,
        borderRadius: BorderRadius.circular(SubSizes.chipRadius),
        border: Border.all(color: filled ? color : color.withOpacity(.55)),
      ),
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Center(
            child: Text(
              label,
              style: SubText.pill(context)
                  .copyWith(height: 1, color: filled ? Colors.white : color),
            ),
          ),
        ),
      ),
    );
  }
}

/// مدال گرد با حلقه‌ی طلایی، برای آیکون تاج.
class SubMedallion extends StatelessWidget {
  const SubMedallion({
    super.key,
    required this.size,
    required this.icon,
    required this.iconColor,
  });

  final double size;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SubColors.cream, Color(0xFFFDF0DC)],
        ),
        border: Border.all(color: SubColors.goldRing, width: size * .045),
      ),
      alignment: Alignment.center,
      child: Container(
        width: size * .84,
        height: size * .84,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: SubColors.goldRing.withOpacity(.55), width: size * .018),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: size * .5, color: iconColor),
      ),
    );
  }
}

/// جداکننده‌ی باریک.
class SubDivider extends StatelessWidget {
  const SubDivider({super.key, this.vertical = false, this.thickness = 1});

  final bool vertical;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: vertical ? thickness : double.infinity,
      height: vertical ? double.infinity : thickness,
      color: SubColors.tableLine,
    );
  }
}

/// دکمه‌ی گرادیانی با ارتفاع ثابت؛ برای فراخوان‌های اصلی طرح.
class SubGradientButton extends StatelessWidget {
  const SubGradientButton({
    super.key,
    required this.label,
    this.icon,
    required this.colors,
    required this.height,
    required this.onPressed,
  });

  final String label;
  final IconData? icon;
  final List<Color> colors;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(SubSizes.buttonRadius);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
        borderRadius: radius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon case final icon?) ...[
                    Icon(icon,
                        size: AppSizes.buttonIconSize, color: Colors.white),
                    const SizedBox(width: AppSizes.sm),
                  ],
                  Flexible(
                    child: Text(label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: SubText.button(context)
                            .copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// نوار پیشرفت دوره؛ پرشدگی از سمت چپ شروع می‌شود، همان‌طور که در طرح است.
class SubProgressBar extends StatelessWidget {
  const SubProgressBar({super.key, required this.value, this.height = 12});

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final filled = (constraints.maxWidth * value.clamp(0, 1)).round();
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: SubColors.greenTrack,
                    borderRadius: BorderRadius.circular(height),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: filled.toDouble(),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [SubColors.greenTop, SubColors.greenBottom],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
