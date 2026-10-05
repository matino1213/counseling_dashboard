import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_features.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

/// ریشه‌ی برنامه: فارسی، راست‌چین و آماده‌ی اجرا روی ویندوز و گوشی.
class CounselingApp extends StatelessWidget {
  const CounselingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'داشبورد مرکز مشاوره',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: const Locale('fa'),
      supportedLocales: const [Locale('fa'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute: AppRoute.dashboard,
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          // بزرگ‌نمایی متن گوشی را محدود می‌کند تا چیدمان نشکند.
          data: mediaQuery.copyWith(
            textScaler: mediaQuery.textScaler
                .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.35),
          ),
          child: ScrollConfiguration(
            behavior: const AppScrollBehavior(),
            child: child!,
          ),
        );
      },
    );
  }
}
