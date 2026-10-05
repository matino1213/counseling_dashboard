import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_features.dart';
import '../../../app/responsive/responsive.dart';
import '../../../app/theme/app_sizes.dart';
import 'providers/subscription_providers.dart';
import 'subscription_design.dart';
import 'widgets/subscription_comparison_section.dart';
import 'widgets/subscription_guide.dart';
import 'widgets/subscription_header.dart';
import 'widgets/subscription_plan_section.dart';
import 'widgets/subscription_referral_banner.dart';
import 'widgets/subscription_status_card.dart';

/// صفحه‌ی «اشتراک من»: سرصفحه، وضعیت اشتراک، انتخاب پلن، مقایسه و دعوت.
class SubscriptionPage extends ConsumerWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const feature = AppFeatures.subscription;
    final comparisonVisible = ref.watch(comparisonVisibleProvider);
    final guideVisible = ref.watch(guideVisibleProvider);
    final horizontal = AppSizes.pagePadding.resolve(context);
    final maxWidth = AppSizes.contentMaxWidth.resolve(context);

    return Scaffold(
      // سرصفحه‌ی برنامه در این صفحه حذف است؛ کل کانتنت روی نعنایی می‌نشیند.
      backgroundColor: SubColors.mintPage,
      body: SafeArea(
        bottom: false,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SubscriptionHeader(
                    title: feature.title,
                    subtitle: 'مدیریت و ارتقای اشتراک',
                  ),
                  const SizedBox(height: SubSizes.sectionGap),
                  if (guideVisible) ...[
                    const SubscriptionGuidePanel(),
                    const SizedBox(height: SubSizes.sectionGap),
                  ],
                  const SubscriptionStatusCard(),
                  const SizedBox(height: SubSizes.sectionGap),
                  const SubscriptionPlanSection(),
                  if (comparisonVisible) ...[
                    const SizedBox(height: SubSizes.sectionGap),
                    const SubscriptionComparisonSection(),
                  ],
                  const SizedBox(height: SubSizes.sectionGap),
                  const SubscriptionReferralBanner(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
