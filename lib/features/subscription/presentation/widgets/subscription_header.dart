import 'package:flutter/material.dart';

import '../../../../app/responsive/responsive.dart';
import '../../../../app/theme/app_sizes.dart';
import '../subscription_design.dart';
import 'subscription_guide.dart';

/// سرصفحه‌ی داخلی صفحه روی پس‌زمینه‌ی نعنایی: تاج سبز، عنوان، زیرعنوان و راهنما.
class SubscriptionHeader extends StatelessWidget {
  const SubscriptionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final heading = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium_rounded,
                key: Key('headerCrown'),
                size: SubSizes.headerCrown,
                color: SubColors.green),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SubText.pageTitle(context)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: SubText.pageSubtitle(context)),
      ],
    );

    if (!context.isCompact) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: heading),
          const SizedBox(width: AppSizes.lg),
          const SubscriptionGuideChip(),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        heading,
        const SizedBox(height: AppSizes.lg),
        const Align(
          alignment: AlignmentDirectional.centerStart,
          child: SubscriptionGuideChip(),
        ),
      ],
    );
  }
}
