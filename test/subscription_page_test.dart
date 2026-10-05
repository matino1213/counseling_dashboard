import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:counseling_dashboard/app/theme/app_theme.dart';
import 'package:counseling_dashboard/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:counseling_dashboard/features/subscription/presentation/subscription_design.dart';
import 'package:counseling_dashboard/features/subscription/presentation/subscription_page.dart';
import 'package:counseling_dashboard/features/subscription/presentation/widgets/subscription_comparison_section.dart';
import 'package:counseling_dashboard/features/subscription/presentation/widgets/subscription_status_card.dart';

Widget page() => MaterialApp(
      locale: const Locale('fa'),
      supportedLocales: const [Locale('fa'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: AppTheme.light(),
      home: const SubscriptionPage(),
    );

Future<void> pumpAtWidth(WidgetTester tester, double width,
    {double height = 1600}) async {
  tester.view.devicePixelRatio = 2;
  tester.view.physicalSize = Size(width * 2, height * 2);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(child: page()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('صفحه اشتراک راست‌چین است و کانتنت طرح را نشان می‌دهد',
      (tester) async {
    await pumpAtWidth(tester, 1440);

    expect(Directionality.of(tester.element(find.byType(SubscriptionPage))),
        TextDirection.rtl);

    for (final label in [
      'اشتراک من',
      'مدیریت و ارتقای اشتراک',
      'اشتراک طلایی',
      'فعال',
      '۲۳ روز باقی‌مانده',
      'تاریخ پایان: ۱۴۰۳/۰۴/۱۵',
      'خرید از طریق وب سایت',
      'اعتبار باقی‌مانده اشتراک',
      '۷۷٪ از دوره گذشته است',
      'انتخاب اشتراک',
      'مقایسه پلن‌ها',
      'محبوب‌ترین',
      'اشتراک فعلی',
      'انتخاب پلن الماس',
      'انتخاب پلن پایه',
      'مقایسه امکانات پلن‌ها',
      'جلسات مشاوره',
      'با دعوت دوستتان، اشتراک رایگان دریافت کنید!',
      'دعوت از دوستان',
    ]) {
      expect(find.text(label), findsWidgets, reason: '«$label» یافت نشد');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('سرصفحه داخل کانتنت است: تاج سبز کنار عنوان، بدون اپ‌بار',
      (tester) async {
    await pumpAtWidth(tester, 1440);

    expect(find.byTooltip('بازگشت'), findsNothing);
    final scaffold = tester.widget<Scaffold>(find
        .descendant(
          of: find.byType(SubscriptionPage),
          matching: find.byType(Scaffold),
        )
        .first);
    expect(scaffold.backgroundColor, SubColors.mintPage);

    final crown = tester.getRect(find.byKey(const Key('headerCrown')));
    final title = tester.getRect(find.text('اشتراک من'));
    final subtitle = tester.getRect(find.text('مدیریت و ارتقای اشتراک'));
    // تاج در ابتدای (سمت راست) عنوان و زیرعنوان هم‌خط با لبه‌ی بلوک است.
    expect(crown.right, greaterThan(title.right));
    expect(crown.center.dy, closeTo(title.center.dy, 6));
    expect(subtitle.right, closeTo(crown.right, 1));
    expect(subtitle.top, greaterThan(title.bottom));

    final titleStyle = tester
        .renderObject<RenderParagraph>(find.text('اشتراک من'))
        .text
        .style!;
    expect(titleStyle.fontWeight, FontWeight.w800);
    expect(tester.takeException(), isNull);
  });

  testWidgets('بج «فعال» کوچک و کنار نام اشتراک است', (tester) async {
    await pumpAtWidth(tester, 1440);

    final name = tester.getRect(find.text('اشتراک طلایی'));
    final pill = tester.getRect(find.text('فعال'));
    expect(find.text('فعال'), findsOneWidget);
    expect(pill.right, lessThan(name.left), reason: 'بج سمت چپ نام است');
    expect((pill.center.dy - name.center.dy).abs(), lessThan(8),
        reason: 'هم‌خط با نام، نه زیر آن');
    expect(pill.height, lessThan(name.height * .7));
    // سپر تیک‌دار حذف شده تا نام اشتراک کامل جا شود.
    expect(find.byIcon(Icons.check_rounded), findsNothing);
  });

  testWidgets('دکمه مقایسه پلن‌ها بدون کادر و با ایکون در سمت چپ است',
      (tester) async {
    await pumpAtWidth(tester, 1440);

    final label = find.text('مقایسه پلن‌ها');
    expect(find.ancestor(of: label, matching: find.byType(OutlinedButton)),
        findsNothing);
    final text = tester.getRect(label);
    final icon = tester.getRect(find.byIcon(Icons.balance_outlined));
    expect(icon.right, lessThan(text.left), reason: 'ایکون سمت چپ متن است');
    expect(tester.renderObject<RenderParagraph>(label).text.style!.color,
        SubColors.ink);
  });

  testWidgets('قیمت‌ها با ارقام فارسی و جداکننده هزارگان نوشته می‌شوند',
      (tester) async {
    await pumpAtWidth(tester, 1440);
    for (final price in ['۱,۶۹۰,۰۰۰', '۹۹۰,۰۰۰', '۴۹۰,۰۰۰']) {
      expect(find.text(price), findsOneWidget, reason: 'قیمت $price نبود');
    }
    expect(faNumber(1690000), '۱,۶۹۰,۰۰۰');
    expect(faNumber(990000), '۹۹۰,۰۰۰');
    expect(faNumber(7000), '۷,۰۰۰');
    expect(faNumber(0), '۰');
  });

  testWidgets('کارت وضعیت دقیقاً ارتفاع طرح مرجع را دارد', (tester) async {
    await pumpAtWidth(tester, 1440);

    expect(tester.getSize(find.byType(SubscriptionStatusCard)).height,
        SubSizes.statusHeight);
    expect(tester.getTopLeft(find.text('انتخاب اشتراک')).dx,
        greaterThan(tester.getTopLeft(find.text('مقایسه پلن‌ها')).dx),
        reason: 'سرصفحه بخش راست و چیپ مقایسه چپ است');
  });

  testWidgets('کارت‌های پلن از راست به چپ: الماس، طلایی، پایه', (tester) async {
    await pumpAtWidth(tester, 1440);

    double centerX(String label) => tester.getCenter(find.text(label)).dx;
    expect(centerX('کامل‌ترین تجربه'), greaterThan(centerX('بیشترین امکانات')));
    expect(centerX('بیشترین امکانات'), greaterThan(centerX('مناسب برای شروع')));
  });

  testWidgets('انتخاب پلن فقط انتخاب می‌کند و صفحه را عوض نمی‌کند',
      (tester) async {
    await pumpAtWidth(tester, 1440);
    final scope = ProviderScope.containerOf(
        tester.element(find.byType(SubscriptionPage)));

    expect(scope.read(selectedPlanProvider), 'gold');
    await tester.tap(find.text('انتخاب پلن الماس'));
    await tester.pumpAndSettle();

    expect(scope.read(selectedPlanProvider), 'diamond');
    expect(find.byType(SubscriptionPage), findsOneWidget);
  });

  testWidgets('چیپ «مقایسه پلن‌ها» جدول را باز و بسته می‌کند', (tester) async {
    await pumpAtWidth(tester, 1440);

    expect(find.text('مقایسه امکانات پلن‌ها'), findsOneWidget);
    await tester.tap(find.text('مقایسه پلن‌ها'));
    await tester.pumpAndSettle();
    expect(find.text('مقایسه امکانات پلن‌ها'), findsNothing);

    await tester.tap(find.text('مقایسه پلن‌ها'));
    await tester.pumpAndSettle();
    expect(find.text('مقایسه امکانات پلن‌ها'), findsOneWidget);
  });

  testWidgets('راهنمای اشتراک بسته است و با چیپش باز می‌شود', (tester) async {
    await pumpAtWidth(tester, 1440);
    expect(find.textContaining('هزینه‌ی روزهای باقی‌مانده'), findsNothing);

    await tester.tap(find.text('راهنمای اشتراک'));
    await tester.pumpAndSettle();
    expect(find.textContaining('هزینه‌ی روزهای باقی‌مانده'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('روی گوشی بخش‌ها روی هم می‌نشینند و سرریز نمی‌دهند',
      (tester) async {
    await pumpAtWidth(tester, 400, height: 2200);

    double topOf(String label) => tester.getTopLeft(find.text(label)).dy;
    expect(topOf('کامل‌ترین تجربه'), lessThan(topOf('بیشترین امکانات')));
    expect(topOf('بیشترین امکانات'), lessThan(topOf('مناسب برای شروع')));
    expect(tester.getSize(find.byType(SubscriptionStatusCard)).height,
        greaterThan(SubSizes.statusHeight));
    expect(tester.takeException(), isNull);
  });

  testWidgets('روی پنجره‌ی متوسط ویندوز هم سرریز افقی ندارد', (tester) async {
    await pumpAtWidth(tester, 800, height: 600);
    expect(tester.takeException(), isNull);
  });

  testWidgets('جدول مقایسه در عرض کم افقی اسکرول می‌شود', (tester) async {
    await pumpAtWidth(tester, 400, height: 2200);

    final scroller = find
        .descendant(
          of: find.byType(SubscriptionComparisonSection),
          matching: find.byType(SingleChildScrollView),
        )
        .last;
    expect(
      tester.widget<SingleChildScrollView>(scroller).scrollDirection,
      Axis.horizontal,
    );
    expect(tester.getRect(scroller).width,
        lessThan(SubSizes.minFeatureColumn + SubSizes.minPlanColumn * 3));
  });
}
