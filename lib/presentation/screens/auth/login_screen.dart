import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/localization/app_locale.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../providers/app_locale_provider.dart';
import '../../providers/app_theme_mode_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_feedback.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(
            _usernameController.text.trim(),
            _passwordController.text,
            'Teacher Android Device',
          );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final locale = ref.watch(appLocaleProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PopupMenuButton<ThemeMode>(
                          tooltip: l10n.changeTheme,
                          initialValue: themeMode,
                          onSelected: (value) {
                            ref
                                .read(appThemeModeProvider.notifier)
                                .setThemeMode(value);
                          },
                          color: theme.cardColor,
                          itemBuilder: (context) => ThemeMode.values
                              .map(
                                (item) => PopupMenuItem<ThemeMode>(
                                  value: item,
                                  child: Row(
                                    children: [
                                      Icon(_themeModeIcon(item), size: 18),
                                      const SizedBox(width: 10),
                                      Text(_themeModeLabel(item, l10n)),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          child: _buildChip(
                            child: Icon(
                              _themeModeIcon(themeMode),
                              color: colorScheme.onSurface,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton<AppLocale>(
                          tooltip: l10n.changeLanguage,
                          initialValue: locale,
                          onSelected: (value) {
                            ref
                                .read(appLocaleProvider.notifier)
                                .setLocale(value);
                          },
                          itemBuilder: (context) => AppLocale.values
                              .map(
                                (item) => PopupMenuItem<AppLocale>(
                                  value: item,
                                  child: Text(item.nativeLabel),
                                ),
                              )
                              .toList(),
                          child: _buildChip(
                            child: Text(
                              locale.code.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Icon(Icons.school, size: 80, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    l10n.teacherPortal,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.teacherSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 48),
                  if (authState.error != null) ...[
                    AppInlineMessageCard(
                      message: authState.error!,
                      type: authState.error == AppStrings.sessionExpired
                          ? AppInlineMessageType.info
                          : AppInlineMessageType.error,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Username Field
                  TextFormField(
                    controller: _usernameController,
                    onChanged: (_) =>
                        ref.read(authControllerProvider.notifier).clearError(),
                    decoration: InputDecoration(
                      labelText: l10n.usernameLabel,
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.usernameRequired;
                      }
                      if (value.trim().length < 3) {
                        return l10n.usernameMinimum;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    onChanged: (_) =>
                        ref.read(authControllerProvider.notifier).clearError(),
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: l10n.passwordLabel,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.passwordRequired;
                      }
                      if (value.length < 6) {
                        return AppStrings.passwordTooShort;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: authState.isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            l10n.signIn,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _themeModeLabel(ThemeMode themeMode, AppLocalizations l10n) {
    return switch (themeMode) {
      ThemeMode.system => l10n.themeSystem,
      ThemeMode.light => l10n.themeLight,
      ThemeMode.dark => l10n.themeDark,
    };
  }

  IconData _themeModeIcon(ThemeMode themeMode) {
    return switch (themeMode) {
      ThemeMode.system => Icons.brightness_auto_rounded,
      ThemeMode.light => Icons.light_mode_rounded,
      ThemeMode.dark => Icons.dark_mode_rounded,
    };
  }

  Widget _buildChip({required Widget child}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.6)),
      ),
      child: child,
    );
  }
}
