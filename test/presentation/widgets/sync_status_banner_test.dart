import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import 'package:teacher_school_app/presentation/providers/connectivity_provider.dart';
import 'package:teacher_school_app/presentation/widgets/sync_status_banner.dart';

void main() {
  Widget buildBannerApp({
    required NetworkStatus networkStatus,
    required int queueCount,
    required OutboxSyncStatus syncStatus,
  }) {
    return ProviderScope(
      overrides: [
        currentNetworkStatusProvider.overrideWithValue(networkStatus),
        currentOutboxQueueCountProvider.overrideWithValue(queueCount),
        currentOutboxSyncStatusProvider.overrideWithValue(syncStatus),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SizedBox(),
          bottomNavigationBar: SyncStatusBanner(),
        ),
      ),
    );
  }

  testWidgets('shows offline queued actions banner', (tester) async {
    await tester.pumpWidget(
      buildBannerApp(
        networkStatus: NetworkStatus.offline,
        queueCount: 3,
        syncStatus: const OutboxSyncStatus(),
      ),
    );

    expect(
      find.textContaining(AppLocalizationsRegistry.instance.offlineQueued(3)),
      findsOneWidget,
    );
  });

  testWidgets('shows syncing banner when outbox is flushing', (tester) async {
    await tester.pumpWidget(
      buildBannerApp(
        networkStatus: NetworkStatus.online,
        queueCount: 2,
        syncStatus: const OutboxSyncStatus.syncing(2),
      ),
    );

    expect(
      find.textContaining(AppLocalizationsRegistry.instance.syncingActions(2)),
      findsOneWidget,
    );
  });

  testWidgets('shows success banner after sync completes', (tester) async {
    await tester.pumpWidget(
      buildBannerApp(
        networkStatus: NetworkStatus.online,
        queueCount: 0,
        syncStatus: const OutboxSyncStatus.success(4),
      ),
    );

    expect(
      find.textContaining(AppLocalizationsRegistry.instance.syncSuccess(4)),
      findsOneWidget,
    );
  });
}
