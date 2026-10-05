import 'package:flutter/material.dart';

import '../../../../app/responsive/responsive.dart';
import '../../../../app/theme/app_sizes.dart';
import '../subscription_design.dart';
import 'subscription_primitives.dart';

/// بنر «دعوت از دوستان» با تصویر هدیه و دکمه‌ی سبز.
class SubscriptionReferralBanner extends StatelessWidget {
  const SubscriptionReferralBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('با دعوت دوستتان، اشتراک رایگان دریافت کنید!',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: SubText.bannerTitle(context)),
        const SizedBox(height: 4),
        Text('با دعوت هر دوست تا ۳۰ روز اشتراک رایگان هدیه بگیرید.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: SubText.body(context)),
      ],
    );

    final button = SubGradientButton(
      label: 'دعوت از دوستان',
      icon: Icons.person_add_alt_1_outlined,
      colors: const [SubColors.greenTop, SubColors.greenBottom],
      height: SubSizes.bannerButtonHeight,
      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'لینک دعوت آماده شد؛ آن را با دوستانتان به اشتراک بگذارید.')),
      ),
    );

    final art = context.isCompact
        ? const SizedBox.shrink()
        : Image.asset(
            'assets/illustrations/referral_gift.png',
            height: SubSizes.bannerArtHeight,
            fit: BoxFit.contain,
            semanticLabel: 'جعبه‌ی هدیه‌ی دعوت',
            errorBuilder: (context, error, stack) => const SizedBox(
              width: SubSizes.bannerArtHeight,
              height: SubSizes.bannerArtHeight,
            ),
          );

    return SubCard(
      height: context.isCompact ? null : SubSizes.bannerHeight,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [SubColors.mintCardTop, SubColors.mintCardBottom],
      ),
      padding: EdgeInsets.symmetric(
          horizontal: SubSizes.cardPadding,
          vertical: context.isCompact ? AppSizes.lg : 0),
      clip: true,
      child: context.isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                texts,
                const SizedBox(height: AppSizes.lg),
                Center(child: button),
              ],
            )
          : Row(
              children: [
                Expanded(child: texts),
                const SizedBox(width: AppSizes.lg),
                button,
                const SizedBox(width: AppSizes.xl),
                art,
              ],
            ),
    );
  }
}
