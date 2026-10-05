import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:counseling_dashboard/features/courses/presentation/course_style.dart';
import 'package:counseling_dashboard/features/courses/presentation/courses_page.dart';
import 'package:counseling_dashboard/features/courses/presentation/widgets/continue_learning_banner.dart';
import 'package:counseling_dashboard/features/courses/presentation/widgets/course_card.dart';
import 'package:counseling_dashboard/features/courses/presentation/widgets/course_filter_bar.dart';
import 'package:counseling_dashboard/features/courses/presentation/widgets/course_primitives.dart';

Widget _harness() => const ProviderScope(
      child: MaterialApp(
        locale: Locale('fa'),
        supportedLocales: [Locale('fa'), Locale('en')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: CoursesPage(),
      ),
    );

/// عرض پنجره را ست می‌کند و صفحه را بالا می‌آورد.
Future<void> _pumpAt(WidgetTester tester, double width) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 1140);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_harness());
  await tester.pumpAndSettle();
}

Finder _cards() => find.byType(CourseCard);

Finder _cardOf(String title) => find.ancestor(
      of: find.text(title),
      matching: find.byType(CourseCard),
    );

Size _sizeOfCardPart(WidgetTester tester, String title, Type part) =>
    tester.getSize(find.descendant(
      of: _cardOf(title),
      matching: find.byType(part),
    ));

/// چیپ فیلتر را (که در حالت باریک اسکرول افقی دارد) دیده و لمس می‌کند.
Future<void> _tapChip(WidgetTester tester, String label) async {
  final chip = find.descendant(
      of: find.byType(CourseFilterBar), matching: find.text(label));
  await tester.ensureVisible(chip);
  await tester.pumpAndSettle();
  await tester.tap(chip);
  await tester.pumpAndSettle();
}

void main() {
  const hero = 'مهارت‌های گفت‌وگو و حل تعارض';
  const premarriage = 'شناخت پیش از ازدواج';
  const selfGrowth = 'خودشناسی و رشد فردی';
  const allTitles = [
    hero,
    premarriage,
    'مدیریت هیجان و خشم',
    'سواد مالی در زندگی مشترک',
    selfGrowth,
    'سبک‌های دلبستگی',
  ];

  testWidgets('صفحه راست‌چین است و اندازه‌های طرح نمونه را دارد',
      (tester) async {
    await _pumpAt(tester, 1440);

    expect(Directionality.of(tester.element(find.byType(CoursesPage))),
        TextDirection.rtl);

    // سه ستون روی محتوای ۱۰۹۱ پیکسلی با فاصله‌ی ۱۴: هر کارت ۳۵۴ پیکسل.
    final first = tester.getRect(_cardOf(hero));
    final second = tester.getRect(_cardOf(premarriage));
    final third = tester.getRect(_cardOf('مدیریت هیجان و خشم'));
    expect(first.width, closeTo(354.3, .5));
    expect(second.width, closeTo(354.3, .5));
    expect(third.width, closeTo(354.3, .5));
    expect(first.top, closeTo(second.top, 1));
    // راست‌چین: کارت اول از همه سمت راست‌تر است.
    expect(first.right, greaterThan(second.right));
    expect(second.right, greaterThan(third.right));
    expect(first.right - second.right, closeTo(368.3, .5));
    expect(first.left - second.right, closeTo(14, .5));
    expect(second.left - third.right, closeTo(14, .5));

    // بنر «ادامه یادگیری»: ارتفاع ۱۶۳، تصویر ۳۷۳ در ۱۴۹ و دکمه‌ی فراخوان هم‌قد بقیه‌ی صفحه‌ها.
    expect(tester.getSize(find.byType(ContinueLearningBanner)).height, 163);
    final bannerArt = tester.getSize(find.descendant(
      of: find.byType(ContinueLearningBanner),
      matching: find.image(
          const AssetImage('assets/images/courses/communication_skills.png')),
    ));
    expect(bannerArt.width, 373);
    expect(bannerArt.height, 149);
    final cta = tester.getSize(find.descendant(
      of: find.byType(ContinueLearningBanner),
      matching: find.byWidgetPredicate((widget) => widget is FilledButton),
    ));
    // قد دکمه‌ها از مقیاس مشترک برنامه است، نه از عدد اختصاصی صفحه.
    expect(cta.height, CourseSizes.bannerCtaHeight);
    // فونت تست هر حرف را یک خانه‌ی ثابت می‌گیرد، پس عرض فقط حداقلش تضمین‌شده است.
    expect(cta.width, greaterThanOrEqualTo(140));

    // بج بنر همان بج وضعیت کارت‌هاست و بالای عنوان، چسبان به سمت راست.
    final bannerBadge = tester.getRect(find.descendant(
      of: find.byType(ContinueLearningBanner),
      matching: find.byType(CourseArtBadge),
    ));
    final bannerTitle = tester.getRect(find.descendant(
      of: find.byType(ContinueLearningBanner),
      matching: find.text(hero),
    ));
    expect(bannerBadge.height, CourseSizes.badgeHeight);
    expect(bannerBadge.top, lessThan(bannerTitle.top));
    expect(bannerBadge.right, closeTo(bannerTitle.right, 1));

    // کارت: تصویر ۱۳۶ پیکسل، نوار پیشرفت ۱۲ پیکسل و بج هم‌قدِ بج‌های دیگر صفحه‌ها.
    expect(_sizeOfCardPart(tester, hero, CourseArt).height, 136);
    expect(_sizeOfCardPart(tester, hero, CourseProgressBar).height, 12);
    expect(_sizeOfCardPart(tester, hero, CourseArtBadge).height,
        CourseSizes.badgeHeight);
    final openButton = tester.getSize(find.descendant(
      of: _cardOf(premarriage),
      matching: find.byWidgetPredicate((widget) => widget is OutlinedButton),
    ));
    expect(openButton.height, CourseSizes.buttonHeight);
    // دکمه‌ی «مشاهده همه دوره‌ها» قدِ مشترک کنش‌های سرصفحه را دارد.
    expect(
        tester
            .getSize(find.ancestor(
              of: find.text('مشاهده همه دوره‌ها'),
              matching: find.byWidgetPredicate((w) => w is OutlinedButton),
            ))
            .height,
        CourseSizes.viewAllHeight);

    // نوار فیلتر: چیپ‌ها ۴۴، جست‌وجو ۲۹۰ و ترتیب ۱۸۲.
    final chips = find.descendant(
        of: find.byType(CourseFilterBar), matching: find.text('همه دوره‌ها'));
    expect(tester.getSize(chips).height,
        lessThanOrEqualTo(CourseSizes.filterHeight));
    expect(tester.getSize(find.byType(CourseFilterBar)).height,
        CourseSizes.filterHeight);
    // جعبه‌ی جست‌وجو ۲۹۰ است و خود فیلد دو پیکسل کمتر؛ یک پیکسل خط دور از هر طرف.
    expect(tester.getSize(find.byType(TextField)).height,
        CourseSizes.filterHeight - 2);
    expect(tester.getSize(find.byType(TextField)).width,
        CourseSizes.searchWidth - 2);

    expect(tester.takeException(), isNull);
  });

  testWidgets('دوره‌ها به ترتیب آخرین فعالیت چیده می‌شوند', (tester) async {
    await _pumpAt(tester, 1440);

    final titles = _cards().evaluate().map((entry) {
      final texts = find
          .descendant(
              of: find.byWidget(entry.widget), matching: find.byType(Text))
          .evaluate()
          .map((c) => (c.widget as Text).data);
      return texts.firstWhere((data) => allTitles.contains(data));
    }).toList();

    expect(titles, allTitles);
  });

  testWidgets('فیلتر وضعیت و جست‌وجو فهرست را کم می‌کند', (tester) async {
    await _pumpAt(tester, 1440);
    expect(_cards(), findsNWidgets(6));

    await _tapChip(tester, 'تکمیل‌شده');
    expect(_cards(), findsNWidgets(2));
    expect(find.text(selfGrowth), findsOneWidget);
    expect(_cardOf(hero), findsNothing);
    // بنر «ادامه یادگیری» مستقل از فیلتر می‌ماند.
    expect(find.byType(ContinueLearningBanner), findsOneWidget);

    await _tapChip(tester, 'شروع نشده');
    expect(_cards(), findsNWidgets(2));

    await _tapChip(tester, 'همه دوره‌ها');
    expect(_cards(), findsNWidgets(6));

    await tester.enterText(find.byType(TextField), 'رضایی');
    await tester.pumpAndSettle();
    expect(_cards(), findsOneWidget);
    expect(_cardOf(hero), findsOneWidget);

    await tester.tap(find.text('مشاهده همه دوره‌ها'));
    await tester.pumpAndSettle();
    expect(_cards(), findsNWidgets(6));
  });

  testWidgets('ادامه دوره یک جلسه جلو می‌رود و بنر هم به‌روز می‌شود',
      (tester) async {
    await _pumpAt(tester, 1440);

    expect(find.descendant(of: _cardOf(hero), matching: find.text('۶۷٪')),
        findsOneWidget);

    await tester.tap(
        find.descendant(of: _cardOf(hero), matching: find.text('ادامه دوره')));
    await tester.pumpAndSettle();

    expect(find.descendant(of: _cardOf(hero), matching: find.text('۷۵٪')),
        findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(ContinueLearningBanner),
            matching: find.text('۷۵٪')),
        findsOneWidget);
  });

  testWidgets('کارت تکمیل‌شده دکمه‌ی دریافت گواهی دارد', (tester) async {
    await _pumpAt(tester, 1440);

    expect(
        find.descendant(
            of: _cardOf(selfGrowth), matching: find.text('دریافت گواهی')),
        findsOneWidget);
    expect(
        find.descendant(
            of: _cardOf(selfGrowth), matching: find.text('مشاهده دوره')),
        findsOneWidget);
    expect(
        find.descendant(of: _cardOf(selfGrowth), matching: find.text('۱۰۰٪')),
        findsOneWidget);
  });

  testWidgets('در تبلت دو ستون و در گوشی یک ستون می‌شود', (tester) async {
    await _pumpAt(tester, 820);
    // عرض محتوا = ۸۲۰ منهای ۱۶+۱۶ حاشیه؛ دو ستون با فاصله‌ی ۱۴.
    final heroTablet = tester.getRect(_cardOf(hero));
    final secondTablet = tester.getRect(_cardOf(premarriage));
    expect(heroTablet.width, closeTo((820 - 32 - 14) / 2, 1));
    expect(heroTablet.top, closeTo(secondTablet.top, 1));
    expect(heroTablet.right, greaterThan(secondTablet.right));

    await _pumpAt(tester, 420);
    final heroPhone = tester.getRect(_cardOf(hero));
    final secondPhone = tester.getRect(_cardOf(premarriage));
    expect(heroPhone.width, closeTo(420 - 32, 1));
    expect(secondPhone.top, greaterThan(heroPhone.bottom));
    expect(tester.takeException(), isNull);
  });
}
