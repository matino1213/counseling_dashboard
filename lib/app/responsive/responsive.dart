import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/widgets.dart';

/// نقاط شکست صفحه بر پایه‌ی راهنمای Material 3.
enum ScreenSize { compact, medium, expanded }

extension ScreenInfo on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  ScreenSize get screenSizeType {
    final width = screenSize.width;
    if (width >= 1024) return ScreenSize.expanded;
    if (width >= 640) return ScreenSize.medium;
    return ScreenSize.compact;
  }

  bool get isCompact => screenSizeType == ScreenSize.compact;
  bool get isMedium => screenSizeType == ScreenSize.medium;
  bool get isExpanded => screenSizeType == ScreenSize.expanded;

  /// ویندوز/دسکتاپ: ورودی اصلی ماوس است و چگالی بالاتری لازم دارد.
  bool get isDesktop =>
      !kIsWeb &&
      const {TargetPlatform.windows, TargetPlatform.linux, TargetPlatform.macOS}
          .contains(defaultTargetPlatform);

  double get bottomSafeInset => MediaQuery.viewPaddingOf(this).bottom;
}

/// مقداری که بسته به اندازه‌ی صفحه بین مقادیر موبایل و دسکتاپ جابه‌جا می‌شود.
class Responsive<T> {
  const Responsive(this.compact, {this.medium, this.expanded});

  final T compact;
  final T? medium;
  final T? expanded;

  T resolve(BuildContext context) => switch (context.screenSizeType) {
        ScreenSize.compact => compact,
        ScreenSize.medium => medium ?? compact,
        ScreenSize.expanded => expanded ?? medium ?? compact,
      };
}
