import 'package:flutter/material.dart';

import '../../app/app_features.dart';
import 'empty_state.dart';

/// جای محتوای طراحی‌نشده‌ی یک بخش. با رسیدن طراحی، همین جا عوض می‌شود.
class FeaturePlaceholder extends StatelessWidget {
  const FeaturePlaceholder({super.key, required this.feature});

  final AppFeature feature;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: feature.icon,
      title: 'ساختار صفحه آماده است',
      message: 'محتوای «${feature.title}» هنوز طراحی نشده است. '
          'هدر، اسکرول و نقاط شکست ریسپانسیو این صفحه از الان کار می‌کند.',
    );
  }
}
