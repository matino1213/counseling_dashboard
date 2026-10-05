import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_features.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_sizes.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/menu_card.dart';
import 'providers/dashboard_providers.dart';

/// صفحه‌ی اصلی: چهار ورودی به بخش‌های برنامه.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final features = ref.watch(dashboardMenuProvider);

    return AppPageScaffold(
      title: 'داشبورد مرکز مشاوره',
      subtitle: 'یک بخش را برای ورود انتخاب کنید',
      child: _MenuGrid(features: features),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid({required this.features});

  final List<AppFeature> features;

  @override
  Widget build(BuildContext context) {
    final columns = AppSizes.menuColumns.resolve(context);
    final gap = AppSizes.menuGap.resolve(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var start = 0; start < features.length; start += columns)
          _MenuRow(
            features: features.sublist(
              start,
              start + columns > features.length
                  ? features.length
                  : start + columns,
            ),
            gap: gap,
          ),
        const SizedBox(height: AppSizes.xl),
        Text(
          'نسخه ۱.۰.۰',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.features, required this.gap});

  final List<AppFeature> features;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.lg),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, feature) in features.indexed) ...[
              if (index > 0) SizedBox(width: gap),
              Expanded(
                child: MenuCard(
                  title: feature.title,
                  description: feature.description,
                  icon: feature.icon,
                  tint: feature.tint,
                  accentColor: feature.accentColor,
                  onTap: () =>
                      Navigator.of(context).pushNamed(feature.routeName),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
