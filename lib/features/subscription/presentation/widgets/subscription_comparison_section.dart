import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_sizes.dart';
import '../providers/subscription_providers.dart';
import '../subscription_design.dart';
import 'subscription_primitives.dart';

/// کارت «مقایسه امکانات پلن‌ها» با جدول چهارستونه.
class SubscriptionComparisonSection extends ConsumerWidget {
  const SubscriptionComparisonSection({super.key});

  static const List<int> _columnFlex = [14, 10, 10, 10];
  static const Color _rowSurface = Colors.white;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final features = ref.watch(subscriptionFeaturesProvider);
    final plans = ref.watch(subscriptionPlansProvider);
    final current = ref.watch(currentSubscriptionProvider).currentPlanId;

    const minWidth = SubSizes.minFeatureColumn + SubSizes.minPlanColumn * 3;

    return SubCard(
      padding: const EdgeInsets.symmetric(
          horizontal: SubSizes.cardPadding, vertical: AppSizes.lg),
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('مقایسه امکانات پلن‌ها', style: SubText.tableHeading(context)),
          const SizedBox(height: AppSizes.lg),
          LayoutBuilder(
            builder: (context, outer) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: math.max(minWidth, outer.maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeaderRow(plans: plans, currentPlanId: current),
                    for (final (index, feature) in features.indexed)
                      _FeatureRow(
                        feature: feature,
                        last: index == features.length - 1,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.plans, required this.currentPlanId});

  final List<SubscriptionPlan> plans;
  final String currentPlanId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SubSizes.tableHeaderRow + 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: SubscriptionComparisonSection._columnFlex[0],
            child: ColoredBox(
              color: SubColors.tableHeader,
              child: Center(
                child: Text('امکانات', style: SubText.tableHeaderCell(context)),
              ),
            ),
          ),
          for (final (index, plan) in plans.indexed)
            Expanded(
              flex: SubscriptionComparisonSection._columnFlex[index + 1],
              child: ColoredBox(
                color: plan.id == currentPlanId
                    ? SubColors.goldTint
                    : SubColors.tableHeader,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(plan.title, style: SubText.tableHeaderCell(context)),
                    if (plan.id == currentPlanId) ...[
                      const SizedBox(height: 2),
                      const SubPill(
                        label: 'اشتراک فعلی',
                        color: SubColors.gold,
                        height: SubSizes.tierPillHeight,
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature, required this.last});

  final SubscriptionFeature feature;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final cells = [feature.diamond, feature.gold, feature.basic];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: feature.isTall ? SubSizes.tableRowTall : SubSizes.tableRow,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: SubscriptionComparisonSection._columnFlex[0],
                child: ColoredBox(
                  color: SubscriptionComparisonSection._rowSurface,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: AppSizes.md),
                    child: Row(
                      children: [
                        SubIconBubble(
                          icon: feature.icon,
                          size: SubSizes.tableIconBubble,
                          color: feature.accent,
                          background: feature.tint,
                          circle: false,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(feature.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: SubText.featureLabel(context)),
                              if (feature.hint case final hint?)
                                Text(hint,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: SubText.featureHint(context)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              for (var i = 0; i < cells.length; i++)
                Expanded(
                  flex: SubscriptionComparisonSection._columnFlex[i + 1],
                  child: ColoredBox(
                    color: i == 1
                        ? SubColors.goldTint
                        : SubscriptionComparisonSection._rowSurface,
                    child: Center(child: _Cell(cell: cells[i])),
                  ),
                ),
            ],
          ),
        ),
        if (!last) const SubDivider(),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.cell});

  final FeatureCell cell;

  @override
  Widget build(BuildContext context) {
    if (cell.included case final included?) {
      return Icon(
        included ? Icons.check_circle_outline : Icons.cancel_outlined,
        size: 22,
        color: included ? SubColors.green : SubColors.muted,
      );
    }
    return Text(cell.label ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: SubText.tableCell(context));
  }
}
