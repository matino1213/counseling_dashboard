import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/responsive/responsive.dart';
import '../../../../app/theme/app_sizes.dart';
import '../providers/subscription_providers.dart';
import '../subscription_design.dart';
import 'subscription_primitives.dart';

/// کارت «اعتبار باقی‌مانده اشتراک»: نشان اشتراک، مهلت پایان و نوار پیشرفت.
class SubscriptionStatusCard extends ConsumerWidget {
  const SubscriptionStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(currentSubscriptionProvider);
    final card = SubCard(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [SubColors.mintCardTop, SubColors.mintCardBottom],
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: SubSizes.cardPadding, vertical: 16),
      child: context.isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TierBlock(subscription: subscription),
                const _BlockGap(vertical: true),
                _ExpiryBlock(subscription: subscription),
                const _BlockGap(vertical: true),
                _RemainingBlock(subscription: subscription),
              ],
            )
          : Row(
              children: [
                Expanded(
                    flex: 3, child: _TierBlock(subscription: subscription)),
                const _BlockGap(),
                Expanded(
                    flex: 2, child: _ExpiryBlock(subscription: subscription)),
                const _BlockGap(),
                Expanded(
                    flex: 3,
                    child: _RemainingBlock(subscription: subscription)),
              ],
            ),
    );

    return context.isCompact
        ? card
        : SizedBox(height: SubSizes.statusHeight, child: card);
  }
}

/// فاصله‌ی میان بلاک‌ها به‌همراه خط جداکننده‌ی کم‌رنگ.
class _BlockGap extends StatelessWidget {
  const _BlockGap({this.vertical = false});

  final bool vertical;

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: SubSizes.cardPadding),
          Container(height: 1, color: SubColors.mintDivider),
          const SizedBox(height: SubSizes.cardPadding),
        ],
      );
    }
    return const Row(
      children: [
        SizedBox(width: SubSizes.cardPadding),
        SizedBox(
          height: SubSizes.statusCircle,
          child: VerticalDivider(
              width: 1, thickness: 1, color: SubColors.mintDivider),
        ),
        SizedBox(width: SubSizes.cardPadding),
      ],
    );
  }
}

/// بلاک سمت راست: سپر، مدال تاج، نام اشتراک و وضعیت.
class _TierBlock extends StatelessWidget {
  const _TierBlock({required this.subscription});

  final CurrentSubscription subscription;

  @override
  Widget build(BuildContext context) {
    final name = Text(subscription.tierTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: SubText.tierName(context));
    final status = SubPill(
      label: subscription.statusLabel,
      color: SubColors.green,
      height: SubSizes.tierPillHeight,
    );

    return Row(
      children: [
        const SubMedallion(
          size: SubSizes.statusCircle,
          icon: Icons.workspace_premium_rounded,
          iconColor: SubColors.goldBright,
        ),
        const SizedBox(width: AppSizes.lg),
        Expanded(
          // در طرح مرجع بج کنار نام است؛ در عرض کم جا نمی‌شود و زیرش می‌رود.
          child: context.isExpanded
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: name),
                    const SizedBox(width: AppSizes.md),
                    status,
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    name,
                    const SizedBox(height: 6),
                    status,
                  ],
                ),
        ),
      ],
    );
  }
}

/// بلاک میانی: روزهای باقی‌مانده و تاریخ پایان.
class _ExpiryBlock extends StatelessWidget {
  const _ExpiryBlock({required this.subscription});

  final CurrentSubscription subscription;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month_outlined,
                size: 22, color: SubColors.ink),
            const SizedBox(width: 10),
            Expanded(
              child: Text(subscription.daysLeftLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SubText.cardTitle(context)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(subscription.expiryLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: SubText.body(context)),
        const SizedBox(height: 2),
        Text(subscription.purchaseHint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: SubText.body(context)),
      ],
    );
  }
}

/// بلاک سمت چپ: درصد سپری‌شده از دوره و نوار آن.
class _RemainingBlock extends StatelessWidget {
  const _RemainingBlock({required this.subscription});

  final CurrentSubscription subscription;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('اعتبار باقی‌مانده اشتراک',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: SubText.cardTitle(context)),
        const SizedBox(height: 4),
        Text(subscription.elapsedLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: SubText.body(context)),
        const SizedBox(height: 10),
        SubProgressBar(
            value: subscription.elapsedPercent,
            height: SubSizes.progressHeight),
      ],
    );
  }
}
