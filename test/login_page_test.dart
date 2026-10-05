import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:counseling_dashboard/app/app_features.dart';
import 'package:counseling_dashboard/features/auth/presentation/login_page.dart';
import 'package:counseling_dashboard/features/auth/presentation/widgets/login_form_card.dart';

Widget loginApp() => MaterialApp(
      locale: const Locale('fa'),
      initialRoute: AppRoute.login,
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => switch (settings.name) {
          AppRoute.login => const Directionality(
              textDirection: TextDirection.rtl,
              child: ProviderScope(child: LoginPage()),
            ),
          _ => const Scaffold(body: Text('داشبورد')),
        },
      ),
    );

Future<void> pumpAt(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(loginApp());
  await tester.pumpAndSettle();
}

TextField fieldOf(WidgetTester tester, String keyName) => tester.widget(
      find
          .descendant(
            of: find.byKey(Key(keyName)),
            matching: find.byType(TextField),
          )
          .first,
    );

void main() {
  testWidgets('در ویندوز ۱۲۸۰×۹۶۰ ابعاد کارت مطابق بوم طرح است',
      (tester) async {
    await pumpAt(tester, const Size(1280, 960));

    final card = tester.getRect(find.byKey(const Key('loginCard')));
    expect(card.width, closeTo(539, 1));
    expect(card.right, closeTo(1280 - 37, 1));

    final info = tester.getRect(find.byKey(const Key('infoBox')));
    expect(info.width, closeTo(card.width - 2 * 38, 1));
    expect(info.height, closeTo(72, 1));

    final username = tester.getRect(find.byKey(const Key('usernameField')));
    expect(username.height, closeTo(52, 1));
    expect(username.width, closeTo(info.width, 1));

    final password = tester.getRect(find.byKey(const Key('passwordField')));
    expect(password.height, closeTo(52, 1));

    final button = tester.getRect(find.byKey(const Key('submitButton')));
    expect(button.height, closeTo(52, 1));
    expect(button.width, closeTo(info.width, 1));

    final secure = tester.getRect(find.byKey(const Key('secureBox')));
    expect(secure.height, closeTo(72, 1));

    expect(tester.takeException(), isNull);
  });

  testWidgets('چیدمان راست‌به‌چپ: چک‌باکس راست و بازیابی چپ است',
      (tester) async {
    await pumpAt(tester, const Size(1280, 960));

    final checkbox =
        tester.getCenter(find.byKey(const Key('rememberCheckbox'))).dx;
    final recovery = tester.getCenter(find.text('بازیابی رمز عبور')).dx;
    expect(checkbox, greaterThan(recovery));

    // کارت ویژگی‌ها: گزارش‌ها راست‌ترین و مشتریان چپ‌ترین.
    expect(
      tester.getCenter(find.text('گزارش‌ها')).dx,
      greaterThan(tester.getCenter(find.text('پرداخت‌ها')).dx),
    );
    expect(
      tester.getCenter(find.text('مشتریان')).dx,
      lessThan(tester.getCenter(find.text('قراردادها')).dx),
    );
  });

  testWidgets('آیکون رمز: چشم راست و قفل چپِ فیلد است', (tester) async {
    await pumpAt(tester, const Size(1280, 960));

    final field = tester.getRect(find.byKey(const Key('passwordField')));
    final eye = tester.getCenter(find.byIcon(Icons.visibility_off_outlined));
    final lock = tester.getCenter(find.byIcon(Icons.lock_outline));
    expect(eye.dx, greaterThan(field.center.dx));
    expect(lock.dx, lessThan(field.center.dx));
  });

  testWidgets('استیت ریورپود: نمایش/پنهان رمز و تیک «مرا به خاطر بسپار»',
      (tester) async {
    await pumpAt(tester, const Size(1280, 960));

    expect(fieldOf(tester, 'passwordField').obscureText, isTrue);
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pumpAndSettle();
    expect(fieldOf(tester, 'passwordField').obscureText, isFalse);
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

    final box = find.byKey(const Key('rememberCheckbox'));
    expect(tester.widget<Checkbox>(box).value, isTrue);
    await tester.tap(box);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(box).value, isFalse);
  });

  testWidgets('ارسال خالی خطا می‌دهد و پرکردن فیلدها به داشبورد می‌رود',
      (tester) async {
    await pumpAt(tester, const Size(1280, 960));

    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pumpAndSettle();
    expect(find.text('نام کاربری را وارد کنید.'), findsOneWidget);
    expect(find.text('رمز عبور را وارد کنید.'), findsOneWidget);

    await tester.enterText(
        find
            .descendant(
              of: find.byKey(const Key('usernameField')),
              matching: find.byType(TextField),
            )
            .first,
        'admin');
    await tester.enterText(
        find
            .descendant(
              of: find.byKey(const Key('passwordField')),
              matching: find.byType(TextField),
            )
            .first,
        '1234');
    await tester.pumpAndSettle();
    expect(find.text('نام کاربری را وارد کنید.'), findsNothing);

    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byType(LoginFormCard), findsNothing);
  });

  testWidgets('در گوشی ۴۰۰ پیکسلی سرریز ندارد و کارت تمام‌عرض است',
      (tester) async {
    await pumpAt(tester, const Size(400, 800));

    final card = tester.getRect(find.byKey(const Key('loginCard')));
    expect(card.width, lessThanOrEqualTo(400 - 32 + 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('در ارتفاع کمِ ویندوز صفحه اسکرول می‌شود بدون سرریز',
      (tester) async {
    await pumpAt(tester, const Size(1280, 620));
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(LoginPage), const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
