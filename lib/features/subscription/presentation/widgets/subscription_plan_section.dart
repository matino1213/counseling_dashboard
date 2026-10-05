import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/responsive/responsive.dart';
import '../../../../app/theme/app_sizes.dart';
import '../providers/subscription_providers.dart';
import '../subscription_design.dart';
import 'subscription_primitives.dart';

/// سرصفحه‌ی «انتخاب اشتراک» و سه کارت پلن.
class SubscriptionPlanSection extends ConsumerWidget {
  const SubscriptionPlanSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(subscriptionPlansProvider);
    final selected = ref.watch(selectedPlanProvider);
    final current = ref.watch(currentSubscriptionProvider).currentPlanId;
    final comparisonVisible = ref.watch(comparisonVisibleProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child:
                  Text('انتخاب اشتراک', style: SubText.sectionTitle(context)),
            ),
            _ComparisonToggle(
              visible: comparisonVisible,
              onPressed: () =>
                  ref.read(comparisonVisibleProvider.notifier).toggle(),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.lg),
        if (context.isCompact)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, plan) in plans.indexed) ...[
                if (index > 0) const SizedBox(height: SubSizes.planGap),
                _PlanCard(
                  plan: plan,
                  isCurrent: plan.id == current,
                  isSelected: plan.id == selected,
                  onSelect: () =>
                      ref.read(selectedPlanProvider.notifier).select(plan.id),
                ),
              ],
            ],
          )
        else
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final plan in plans) ...[
                  if (plan != plans.first)
                    const SizedBox(width: SubSizes.planGap),
                  Expanded(
                    child: _PlanCard(
                      plan: plan,
                      isCurrent: plan.id == current,
                      isSelected: plan.id == selected,
                      onSelect: () => ref
                          .read(selectedPlanProvider.notifier)
                          .select(plan.id),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// چیپ «مقایسه پلن‌ها» که جدول را نمایش یا مخفی می‌کند.
class _ComparisonToggle extends StatelessWidget {
  const _ComparisonToggle({required this.visible, required this.onPressed});

  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = visible ? SubColors.ink : SubColors.muted;
    final style = SubText.sectionTitle(context).copyWith(color: color);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(SubSizes.chipRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.xs, vertical: AppSizes.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('مقایسه پلن‌ها', style: style),
            const SizedBox(width: AppSizes.md),
            Icon(Icons.balance_outlined, size: 24, color: color),
          ],
        ),
      ),
    );
  }
}

/// یک کارت پلن؛ طلاییِ محبوب با برچسب و ستاره‌ی گوشه.
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.isCurrent,
    required this.isSelected,
    required this.onSelect,
  });

  final SubscriptionPlan plan;
  final bool isCurrent;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final style = plan.kind;
    final card = SubCard(
      radius: SubSizes.cardRadius,
      color: plan.isPopular ? SubColors.goldTint : null,
      border: plan.isPopular
          ? Border.all(color: SubColors.goldBorder, width: 1.5)
          : Border.all(color: style.accent.withOpacity(.22)),
      padding: const EdgeInsets.all(SubSizes.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: SubText.planName(context)),
                    const SizedBox(height: 2),
                    Text(plan.tagline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: SubText.caption(context)),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.md),
              SubIconBubble(
                icon: plan.icon,
                size: SubSizes.planBubble,
                color: style.accent,
                background: style.bubble,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            faNumber(plan.price),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: SubText.price(context),
          ),
          const SizedBox(height: 2),
          Text('تومان',
              textAlign: TextAlign.center, style: SubText.unit(context)),
          const SizedBox(height: AppSizes.lg),
          _PlanButton(
            plan: plan,
            isCurrent: isCurrent,
            isSelected: isSelected,
            onSelect: onSelect,
          ),
          const SizedBox(height: AppSizes.md),
          Text(plan.period,
              textAlign: TextAlign.center, style: SubText.caption(context)),
        ],
      ),
    );

    if (!plan.isPopular) return card;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        const PositionedDirectional(
          top: 12,
          start: 12,
          child: SubPill(
            label: 'محبوب‌ترین',
            color: SubColors.goldBright,
            filled: true,
            height: SubSizes.planBadgeHeight,
          ),
        ),
        PositionedDirectional(
          top: -8,
          end: 16,
          child: Container(
            width: SubSizes.planStarCircle,
            height: SubSizes.planStarCircle,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [SubColors.goldBright, SubColors.gold],
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.star_rounded,
                size: AppSizes.buttonIconSize, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

/// دکمه‌ی هر کارت: اشتراک فعلی پر، بقیه خط‌کشی.
class _PlanButton extends StatelessWidget {
  const _PlanButton({
    required this.plan,
    required this.isCurrent,
    required this.isSelected,
    required this.onSelect,
  });

  final SubscriptionPlan plan;
  final bool isCurrent;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final accent = plan.kind.accent;
    if (isCurrent) {
      return SubGradientButton(
        label: 'اشتراک فعلی',
        colors: const [SubColors.goldBright, SubColors.gold],
        height: SubSizes.planButtonHeight,
        onPressed: onSelect,
      );
    }
    return OutlinedButton(
      onPressed: onSelect,
      style: OutlinedButton.styleFrom(
        foregroundColor: accent,
        side: BorderSide(
          color: isSelected ? accent : accent.withOpacity(.55),
          width: isSelected ? 1.8 : 1.2,
        ),
        minimumSize: const Size(0, SubSizes.planButtonHeight),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SubSizes.buttonRadius),
        ),
      ),
      child: Text('انتخاب پلن ${plan.title}', style: SubText.button(context)),
    );
  }
}
