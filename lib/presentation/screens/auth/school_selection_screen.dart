import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/l10n_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';

class SchoolSelectionScreen extends ConsumerStatefulWidget {
  const SchoolSelectionScreen({super.key});

  @override
  ConsumerState<SchoolSelectionScreen> createState() => _SchoolSelectionScreenState();
}

class _SchoolSelectionScreenState extends ConsumerState<SchoolSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider.notifier).fetchPublicSchools();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final schools = authState.schools;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: TeacherAppColors.liquidIndigo,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    context.l10n.selectSchool,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    context.l10n.selectSchoolSubtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha:0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                if (schools.isEmpty && !authState.isLoading)
                   Expanded(
                    child: Center(
                      child: Text(
                        context.l10n.noSchoolsFound,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  )
                else
                Expanded(
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: 120,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: schools.length,
                      itemBuilder: (context, index) {
                        final school = schools[index];
                        return _BentoSchoolCard(
                          name: school.schoolName,
                          host: school.host,
                          logo: school.logo,
                          onTap: () async {
                            await ref.read(authControllerProvider.notifier).selectSchool(school);
                            if (mounted) {
                              context.go(TeacherRoutes.login);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                if (authState.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BentoSchoolCard extends StatelessWidget {
  final String name;
  final String host;
  final String? logo;
  final VoidCallback onTap;

  const _BentoSchoolCard({
    required this.name,
    required this.host,
    this.logo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  image: logo != null && logo!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(logo!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: logo == null || logo!.isEmpty
                    ? const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 32,
                      )
                    : null,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      host,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.6),
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withValues(alpha:0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
