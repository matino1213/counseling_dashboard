import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:counseling_dashboard/app/app.dart';
import 'package:counseling_dashboard/features/auth/presentation/login_page.dart';
import 'package:counseling_dashboard/features/dashboard/presentation/dashboard_page.dart';
import 'package:counseling_dashboard/features/subscription/presentation/subscription_page.dart';

Widget app() => const ProviderScope(child: CounselingApp());

void main() {
  testWidgets('صفحه اصلی راست‌چین است و هر چهار ورودی را نشان می‌دهد',
      (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(Directionality.of(tester.element(find.byType(DashboardPage))),
        TextDirection.rtl);
    for (final title in [
      'ورود به سامانه فروش اقساط',
      'اشتراک من',
      'آزمون‌های من',
      'دوره‌های من',
    ]) {
      expect(find.text(title), findsOneWidget, reason: 'عنوان $title یافت نشد');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('لمس یک کارت، صفحه مربوط را باز می‌کند و سرصفحه‌ی داخلی دارد',
      (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('اشتراک من'));
    await tester.pumpAndSettle();

    expect(find.byType(SubscriptionPage), findsOneWidget);
    // اپ‌بار حذف است؛ عنوان و زیرعنوان داخل کانتنت نمایش داده می‌شوند.
    expect(find.byTooltip('بازگشت'), findsNothing);
    expect(find.text('مدیریت و ارتقای اشتراک'), findsOneWidget);

    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await tester.pumpAndSettle();
    expect(find.byType(DashboardPage), findsOneWidget);
  });

  testWidgets('کارت «ورود به سامانه فروش اقساط» صفحه ورود را باز می‌کند',
      (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('ورود به سامانه فروش اقساط'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byKey(const Key('usernameField')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('روی گوشی کارت‌ها یک‌ستونه و روی ویندوز دوستونه‌اند',
      (tester) async {
    Future<void> pumpAtLogicalWidth(double width) async {
      tester.view.devicePixelRatio = 2;
      tester.view.physicalSize = Size(width * 2, 1600 * 2);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
    }

    double topOf(String label) => tester.getTopLeft(find.text(label)).dy;

    await pumpAtLogicalWidth(400);
    // گوشی: تک‌ستون؛ ترتیب کارت‌ها از بالا به پایین حفظ می‌شود.
    final phoneTops = [
      topOf('ورود به سامانه فروش اقساط'),
      topOf('اشتراک من'),
      topOf('آزمون‌های من'),
      topOf('دوره‌های من'),
    ];
    expect(phoneTops[0], lessThan(phoneTops[1]));
    expect(phoneTops[1], lessThan(phoneTops[2]));
    expect(phoneTops[2], lessThan(phoneTops[3]));

    await pumpAtLogicalWidth(1440);
    // ویندوز: دو ستون؛ دو کارت اول در یک ردیف و دو کارت بعدی در ردیف پایین‌تر.
    expect(topOf('ورود به سامانه فروش اقساط'), closeTo(topOf('اشتراک من'), 1));
    expect(topOf('آزمون‌های من'), closeTo(topOf('دوره‌های من'), 1));
    expect(topOf('آزمون‌های من'), greaterThan(topOf('اشتراک من')));

    // راست‌چین: آیتم اول در سمت راست ردیف قرار می‌گیرد.
    expect(
      tester.getCenter(find.text('ورود به سامانه فروش اقساط')).dx,
      greaterThan(tester.getCenter(find.text('اشتراک من')).dx),
    );
    expect(tester.takeException(), isNull);
  });
}
