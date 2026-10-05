import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_features.dart';

/// آیتم‌های منوی صفحه‌ی اصلی.
final dashboardMenuProvider =
    Provider<List<AppFeature>>((ref) => AppFeatures.homeMenu);
