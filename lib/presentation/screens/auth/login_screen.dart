import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/localization/app_locale.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../providers/app_locale_provider.dart';
import '../../providers/app_theme_mode_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/animated_pressable.dart';

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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final authNotifier = ref.read(authControllerProvider.notifier);
    if (ref.read(authControllerProvider).isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    await authNotifier.login(
      _usernameController.text.trim(),
      _passwordController.text,
      'Teacher Android Device',
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final locale = ref.watch(appLocaleProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                          _ThemeSelector(currentMode: themeMode),
                          const SizedBox(width: 12),
                          _LanguageSelector(currentLocale: locale),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.school_rounded,
                          size: 64,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      l10n.teacherPortal,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.teacherSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 48),
                    PremiumCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (authState.error != null) ...[
                            AppInlineMessageCard(
                              message: authState.error!,
                              type: authState.error == AppStrings.sessionExpired
                                  ? AppInlineMessageType.info
                                  : AppInlineMessageType.error,
                            ),
                            const SizedBox(height: 20),
                          ],
                          _buildTextField(
                            controller: _usernameController,
                            label: l10n.usernameLabel,
                            icon: Icons.person_rounded,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.usernameRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _passwordController,
                            label: l10n.passwordLabel,
                            icon: Icons.lock_rounded,
                            isPassword: true,
                            isObscured: _obscurePassword,
                            onToggleObscure: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.passwordRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          AnimatedPressable(
                            onTap: authState.isLoading ? null : _submit,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primary,
                                    colorScheme.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: authState.isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        l10n.signIn.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isObscured = false,
    VoidCallback? onToggleObscure,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      onChanged: (_) => ref.read(authControllerProvider.notifier).clearError(),
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.5),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          icon,
          color: colorScheme.primary.withValues(alpha: 0.7),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscured
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 20,
                ),
                onPressed: onToggleObscure,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              )
            : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }
}

class _ThemeSelector extends ConsumerWidget {
  final ThemeMode currentMode;
  const _ThemeSelector({required this.currentMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<ThemeMode>(
      tooltip: l10n.changeTheme,
      initialValue: currentMode,
      onSelected: (value) =>
          ref.read(appThemeModeProvider.notifier).setThemeMode(value),
      color: const Color(0xFF1F2225),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      itemBuilder: (context) => ThemeMode.values
          .map(
            (item) => PopupMenuItem(
              value: item,
              child: Row(
                children: [
                  Icon(
                    _themeModeIcon(item),
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _themeModeLabel(item, l10n),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(_themeModeIcon(currentMode), color: Colors.white, size: 20),
      ),
    );
  }

  IconData _themeModeIcon(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => Icons.brightness_auto_rounded,
      ThemeMode.light => Icons.light_mode_rounded,
      ThemeMode.dark => Icons.dark_mode_rounded,
    };
  }

  String _themeModeLabel(ThemeMode mode, dynamic l10n) {
    return switch (mode) {
      ThemeMode.system => l10n.themeSystem,
      ThemeMode.light => l10n.themeLight,
      ThemeMode.dark => l10n.themeDark,
    };
  }
}

class _LanguageSelector extends ConsumerWidget {
  final AppLocale currentLocale;
  const _LanguageSelector({required this.currentLocale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return PopupMenuButton<AppLocale>(
      tooltip: l10n.changeLanguage,
      initialValue: currentLocale,
      onSelected: (value) =>
          ref.read(appLocaleProvider.notifier).setLocale(value),
      color: const Color(0xFF1F2225),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      itemBuilder: (context) => AppLocale.values
          .map(
            (item) => PopupMenuItem(
              value: item,
              child: Text(
                item.nativeLabel,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          currentLocale.code.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
