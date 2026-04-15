import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/animated_pressable.dart';
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

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            l10n.notificationsCenterTitle,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: notificationsAsync.when(
          data: (data) {
            if (data.notifications.isEmpty) {
              return RefreshIndicator(
                onRefresh: _refresh,
                color: colorScheme.primary,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: AppEmptyView(
                        title: l10n.notificationsEmptyTitle,
                        message: l10n.notificationsEmptyMessage,
                        icon: Icons.notifications_off_rounded,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              color: colorScheme.primary,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                itemCount: data.notifications.length,
                itemBuilder: (context, index) {
                  final notification = data.notifications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _NotificationItem(
                      notification: notification,
                      onTap: () =>
                          _markAsRead(notification.id, notification.isRead),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const AppLoadingView(),
          error: (err, st) => AppErrorView(
            message: ApiErrorHandler.readableMessage(err),
            icon: Icons.notifications_none_rounded,
            onRetry: () => ref.invalidate(notificationsProvider),
          ),
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final dynamic notification;
  final VoidCallback onTap;

  const _NotificationItem({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRead = notification.isRead;

    final (icon, color) = _getNotificationTheme(notification.type, colorScheme);

    return AnimatedPressable(
      onTap: onTap,
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
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
                            fontWeight: isRead
                                ? FontWeight.w700
                                : FontWeight.w900,
                            fontSize: 16,
                            color: isRead
                                ? colorScheme.onSurface.withValues(alpha: 0.7)
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(
                        alpha: isRead ? 0.4 : 0.7,
                      ),
                      fontSize: 14,
                      fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formatDate(notification.createdAt),
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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

  (IconData, Color) _getNotificationTheme(
    String type,
    ColorScheme colorScheme,
  ) {
    return switch (type) {
      'payment' => (
        Icons.account_balance_wallet_rounded,
        TeacherAppColors.success,
      ),
      'grade' => (Icons.stars_rounded, TeacherAppColors.amber),
      'attendance' => (Icons.person_off_rounded, TeacherAppColors.warning),
      'assignment' => (Icons.assignment_rounded, TeacherAppColors.indigo600),
      'chat' => (Icons.chat_bubble_rounded, TeacherAppColors.info),
      _ => (Icons.notifications_rounded, colorScheme.primary),
    };
  }

  String _formatDate(String raw) {
    try {
      final date = DateTime.parse(raw);
      return DateFormat('dd.MM.yyyy • HH:mm').format(date.toLocal());
    } catch (_) {
      return raw;
    }
  }
}
