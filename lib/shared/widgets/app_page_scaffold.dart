import 'package:flutter/material.dart';

import '../../app/responsive/responsive.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_sizes.dart';

/// اسکلت مشترک همه‌ی صفحه‌ها: هدر ثابت + بدنه‌ی اسکرول‌شونده، راست‌چین و ریسپانسیو.
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    this.showBack = false,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool showBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final horizontal = AppSizes.pagePadding.resolve(context);
    final maxWidth = AppSizes.contentMaxWidth.resolve(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontal, vertical: AppSizes.md),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: _PageHeader(
                      title: title,
                      subtitle: subtitle,
                      actions: actions,
                      showBack: showBack,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontal,
                AppSizes.lg,
                horizontal,
                AppSizes.xxxl + context.bottomSafeInset,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: child),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    required this.actions,
    required this.showBack,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        if (showBack) ...[
          IconButton(
            onPressed: () => Navigator.maybeOf(context)?.maybePop(),
            icon: const Icon(Icons.arrow_back),
            tooltip: 'بازگشت',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border),
            ),
          ),
          const SizedBox(width: AppSizes.md),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.titleLarge),
              if (subtitle case final description?) ...[
                const SizedBox(height: AppSizes.xs),
                Text(
                  description,
                  style: textTheme.bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
        ),
        ...actions,
      ],
    );
  }
}
