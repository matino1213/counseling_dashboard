import 'package:flutter/material.dart';

import '../features/auth/presentation/login_page.dart';
import '../features/courses/presentation/courses_page.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/exams/presentation/exams_page.dart';
import '../features/installment_sales/presentation/installment_sales_page.dart';
import '../features/subscription/presentation/subscription_page.dart';
import 'app_features.dart';
import 'theme/app_colors.dart';
import 'theme/app_sizes.dart';

/// سازنده‌ی مسیرهای برنامه.
abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      AppRoute.dashboard || null => const DashboardPage(),
      AppRoute.login => const LoginPage(),
      AppRoute.installmentSales => const InstallmentSalesPage(),
      AppRoute.subscription => const SubscriptionPage(),
      AppRoute.exams => const ExamsPage(),
      AppRoute.courses => const CoursesPage(),
      _ => _UnknownRoutePage(name: settings.name),
    };
    return MaterialPageRoute<dynamic>(builder: (_) => page, settings: settings);
  }
}

class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage({this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صفحه پیدا نشد')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off,
                size: 48, color: AppColors.textSecondary),
            const SizedBox(height: AppSizes.lg),
            Text('مسیر «$name» در برنامه تعریف نشده است.'),
            const SizedBox(height: AppSizes.xl),
            FilledButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoute.dashboard, (route) => false),
              child: const Text('بازگشت به صفحه اصلی'),
            ),
          ],
        ),
      ),
    );
  }
}
