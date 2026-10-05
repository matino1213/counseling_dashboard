import 'package:flutter/material.dart';

import 'theme/app_colors.dart';

/// نام مسیرهای برنامه.
abstract final class AppRoute {
  static const String dashboard = '/';
  static const String login = '/login';
  static const String installmentSales = '/installment-sales';
  static const String subscription = '/subscription';
  static const String exams = '/exams';
  static const String courses = '/courses';
}

/// توصیف‌گر یک بخش از برنامه؛ منبع واحد حقیقت برای عنوان، آیکون و مسیر.
class AppFeature {
  const AppFeature({
    required this.title,
    required this.description,
    required this.icon,
    required this.routeName,
    required this.tint,
    required this.accentColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final String routeName;

  /// رنگ پس‌زمینه‌ی خانه‌ی آیکون.
  final Color tint;

  /// رنگ خودِ آیکون.
  final Color accentColor;
}

/// چهار بخش اصلی برنامه.
abstract final class AppFeatures {
  static const AppFeature installmentSales = AppFeature(
    title: 'ورود به سامانه فروش اقساط',
    description: 'پرونده‌های خرید اقساطی و پیگیری وضعیت آن‌ها',
    icon: Icons.point_of_sale,
    routeName: AppRoute.login,
    tint: AppColors.primarySoft,
    accentColor: AppColors.primary,
  );

  static const AppFeature subscription = AppFeature(
    title: 'اشتراک من',
    description: 'وضعیت اشتراک، مهلت تمدید و تاریخچه پرداخت',
    icon: Icons.workspace_premium_outlined,
    routeName: AppRoute.subscription,
    tint: AppColors.accentSoft,
    accentColor: AppColors.accent,
  );

  static const AppFeature exams = AppFeature(
    title: 'آزمون‌های من',
    description: 'آزمون‌های آنلاین، نتایج و دفترچه سؤالات',
    icon: Icons.how_to_vote_outlined,
    routeName: AppRoute.exams,
    tint: Color(0xFFE6F0FB),
    accentColor: Color(0xFF2F6FB5),
  );

  static const AppFeature courses = AppFeature(
    title: 'دوره‌های من',
    description: 'دوره‌های آموزشی ثبت‌نام‌شده و پیشرفت مطالعه',
    icon: Icons.school_outlined,
    routeName: AppRoute.courses,
    tint: Color(0xFFEAF4EC),
    accentColor: AppColors.success,
  );

  static const List<AppFeature> homeMenu = [
    installmentSales,
    subscription,
    exams,
    courses
  ];
}
