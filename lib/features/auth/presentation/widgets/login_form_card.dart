import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_features.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text.dart';
import '../login_style.dart';
import '../providers/login_providers.dart';
import 'brand_logo.dart';

/// کارت سفید ورود در سمت راست طرح؛ عرض ۵۳۹ و فاصله‌های داخلی مطابق بوم.
class LoginFormCard extends ConsumerStatefulWidget {
  const LoginFormCard({super.key});

  @override
  ConsumerState<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends ConsumerState<LoginFormCard> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref
        .read(loginNotifierProvider.notifier)
        .submit(_username.text, _password.text);
    if (ok && mounted) {
      Navigator.of(context)
          .pushReplacementNamed(AppRoute.dashboard, arguments: _username.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginNotifierProvider);
    final notifier = ref.read(loginNotifierProvider.notifier);

    return Container(
      key: const Key('loginCard'),
      constraints: const BoxConstraints(maxWidth: LoginSizes.cardWidth),
      padding: const EdgeInsets.symmetric(
        horizontal: LoginSizes.cardPadding,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: LoginColors.card,
        borderRadius: BorderRadius.circular(LoginSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: LoginColors.ink.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(child: BrandLogo(size: 32)),
          const SizedBox(height: 14),
          Text(
            'مدیریت فروش اقساطی',
            style: AppText.section.copyWith(color: LoginColors.ink),
          ),
          const SizedBox(height: 6),
          Text(
            'سامانه داخلی سرمایه‌گذاری',
            style: AppText.caption.copyWith(color: LoginColors.muted),
          ),
          const SizedBox(height: 34),
          const _NoticeBox(
            key: Key('infoBox'),
            background: LoginColors.infoBg,
            icon: Icons.verified_user_outlined,
            iconColor: LoginColors.primary,
            title: 'ورود به سامانه',
            titleColor: LoginColors.ink,
            body: 'دسترسی به اطلاعات فقط برای کاربران مجاز امکان‌پذیر است.',
          ),
          const SizedBox(height: 24),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'نام کاربری یا شماره موبایل',
              style: AppText.strong.copyWith(color: LoginColors.ink),
            ),
          ),
          const SizedBox(height: 8),
          _Field(
            key: const Key('usernameField'),
            controller: _username,
            hint: 'نام کاربری یا شماره موبایل خود را وارد کنید',
            errorText: state.usernameError,
            suffix: const Icon(Icons.person_outline,
                color: LoginColors.muted, size: AppSizes.fieldIconSize),
            onChanged: (_) => notifier.clearUsernameError(),
          ),
          const SizedBox(height: 22),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'رمز عبور',
              style: AppText.strong.copyWith(color: LoginColors.ink),
            ),
          ),
          const SizedBox(height: 8),
          _Field(
            key: const Key('passwordField'),
            controller: _password,
            hint: 'رمز عبور خود را وارد کنید',
            errorText: state.passwordError,
            obscure: state.obscurePassword,
            suffix: const Icon(Icons.lock_outline,
                color: LoginColors.muted, size: AppSizes.fieldIconSize),
            prefix: IconButton(
              onPressed: notifier.togglePasswordVisibility,
              icon: Icon(
                state.obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: LoginColors.muted,
                size: AppSizes.fieldIconSize,
              ),
              tooltip: 'نمایش رمز عبور',
            ),
            onChanged: (_) => notifier.clearPasswordError(),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: LoginSizes.checkboxSize + 8,
                      height: LoginSizes.checkboxSize + 8,
                      child: FittedBox(
                        child: Checkbox(
                          key: const Key('rememberCheckbox'),
                          value: state.rememberMe,
                          onChanged: (v) => notifier.setRememberMe(v ?? false),
                          activeColor: LoginColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          side:
                              const BorderSide(color: LoginColors.inputBorder),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'مرا به خاطر بسپار',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption.copyWith(color: LoginColors.ink),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: LoginColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.lock_open, size: 16),
                label: Text(
                  'بازیابی رمز عبور',
                  style: AppText.badge.copyWith(color: LoginColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            key: const Key('submitButton'),
            height: LoginSizes.buttonHeight,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LoginColors.buttonGradient,
                borderRadius: BorderRadius.circular(LoginSizes.buttonRadius),
              ),
              child: TextButton(
                onPressed: state.submitting ? null : _submit,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(LoginSizes.buttonRadius),
                  ),
                ),
                child: state.submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.4, color: Colors.white),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ورود به سامانه',
                            style: AppText.button
                                .copyWith(color: Colors.white, height: 1),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.login,
                              size: 20, color: Colors.white),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const _NoticeBox(
            key: Key('secureBox'),
            background: LoginColors.greenBg,
            icon: Icons.verified_user,
            iconColor: LoginColors.greenIcon,
            title: 'اتصال شما امن و رمزنگاری شده است',
            titleColor: LoginColors.green,
            body: 'این سامانه مخصوص استفاده داخلی سازمان می‌باشد.',
          ),
          const SizedBox(height: 26),
          const Divider(color: Color(0xFFE6EAF2), height: 1),
          const SizedBox(height: 22),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  children: [
                    Text(
                      'به راهنمایی نیاز دارید؟',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.badge,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'با واحد پشتیبانی در تماس باشید',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.headset_mic_outlined,
                  color: LoginColors.primary, size: 26),
            ],
          ),
        ],
      ),
    );
  }
}

/// باکس اطلاع‌رسانی (آبی بالا / سبز پایین): ارتفاع ۷۲، شعاع ۱۲.
class _NoticeBox extends StatelessWidget {
  const _NoticeBox({
    super.key,
    required this.background,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.body,
  });

  final Color background;
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: LoginSizes.boxHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(LoginSizes.boxRadius),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.badge.copyWith(color: titleColor, height: 1.3),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption
                      .copyWith(color: LoginColors.muted, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// فیلد متنی با ارتفاع و گوشه‌ی مشترک برنامه (تم `InputDecorationTheme`).
class _Field extends StatelessWidget {
  const _Field({
    super.key,
    required this.controller,
    required this.hint,
    this.errorText,
    this.obscure = false,
    this.suffix,
    this.prefix,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final String? errorText;
  final bool obscure;
  final Widget? suffix;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;

  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(LoginSizes.boxRadius),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    const iconConstraints = BoxConstraints(
      minWidth: AppSizes.fieldIconBox,
      minHeight: AppSizes.fieldIconBox,
    );
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: LoginSizes.fieldHeight,
          child: TextField(
            controller: controller,
            obscureText: obscure,
            onChanged: onChanged,
            style: AppText.field.copyWith(color: LoginColors.ink),
            cursorColor: LoginColors.primary,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppText.hint.copyWith(color: LoginColors.faint),
              isDense: true,
              // خطا زیر فیلد نوشته می‌شود، پس جایی برای آن رزرو نمی‌شود.
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              enabledBorder: _border(LoginColors.inputBorder),
              focusedBorder: _border(LoginColors.primary, width: 1.6),
              errorBorder: _border(LoginColors.danger),
              focusedErrorBorder: _border(LoginColors.danger, width: 1.6),
              prefixIcon: prefix,
              suffixIcon: suffix,
              prefixIconConstraints: iconConstraints,
              suffixIconConstraints: iconConstraints,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(errorText!, style: AppText.error),
        ],
      ],
    );
  }
}
