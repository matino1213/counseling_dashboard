import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// وضعیت فرم ورود: نمایش رمز، «مرا به خاطر بسپار» و خطای اعتبارسنجی.
@immutable
class LoginState {
  const LoginState({
    this.obscurePassword = true,
    this.rememberMe = true,
    this.submitting = false,
    this.usernameError,
    this.passwordError,
  });

  final bool obscurePassword;
  final bool rememberMe;
  final bool submitting;
  final String? usernameError;
  final String? passwordError;

  bool get canSubmit => !submitting;

  LoginState copyWith({
    bool? obscurePassword,
    bool? rememberMe,
    bool? submitting,
    String? usernameError,
    bool clearUsernameError = false,
    String? passwordError,
    bool clearPasswordError = false,
  }) {
    return LoginState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      submitting: submitting ?? this.submitting,
      usernameError:
          clearUsernameError ? null : usernameError ?? this.usernameError,
      passwordError:
          clearPasswordError ? null : passwordError ?? this.passwordError,
    );
  }
}

/// منطق فرم ورود صفحه‌ی لاگین؛ کنترلرهای متن بیرون از استیت نگه داشته
/// می‌شوند تا چرخه‌ی عمرشان با ویجت هم‌راستا بماند.
class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void setRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  void clearUsernameError() {
    if (state.usernameError != null) {
      state = state.copyWith(clearUsernameError: true);
    }
  }

  void clearPasswordError() {
    if (state.passwordError != null) {
      state = state.copyWith(clearPasswordError: true);
    }
  }

  /// اعتبارسنجی و «ورود»؛ بازه‌ی bool نشان می‌دهد فرم معتبر بوده است.
  Future<bool> submit(String username, String password) async {
    final trimmed = username.trim();
    final usernameError = trimmed.isEmpty ? 'نام کاربری را وارد کنید.' : null;
    final passwordError = password.isEmpty ? 'رمز عبور را وارد کنید.' : null;
    if (usernameError != null || passwordError != null) {
      state = state.copyWith(
        usernameError: usernameError,
        passwordError: passwordError,
      );
      return false;
    }
    state = state.copyWith(
        submitting: true, clearUsernameError: true, clearPasswordError: true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 900));
    } finally {
      state = state.copyWith(submitting: false);
    }
    return true;
  }
}

final loginNotifierProvider =
    NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);
