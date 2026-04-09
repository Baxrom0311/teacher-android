import 'package:flutter/material.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';

class AppLoadingView extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const AppLoadingView({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final resolvedTitle =
        title ?? AppLocalizationsRegistry.instance.loadingTitle;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              resolvedTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
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
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = title ?? AppLocalizationsRegistry.instance.errorTitle;
    final resolvedActionLabel =
        actionLabel ?? AppLocalizationsRegistry.instance.retry;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              resolvedTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(resolvedActionLabel),
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
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = title ?? AppLocalizationsRegistry.instance.emptyTitle;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              resolvedTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
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
    final scheme = switch (type) {
      AppInlineMessageType.info => (
        colorScheme.primary,
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
        Icons.info_outline,
      ),
      AppInlineMessageType.error => (
        colorScheme.error,
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
        Icons.error_outline,
      ),
      AppInlineMessageType.success => (
        colorScheme.secondary,
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
        Icons.check_circle_outline,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.$2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.$1.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(scheme.$4, color: scheme.$1),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: scheme.$3, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
