import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/responsive/responsive.dart';
import 'login_style.dart';
import 'widgets/hero_panel.dart';
import 'widgets/login_form_card.dart';

/// صفحه‌ی ورود سامانه؛ راست‌چین، فارسی و ریسپانسیو برای ویندوز و گوشی.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              LoginColors.heroTop,
              Color(0xFFE8EEFD),
              LoginColors.heroLeft,
              LoginColors.heroBottom,
            ],
            stops: [.0, .45, .8, 1],
          ),
        ),
        child: SafeArea(
          child: switch (context.screenSizeType) {
            ScreenSize.expanded => const _DesktopLayout(),
            ScreenSize.medium => const _StackedLayout(),
            ScreenSize.compact => const _StackedLayout(compact: true),
          },
        ),
      ),
    );
  }
}

/// دسکتاپ/ویندوز: هیرو در چپ و کارت ۵۳۹ پیکسلی در راست، عموداً وسط.
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 22),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 44,
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // در RTL فرزند اول راست‌ترین است: کارت ورود هم‌راستای طرح، سمت راست.
              children: [
                SizedBox(
                  width: LoginSizes.cardWidth,
                  child: LoginFormCard(),
                ),
                SizedBox(width: 44),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.center,
                    child: HeroPanel(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// تبلت و گوشی: هیرو بالا و کارت ورود زیر آن، همه اسکرول‌شونده.
class _StackedLayout extends StatelessWidget {
  const _StackedLayout({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 16 : 32,
        vertical: 28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: compact ? 560 : 640),
          child: Column(
            children: [
              const HeroPanel(),
              SizedBox(height: compact ? 26 : 36),
              const LoginFormCard(),
            ],
          ),
        ),
      ),
    );
  }
}
