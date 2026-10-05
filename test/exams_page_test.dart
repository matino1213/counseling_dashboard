import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:counseling_dashboard/features/exams/presentation/exam_style.dart';
import 'package:counseling_dashboard/features/exams/presentation/exams_page.dart';
import 'package:counseling_dashboard/features/exams/presentation/widgets/exam_art.dart';
import 'package:counseling_dashboard/features/exams/presentation/widgets/exam_card.dart';
import 'package:counseling_dashboard/features/exams/presentation/widgets/exam_continue_banner.dart';
import 'package:counseling_dashboard/features/exams/presentation/widgets/exam_filter_bar.dart';
import 'package:counseling_dashboard/features/exams/presentation/widgets/exam_progress_bar.dart';

Widget _harness() => const ProviderScope(
      child: MaterialApp(
        locale: Locale('fa'),
        supportedLocales: [Locale('fa'), Locale('en')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: ExamsPage(),
      ),
    );

Future<void> _pumpAt(WidgetTester tester, double width) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 1114);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_harness());
  await tester.pumpAndSettle();
}

Finder _cards() => find.byType(ExamCard);

Finder _cardOf(String title) => find.ancestor(
      of: find.text(title),
      matching: find.byType(ExamCard),
    );

/// دکمه‌های M3 که با `.icon` ساخته می‌شوند زیرکلاس خصوصیِ همان دکمه‌اند،
/// پس `byType` آن‌ها را نمی‌بیند و باید با `is` جست‌وجو کرد.
Finder _filledButtons() => find.byWidgetPredicate((w) => w is FilledButton);

Finder _outlinedButtons() => find.byWidgetPredicate((w) => w is OutlinedButton);

/// چیپ وضعیت داخل نوار فیلتر؛ ممکن است از دیدۀ اسکرول بیرون باشد.
Future<void> _tapChip(WidgetTester tester, String label) async {
  final chip = find.descendant(
      of: find.byType(ExamFilterBar), matching: find.text(label));
  await tester.ensureVisible(chip);
  await tester.pumpAndSettle();
  await tester.tap(chip);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('صفحه راستچین است و کارت‌ها اندازه‌های طرح را دارند',
      (tester) async {
    await _pumpAt(tester, 1440);

    expect(Directionality.of(tester.element(find.byType(ExamsPage))),
        TextDirection.rtl);

    // محتوای صفحه ۱۱۰۰ پیکسل است و دو کارت ۵۴۲ پیکسلی با فاصله‌ی ۱۶.
    final neo = tester.getRect(_cardOf('آزمون شخصیت NEO'));
    final cattell = tester.getRect(_cardOf('آزمون شخصیت کتل'));
    expect(neo.width, 542);
    expect(cattell.width, 542);
    expect(neo.top, closeTo(cattell.top, 1));
    // دو کارت + فاصله = عرض محتوا (۵۴۲ + ۱۶ + ۵۴۲).
    expect(neo.right - cattell.left, closeTo(1100, 1));
    expect(cattell.right, lessThanOrEqualTo(neo.left));
    expect(neo.left - cattell.right, closeTo(16, 1));

    // ردیف دوم همان فاصله‌ی عمودی را دارد.
    final shakle = tester.getRect(_cardOf('آزمون شاکله'));
    expect(shakle.top - cattell.bottom, 16);

    expect(tester.getSize(find.byType(ExamContinueBanner)).height, 158);
    expect(
      tester
          .getSize(find.descendant(
            of: find.byType(ExamContinueBanner),
            matching: find.byType(ExamProgressBar),
          ))
          .height,
      12,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('آزمون‌ها به ترتیب آخرین فعالیت چیده می‌شوند', (tester) async {
    await _pumpAt(tester, 1440);

    final titles = _cards()
        .evaluate()
        .map((e) => find
            .descendant(
                of: find.byWidget(e.widget), matching: find.byType(Text))
            .evaluate()
            .map((c) => (c.widget as Text).data)
            .firstWhere((data) => data!.startsWith('آزمون')))
        .toList();
    expect(titles, [
      'آزمون شخصیت NEO',
      'آزمون شخصیت کتل',
      'آزمون شاکله',
      'آزمون تیپ شخصیتی MBTI',
    ]);
  });

  testWidgets('فیلتر وضعیت فقط کارت‌های همان وضعیت را نگه می‌دارد',
      (tester) async {
    await _pumpAt(tester, 1440);
    expect(_cards(), findsNWidgets(4));

    await _tapChip(tester, 'آماده شروع');

    // دو آزمون هنوز شروع‌نشده‌اند: NEO و MBTI.
    expect(_cards(), findsNWidgets(2));
    expect(find.text('آزمون تیپ شخصیتی MBTI'), findsOneWidget);
    expect(find.text('آزمون شاکله'), findsNothing);

    await _tapChip(tester, 'تکمیل‌شده');
    expect(_cards(), findsOneWidget);
    expect(find.text('آزمون شاکله'), findsOneWidget);

    await _tapChip(tester, 'همه آزمون‌ها');
    expect(_cards(), findsNWidgets(4));
  });

  testWidgets('جست‌وجو با عبارت خالی فهرست را برمی‌گرداند', (tester) async {
    await _pumpAt(tester, 1440);

    await tester.enterText(find.byType(TextField), 'شاکله');
    await tester.pumpAndSettle();
    expect(_cards(), findsOneWidget);

    await tester.tap(find.text('مشاهده همه آزمون‌ها'));
    await tester.pumpAndSettle();
    expect(_cards(), findsNWidgets(4));
  });

  testWidgets('شروع آزمون وضعیت کارت و بنر را به‌روز می‌کند', (tester) async {
    await _pumpAt(tester, 1440);

    await tester.tap(find.descendant(
      of: _cardOf('آزمون شخصیت NEO'),
      matching: find.text('شروع آزمون'),
    ));
    await tester.pumpAndSettle();

    final card = _cardOf('آزمون شخصیت NEO');
    expect(find.descendant(of: card, matching: find.text('ادامه آزمون')),
        findsOneWidget);
    expect(find.descendant(of: card, matching: find.text('۵٪ تکمیل شده')),
        findsOneWidget);
    // بنر ادامه هنوز روی آزمون کتل است.
    expect(find.text('۴۵٪ تکمیل شده'), findsOneWidget);
  });

  testWidgets('روی گوشی شبکه تک‌ستونه می‌شود', (tester) async {
    await _pumpAt(tester, 420);

    final neo = tester.getRect(_cardOf('آزمون شخصیت NEO'));
    final cattell = tester.getRect(_cardOf('آزمون شخصیت کتل'));
    expect(cattell.top, greaterThan(neo.bottom));
    expect(neo.width, closeTo(420 - 48, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('دکمه‌ها قدِ بلندتر و باکس جست‌وجو عرضِ طرح را دارد',
      (tester) async {
    await _pumpAt(tester, 1440);

    // همه‌ی دکمه‌های کارت‌ها: دو دکمه در هر چهار کارت.
    final cardButtons = find.descendant(
      of: _cards(),
      matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
    );
    expect(cardButtons, findsNWidgets(8));
    for (final element in cardButtons.evaluate()) {
      expect(
        tester.getSize(find.byWidget(element.widget)).height,
        ExamSizes.buttonHeight,
      );
    }
    // باکس جست‌وجو ۳۰۰ پیکسل است؛ متنِ داخلش یک پیکسل حاشیه از هر طرف کم می‌گیرد.
    expect(
      tester.getSize(find.byType(TextField)).width,
      ExamSizes.searchWidth - 2,
    );
    // دکمه‌ی «مشاهده همه آزمون‌ها» هم بلندتر شده است.
    expect(
      tester
          .getSize(find.ancestor(
            of: find.text('مشاهده همه آزمون‌ها'),
            matching: _outlinedButtons(),
          ))
          .height,
      ExamSizes.viewAllHeight,
    );
    // دکمه‌ی بنر «ادامه آزمون».
    expect(
      tester
          .getSize(find.descendant(
            of: find.byType(ExamContinueBanner),
            matching: _filledButtons(),
          ))
          .height,
      ExamSizes.bannerButtonHeight,
    );
  });

  testWidgets('نشانِ روی تصویر کارت هم‌اندازه‌ی طرح است', (tester) async {
    await _pumpAt(tester, 1440);

    final card = _cardOf('آزمون شخصیت کتل');
    final art = find.descendant(of: card, matching: find.byType(ExamArt));
    final badge =
        find.descendant(of: card, matching: find.byType(ExamArtBadge));
    final artRect = tester.getRect(art);
    final badgeRect = tester.getRect(badge);

    expect(artRect.height, ExamSizes.artHeight);
    expect(badgeRect.height, ExamSizes.artBadgeHeight);
    expect(badgeRect.width, greaterThanOrEqualTo(ExamSizes.artBadgeMinWidth));
    // در چیدمان راست‌به‌چپ «start» همان لبه‌ی راست تصویر است.
    expect(artRect.right - badgeRect.right, ExamSizes.artBadgeInset);
    expect(badgeRect.top - artRect.top, ExamSizes.artBadgeTop);

    // تصویر از فایل برش‌خورده‌ی همان آزمون می‌آید، نه از متن.
    expect(
      tester.widget<ExamArt>(art).illustration,
      'assets/images/exams/cattell.png',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('نشان بنر کوتاه و چسبیده به راست است و نام آزمون متن نیست',
      (tester) async {
    await _pumpAt(tester, 1440);

    final badge = find.byWidgetPredicate((widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).color ==
            ExamColors.bannerBadgeBackground);
    expect(badge, findsOneWidget);

    // نشان به محتوایش جمع می‌شود، نه به پهنای ستون متن (۶۲۸ پیکسل).
    final badgeRect = tester.getRect(badge);
    expect(badgeRect.width, lessThan(400));
    expect(badgeRect.height, ExamSizes.bannerBadgeHeight);

    final banner = tester.getRect(find.byType(ExamContinueBanner));
    expect(banner.right - badgeRect.right,
        closeTo(ExamSizes.bannerArtWidth + 8, 1));

    // نام آزمون بخشی از تصویر است، پس روی تصویر متن نوشته نمی‌شود.
    expect(find.text('CATTELL'), findsNothing);
    expect(find.text('NEO'), findsNothing);
    expect(find.text('MBTI'), findsNothing);
  });
}
