import 'package:flutter/material.dart';

import '../../../app/app_features.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/feature_placeholder.dart';

/// بخش فروش اقساط.
class InstallmentSalesPage extends StatelessWidget {
  const InstallmentSalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const feature = AppFeatures.installmentSales;
    return AppPageScaffold(
      title: feature.title,
      subtitle: feature.description,
      showBack: true,
      child: const FeaturePlaceholder(feature: feature),
    );
  }
}
