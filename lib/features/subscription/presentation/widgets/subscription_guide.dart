import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../providers/subscription_providers.dart';
import '../subscription_design.dart';
import 'subscription_primitives.dart';

/// چیپ «راهنمای اشتراک»؛ در سرصفحه قرار می‌گیرد و پنل راهنما را باز می‌کند.
class SubscriptionGuideChip extends ConsumerWidget {
  const SubscriptionGuideChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(guideVisibleProvider);
    return OutlinedButton(
      onPressed: () => ref.read(guideVisibleProvider.notifier).toggle(),
      style: OutlinedButton.styleFrom(
        foregroundColor: SubColors.ink,
        side: BorderSide(
          color: visible ? SubColors.green : AppColors.borderStrong,
        ),
        minimumSize: const Size(0, AppSizes.buttonHeightSm),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusControl),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            visible ? Icons.help_rounded : Icons.help_outline_rounded,
            size: AppSizes.buttonIconSize,
            color: visible ? SubColors.green : SubColors.muted,
          ),
          const SizedBox(width: AppSizes.sm),
          Text('راهنمای اشتراک', style: SubText.button(context)),
        ],
      ),
    );
  }
}

/// پنل راهنما؛ فقط وقتی کاربر آن را باز کرده باشد نمایش داده می‌شود.
class SubscriptionGuidePanel extends ConsumerWidget {
  const SubscriptionGuidePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(subscriptionGuideNotesProvider);
    return SubCard(
      color: SubColors.greenTint,
      padding: const EdgeInsets.all(SubSizes.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('راهنمای اشتراک', style: SubText.cardTitle(context)),
          const SizedBox(height: AppSizes.sm),
          for (final note in notes)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.circle, size: 6, color: SubColors.green),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(note, style: SubText.guide(context)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
