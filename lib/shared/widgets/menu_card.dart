import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_sizes.dart';

/// کارت ورودی به یکی از بخش‌های داشبورد.
class MenuCard extends StatefulWidget {
  const MenuCard(
      {super.key,
      required this.title,
      required this.description,
      required this.icon,
      required this.tint,
      required this.accentColor,
      required this.onTap});

  final String title;
  final String description;
  final IconData icon;
  final Color tint;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final iconBox = AppSizes.iconBox.resolve(context);
    final radius = BorderRadius.circular(AppSizes.radiusLg);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: _hovered ? AppColors.primarySoft : AppColors.surface,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: _hovered ? AppColors.primary : AppColors.border,
                width: _hovered ? 1.4 : 1,
              ),
            ),
            padding: EdgeInsets.all(AppSizes.pagePadding.resolve(context)),
            child: Row(
              children: [
                Container(
                  width: iconBox,
                  height: iconBox,
                  decoration: BoxDecoration(
                    color: widget.tint,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Icon(widget.icon,
                      color: widget.accentColor, size: iconBox * .5),
                ),
                const SizedBox(width: AppSizes.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: textTheme.titleMedium),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        widget.description,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: _hovered ? AppColors.primary : AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
