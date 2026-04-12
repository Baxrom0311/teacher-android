import 'package:flutter/material.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';

import '../../../core/constants/app_colors.dart';
import '../common/animated_pressable.dart';
import '../common/premium_card.dart';

class AppLoadingView extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const AppLoadingView({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsRegistry.instance;
    final resolvedTitle = title ?? l10n.loadingTitle;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: colorScheme.primary,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              resolvedTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppErrorView extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final String? actionLabel;
  final IconData icon;

  const AppErrorView({
    super.key,
    this.title,
    required this.message,
    this.onRetry,
    this.actionLabel,
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsRegistry.instance;
    final resolvedTitle = title ?? l10n.errorTitle;
    final resolvedActionLabel = actionLabel ?? l10n.retry;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: colorScheme.error),
            ),
            const SizedBox(height: 24),
            Text(
              resolvedTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              AnimatedPressable(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.error.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    resolvedActionLabel.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppEmptyView extends StatelessWidget {
  final String? title;
  final String message;
  final IconData icon;

  const AppEmptyView({
    super.key,
    this.title,
    required this.message,
    this.icon = Icons.inbox_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsRegistry.instance;
    final resolvedTitle = title ?? l10n.emptyTitle;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.3,
              child: Icon(icon, size: 80, color: colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              resolvedTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum AppInlineMessageType { info, error, success }

class AppInlineMessageCard extends StatelessWidget {
  final String message;
  final AppInlineMessageType type;

  const AppInlineMessageCard({
    super.key,
    required this.message,
    this.type = AppInlineMessageType.info,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (color, icon) = switch (type) {
      AppInlineMessageType.info => (colorScheme.primary, Icons.info_rounded),
      AppInlineMessageType.error => (colorScheme.error, Icons.error_rounded),
      AppInlineMessageType.success => (TeacherAppColors.success, Icons.check_circle_rounded),
    };

    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
