import 'package:flutter/material.dart';

import '../login_style.dart';

/// ستون بازاریابی سمت چپ: بَج، تیتر و کارت‌های ویژگی.
class HeroPanel extends StatelessWidget {
  const HeroPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ProBadge(),
        SizedBox(height: 26),
        _HeroTitle(),
        SizedBox(height: 18),
        _FeatureRow(),
      ],
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('heroBadge'),
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3FD),
        borderRadius: BorderRadius.circular(LoginSizes.boxRadius),
        border: Border.all(color: const Color(0xFFDCE6F8)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insert_chart_outlined,
              color: LoginColors.primary, size: 18),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'مدیریت حرفه‌ای، رشد پایدار',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: LoginColors.inkSoft,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: LoginSizes.heroTextMaxWidth),
      child: const Column(
        children: [
          Text(
            'فروش اقساطی،',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: LoginColors.ink,
              fontSize: 32,
              height: 1.35,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text.rich(
            TextSpan(
              text: 'ساده‌تر ',
              style: TextStyle(
                color: LoginColors.primaryDeep,
                fontSize: 32,
                height: 1.35,
                fontWeight: FontWeight.w900,
              ),
              children: [
                TextSpan(
                  text: 'از همیشه',
                  style: TextStyle(color: LoginColors.ink),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 14),
          Text(
            'مدیریت قراردادها، پرداخت‌ها و مشتریان\nدر یک سامانه یکپارچه و امن',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: LoginColors.muted,
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

/// ترتیب فرزندان در Row راست‌به‌چپ، همان چیدمان بصری طرح است:
/// گزارش‌ها راست‌ترین و مشتریان چپ‌ترین کارت.
class _FeatureRow extends StatelessWidget {
  const _FeatureRow();

  static const _items = [
    _FeatureSpec(
      title: 'گزارش‌ها',
      caption: 'تحلیلی و کاربردی',
      icon: Icons.bar_chart_rounded,
      tint: Color(0xFFF1ECFE),
      accent: Color(0xFF7C5CFA),
    ),
    _FeatureSpec(
      title: 'پرداخت‌ها',
      caption: 'شفاف و دقیق',
      icon: Icons.savings_rounded,
      tint: Color(0xFFFEF0E0),
      accent: Color(0xFFF59E0B),
    ),
    _FeatureSpec(
      title: 'قراردادها',
      caption: 'سریع و مطمئن',
      icon: Icons.description_outlined,
      tint: Color(0xFFE8F0FE),
      accent: Color(0xFF2F6FB5),
    ),
    _FeatureSpec(
      title: 'مشتریان',
      caption: 'مدیریت یکپارچه',
      icon: Icons.groups_outlined,
      tint: Color(0xFFE6F4EB),
      accent: Color(0xFF16A34A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final singleRow = constraints.maxWidth >= 560;
        final cards = _items
            .map((spec) => _FeatureCard(spec: spec, key: ValueKey(spec.title)))
            .toList();
        if (singleRow) {
          return Row(
            key: const Key('featureRow'),
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                Expanded(child: cards[i]),
              ],
            ],
          );
        }
        return Column(
          children: [
            for (var r = 0; r < 2; r++) ...[
              if (r > 0) const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: cards[r * 2]),
                  const SizedBox(width: 16),
                  Expanded(child: cards[r * 2 + 1]),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _FeatureSpec {
  const _FeatureSpec({
    required this.title,
    required this.caption,
    required this.icon,
    required this.tint,
    required this.accent,
  });

  final String title;
  final String caption;
  final IconData icon;
  final Color tint;
  final Color accent;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({super.key, required this.spec});

  final _FeatureSpec spec;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: LoginSizes.heroCardHeight,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: LoginColors.ink.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: LoginSizes.heroIconTile,
            height: LoginSizes.heroIconTile,
            decoration: BoxDecoration(
              color: spec.tint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(spec.icon, color: spec.accent, size: 20),
          ),
          const SizedBox(height: 6),
          Text(
            spec.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: LoginColors.ink,
              fontSize: 14,
              height: 1.25,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            spec.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: LoginColors.muted, fontSize: 11, height: 1.25),
          ),
        ],
      ),
    );
  }
}
