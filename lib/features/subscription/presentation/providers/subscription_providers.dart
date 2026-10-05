import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../subscription_design.dart';

/// نوع پلن اشتراک.
enum PlanKind { diamond, gold, basic }

/// یک پلن قابل خریداری در بخش «انتخاب اشتراک».
class SubscriptionPlan {
  const SubscriptionPlan({
    required this.kind,
    required this.title,
    required this.tagline,
    required this.price,
    required this.period,
    this.icon = Icons.workspace_premium_rounded,
    this.isPopular = false,
  });

  final PlanKind kind;
  final String title;
  final String tagline;
  final int price;
  final String period;
  final IconData icon;
  final bool isPopular;

  String get id => kind.name;
}

/// وضعیت اشتراک فعال کاربر، برای کارت «اعتبار باقی‌مانده».
class CurrentSubscription {
  const CurrentSubscription({
    required this.tierTitle,
    required this.statusLabel,
    required this.daysLeftLabel,
    required this.expiryLabel,
    required this.purchaseHint,
    required this.elapsedLabel,
    required this.elapsedPercent,
    required this.currentPlanId,
  });

  final String tierTitle;
  final String statusLabel;
  final String daysLeftLabel;
  final String expiryLabel;
  final String purchaseHint;
  final String elapsedLabel;

  /// سهم سپری‌شده از دوره، بین صفر و یک.
  final double elapsedPercent;
  final String currentPlanId;
}

/// مقدار یک خانه در جدول مقایسه: متن، تیک سبز یا ضربدر.
class FeatureCell {
  const FeatureCell.text(String value)
      : label = value,
        included = null;
  const FeatureCell.included()
      : label = null,
        included = true;
  const FeatureCell.excluded()
      : label = null,
        included = false;

  final String? label;
  final bool? included;
}

/// یک ردیف جدول «مقایسه امکانات پلن‌ها».
class SubscriptionFeature {
  const SubscriptionFeature({
    required this.label,
    required this.icon,
    required this.tint,
    required this.accent,
    required this.diamond,
    required this.gold,
    required this.basic,
    this.hint,
  });

  final String label;
  final String? hint;
  final IconData icon;
  final Color tint;
  final Color accent;
  final FeatureCell diamond;
  final FeatureCell gold;
  final FeatureCell basic;

  bool get isTall => hint != null;
}

/// راهنمای کوتاه که با چیپ «راهنمای اشتراک» باز می‌شود.
const List<String> _guideNotes = [
  'هر زمان پلن خود را عوض کنید، هزینه‌ی روزهای باقی‌مانده به پلن جدید منتقل می‌شود.',
  'امکانات پلن جدید بلافاصله پس از پرداخت فعال می‌شود.',
  'لغو اشتراک، دسترسی تا پایان دوره‌ی پرداختی را حفظ می‌کند.',
];

/// چیپ‌های راهنمای اشتراک.
final subscriptionGuideNotesProvider = Provider<List<String>>(
  (ref) => _guideNotes,
);

/// پلن‌ها از راست به چپ، همان ترتیب طرح مرجع.
final subscriptionPlansProvider = Provider<List<SubscriptionPlan>>(
  (ref) => const [
    SubscriptionPlan(
      kind: PlanKind.diamond,
      title: 'الماس',
      tagline: 'کامل‌ترین تجربه',
      price: 1690000,
      period: '۱ ماهه',
      icon: Icons.diamond_outlined,
    ),
    SubscriptionPlan(
      kind: PlanKind.gold,
      title: 'طلایی',
      tagline: 'بیشترین امکانات',
      price: 990000,
      period: '۱ ماهه',
      isPopular: true,
    ),
    SubscriptionPlan(
      kind: PlanKind.basic,
      title: 'پایه',
      tagline: 'مناسب برای شروع',
      price: 490000,
      period: '۱ ماهه',
      icon: Icons.star_outline_rounded,
    ),
  ],
);

/// اشتراک فعال فعلی؛ در فاز بعد از سرویس بک‌اند خوانده می‌شود.
final currentSubscriptionProvider = Provider<CurrentSubscription>(
  (ref) => const CurrentSubscription(
    tierTitle: 'اشتراک طلایی',
    statusLabel: 'فعال',
    daysLeftLabel: '۲۳ روز باقی‌مانده',
    expiryLabel: 'تاریخ پایان: ۱۴۰۳/۰۴/۱۵',
    purchaseHint: 'خرید از طریق وب سایت',
    elapsedLabel: '۷۷٪ از دوره گذشته است',
    elapsedPercent: 0.77,
    currentPlanId: 'gold',
  ),
);

/// ردیف‌های جدول مقایسه.
final subscriptionFeaturesProvider = Provider<List<SubscriptionFeature>>(
  (ref) => const [
    SubscriptionFeature(
      label: 'مشاهده پیشنهادها',
      icon: Icons.group_outlined,
      tint: SubColors.greenTint,
      accent: SubColors.green,
      diamond: FeatureCell.text('نامحدود'),
      gold: FeatureCell.text('نامحدود'),
      basic: FeatureCell.text('۵ مورد در روز'),
    ),
    SubscriptionFeature(
      label: 'جلسات مشاوره',
      icon: Icons.headset_mic_outlined,
      tint: SubColors.violetTint,
      accent: SubColors.violet,
      diamond: FeatureCell.text('۸ جلسه در ماه'),
      gold: FeatureCell.text('۴ جلسه در ماه'),
      basic: FeatureCell.text('۱ جلسه در ماه'),
    ),
    SubscriptionFeature(
      label: 'آزمون‌های شخصیت',
      icon: Icons.science_outlined,
      tint: SubColors.goldBubble,
      accent: SubColors.gold,
      diamond: FeatureCell.included(),
      gold: FeatureCell.included(),
      basic: FeatureCell.text('۲ آزمون'),
    ),
    SubscriptionFeature(
      label: 'تماس و گفت‌وگوی خصوصی',
      icon: Icons.forum_outlined,
      tint: SubColors.blueTint,
      accent: SubColors.blue,
      diamond: FeatureCell.included(),
      gold: FeatureCell.included(),
      basic: FeatureCell.text('محدود'),
    ),
    SubscriptionFeature(
      label: 'جلسات آشنایی آنلاین',
      icon: Icons.videocam_outlined,
      tint: Color(0xFFFDE8E8),
      accent: SubColors.danger,
      diamond: FeatureCell.text('نامحدود'),
      gold: FeatureCell.text('۲ جلسه در ماه'),
      basic: FeatureCell.excluded(),
    ),
    SubscriptionFeature(
      label: 'مشاهده اطلاعات تماس',
      hint: 'پس از تأیید دو طرف',
      icon: Icons.phone_outlined,
      tint: SubColors.goldBubble,
      accent: SubColors.goldBright,
      diamond: FeatureCell.included(),
      gold: FeatureCell.included(),
      basic: FeatureCell.excluded(),
    ),
    SubscriptionFeature(
      label: 'دوره‌های آموزشی',
      icon: Icons.menu_book_outlined,
      tint: SubColors.blueTint,
      accent: SubColors.blue,
      diamond: FeatureCell.text('دسترسی کامل'),
      gold: FeatureCell.text('دسترسی کامل'),
      basic: FeatureCell.text('محدود'),
    ),
    SubscriptionFeature(
      label: 'اولویت نمایش در جستجو',
      icon: Icons.star_outline_rounded,
      tint: SubColors.greenTint,
      accent: SubColors.green,
      diamond: FeatureCell.included(),
      gold: FeatureCell.included(),
      basic: FeatureCell.excluded(),
    ),
    SubscriptionFeature(
      label: 'پشتیبانی ویژه',
      icon: Icons.workspace_premium_rounded,
      tint: SubColors.violetTint,
      accent: SubColors.violet,
      diamond: FeatureCell.text('پشتیبانی VIP'),
      gold: FeatureCell.text('پشتیبانی ویژه'),
      basic: FeatureCell.text('پشتیبانی عادی'),
    ),
  ],
);

/// پلنی که کاربر در «انتخاب اشتراک» برگزیده است.
class SelectedPlanNotifier extends Notifier<String> {
  @override
  String build() => ref.watch(currentSubscriptionProvider).currentPlanId;

  void select(String planId) => state = planId;
}

final selectedPlanProvider =
    NotifierProvider<SelectedPlanNotifier, String>(SelectedPlanNotifier.new);

/// نمایش یا مخفی‌کردن جدول مقایسه.
class ComparisonVisibility extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final comparisonVisibleProvider =
    NotifierProvider<ComparisonVisibility, bool>(ComparisonVisibility.new);

/// باز یا بسته بودن راهنمای کوتاه اشتراک.
class GuideVisibility extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final guideVisibleProvider =
    NotifierProvider<GuideVisibility, bool>(GuideVisibility.new);
