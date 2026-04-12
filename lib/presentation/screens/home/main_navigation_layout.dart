import '../../../core/constants/app_routes.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../widgets/sync_status_banner.dart';
import 'dart:ui';

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
      extendBody: true,
      body: child,
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SyncStatusBanner(),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFF1A1C1E).withValues(alpha: 0.8)
                          : Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: BottomNavigationBar(
                      currentIndex: currentIndex,
                      onTap: (index) {
                        switch (index) {
                          case 0: context.go(TeacherRoutes.dashboard); break;
                          case 1: context.go(TeacherRoutes.lessons); break;
                          case 2: context.go(TeacherRoutes.chat); break;
                          case 3: context.go(TeacherRoutes.profile); break;
                        }
                      },
                      selectedItemColor: colorScheme.primary,
                      unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.3),
                      showUnselectedLabels: true,
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      iconSize: 24,
                      selectedFontSize: 11,
                      unselectedFontSize: 10,
                      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.2),
                      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
                      items: [
                        BottomNavigationBarItem(
                          icon: const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Icon(Icons.grid_view_rounded),
                          ),
                          label: l10n.home,
                        ),
                        BottomNavigationBarItem(
                          icon: const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Icon(Icons.auto_stories_rounded),
                          ),
                          label: l10n.lessons,
                        ),
                        BottomNavigationBarItem(
                          icon: const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Icon(Icons.chat_bubble_rounded),
                          ),
                          label: l10n.chat,
                        ),
                        BottomNavigationBarItem(
                          icon: const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Icon(Icons.person_rounded),
                          ),
                          label: l10n.profile,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

