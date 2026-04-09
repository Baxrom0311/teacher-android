import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/app_feedback.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  Future<void> _refresh() async {
    ref.invalidate(notificationsProvider);
    await ref.read(notificationsProvider.future);
  }

  Future<void> _markAsRead(String id, bool isCurrentlyRead) async {
    if (isCurrentlyRead) return;

    final success = await ref
        .read(notificationControllerProvider.notifier)
        .markAsRead(id);
    if (success && mounted) {
      ref.invalidate(notificationsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.notificationsCenterTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: notificationsAsync.when(
        data: (data) {
          if (data.notifications.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 420,
                    child: AppEmptyView(
                      title: l10n.notificationsEmptyTitle,
                      message: l10n.notificationsEmptyMessage,
                      icon: Icons.notifications_off_outlined,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: data.notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notification = data.notifications[index];
                return _buildNotificationCard(notification);
              },
            ),
          );
        },
        loading: () => AppLoadingView(
          title: l10n.notificationsLoadingTitle,
          subtitle: l10n.notificationsLoadingSubtitle,
        ),
        error: (err, st) => AppErrorView(
          title: l10n.notificationsLoadErrorTitle,
          message: ApiErrorHandler.readableMessage(err),
          icon: Icons.notifications_off_outlined,
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(dynamic notification) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    IconData icon;
    Color color;

    switch (notification.type) {
      case 'payment':
        icon = Icons.payment;
        color = colorScheme.tertiary;
        break;
      case 'grade':
        icon = Icons.grade;
        color = colorScheme.secondary;
        break;
      case 'attendance':
        icon = Icons.event_busy;
        color = colorScheme.error;
        break;
      case 'assignment':
        icon = Icons.assignment;
        color = colorScheme.primary;
        break;
      case 'chat':
        icon = Icons.chat;
        color = colorScheme.primary;
        break;
      default:
        icon = Icons.notifications;
        color = colorScheme.primary;
    }

    final dateStr = notification.createdAt;
    String formattedDate = '';
    try {
      final date = DateTime.parse(dateStr);
      formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(date.toLocal());
    } catch (_) {
      formattedDate = dateStr;
    }

    return InkWell(
      onTap: () => _markAsRead(notification.id, notification.isRead),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? theme.cardColor
              : colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead
                ? colorScheme.outline.withValues(alpha: 0.7)
                : colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: notification.isRead
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
