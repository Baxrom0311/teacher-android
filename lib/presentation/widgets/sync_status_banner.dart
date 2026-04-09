import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../providers/connectivity_provider.dart';

class SyncStatusBanner extends ConsumerWidget {
  const SyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = ref.watch(currentNetworkStatusProvider);
    final queueCount = ref.watch(currentOutboxQueueCountProvider);
    final syncStatus = ref.watch(currentOutboxSyncStatusProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final banner = _resolveBanner(
      networkStatus: networkStatus,
      queueCount: queueCount,
      syncStatus: syncStatus,
      colorScheme: colorScheme,
    );

    if (banner == null) {
      return const SizedBox.shrink();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(
          '${banner.message}_${banner.color.toARGB32()}_${banner.icon.codePoint}',
        ),
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: banner.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: banner.color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(banner.icon, color: banner.color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                banner.message,
                style: TextStyle(
                  color: banner.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _BannerData? _resolveBanner({
    required NetworkStatus networkStatus,
    required int queueCount,
    required OutboxSyncStatus syncStatus,
    required ColorScheme colorScheme,
  }) {
    final l10n = AppLocalizationsRegistry.instance;

    switch (syncStatus.phase) {
      case OutboxSyncPhase.syncing:
        return _BannerData(
          message: l10n.syncingActions(syncStatus.affectedCount),
          color: colorScheme.primary,
          icon: Icons.sync,
        );
      case OutboxSyncPhase.success:
        return _BannerData(
          message: l10n.syncSuccess(syncStatus.affectedCount),
          color: colorScheme.secondary,
          icon: Icons.cloud_done_outlined,
        );
      case OutboxSyncPhase.error:
        return _BannerData(
          message: syncStatus.message ?? l10n.syncErrorFallback,
          color: colorScheme.error,
          icon: Icons.sync_problem_outlined,
        );
      case OutboxSyncPhase.idle:
        break;
    }

    if (networkStatus == NetworkStatus.offline && queueCount > 0) {
      return _BannerData(
        message: l10n.offlineQueued(queueCount),
        color: colorScheme.tertiary,
        icon: Icons.cloud_off_outlined,
      );
    }

    if (networkStatus == NetworkStatus.offline) {
      return _BannerData(
        message: l10n.offlineSavedChanges,
        color: colorScheme.tertiary,
        icon: Icons.wifi_off_outlined,
      );
    }

    if (queueCount > 0) {
      return _BannerData(
        message: l10n.pendingQueue(queueCount),
        color: colorScheme.primary,
        icon: Icons.schedule_send_outlined,
      );
    }

    return null;
  }
}

class _BannerData {
  final String message;
  final Color color;
  final IconData icon;

  const _BannerData({
    required this.message,
    required this.color,
    required this.icon,
  });
}
