import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../widgets/sync_status_banner.dart';

class MainNavigationLayout extends ConsumerWidget {
  final Widget child;

  const MainNavigationLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Determine the current index based on the GoRouter's location
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;

    if (location.startsWith(TeacherRoutes.dashboard)) {
      currentIndex = 0;
    } else if (location.startsWith(TeacherRoutes.lessons)) {
      currentIndex = 1;
    } else if (location.startsWith(TeacherRoutes.chat)) {
      currentIndex = 2;
    } else if (location.startsWith(TeacherRoutes.profile)) {
      currentIndex = 3;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SyncStatusBanner(),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go(TeacherRoutes.dashboard);
                    break;
                  case 1:
                    context.go(TeacherRoutes.lessons);
                    break;
                  case 2:
                    context.go(TeacherRoutes.chat);
                    break;
                  case 3:
                    context.go(TeacherRoutes.profile);
                    break;
                }
              },
              selectedItemColor: colorScheme.primary,
              unselectedItemColor: colorScheme.onSurfaceVariant,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: colorScheme.surface,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home),
                  label: l10n.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.book_outlined),
                  activeIcon: const Icon(Icons.book),
                  label: l10n.lessons,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.chat_bubble_outline),
                  activeIcon: const Icon(Icons.chat_bubble),
                  label: l10n.chat,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline),
                  activeIcon: const Icon(Icons.person),
                  label: l10n.profile,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
