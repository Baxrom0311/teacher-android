import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/liquid_glass.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/lesson_session_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../common/page_background.dart';
import '../../common/premium_card.dart';
import '../../common/animated_pressable.dart';

class LessonSessionScreen extends ConsumerStatefulWidget {
  final int sessionId;

  const LessonSessionScreen({super.key, required this.sessionId});

  @override
  ConsumerState<LessonSessionScreen> createState() =>
      _LessonSessionScreenState();
}

class _LessonSessionScreenState extends ConsumerState<LessonSessionScreen> {
  final _topicController = TextEditingController();
  bool _isInit = false;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _handleSave(WidgetRef ref) async {
    final l10n = context.l10n;
    final success = await ref
        .read(lessonSessionControllerProvider(widget.sessionId).notifier)
        .saveSession(_topicController.text);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.lessonSessionSavedSuccess),
          backgroundColor: TeacherAppColors.success,
        ),
      );
      context.pop();
    } else if (mounted) {
      final error = ref
          .read(lessonSessionControllerProvider(widget.sessionId))
          .error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ApiErrorHandler.readableMessage(
              error,
              fallback: l10n.lessonSessionSaveErrorFallback,
            ),
          ),
          backgroundColor: TeacherAppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sessionState = ref.watch(
      lessonSessionControllerProvider(widget.sessionId),
    );

    // Initialize controller text once data is loaded
    if (sessionState.detail != null && !_isInit) {
      _topicController.text = sessionState.detail!.session.topic ?? '';
      _isInit = true;
    }

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(l10n.lessonSessionTitle, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
          actions: [
            IconButton(
              icon: const Icon(Icons.assignment_add_rounded, color: Colors.white),
              onPressed: () => context.push('/homework/create/${widget.sessionId}'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: sessionState.isLoading && sessionState.detail == null
            ? const AppLoadingView()
            : sessionState.error != null && sessionState.detail == null
                ? AppErrorView(
                    message: ApiErrorHandler.readableMessage(sessionState.error),
                    onRetry: () => ref.read(lessonSessionControllerProvider(widget.sessionId).notifier).loadSession(),
                  )
                : _buildContent(context, ref, sessionState),
        bottomNavigationBar: sessionState.detail != null
            ? Container(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + MediaQuery.paddingOf(context).bottom),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                  ),
                ),
                child: AnimatedPressable(
                  onTap: sessionState.isLoading ? null : () => _handleSave(ref),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary]),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(color: colorScheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))
                      ],
                    ),
                    child: Center(
                      child: sessionState.isLoading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                          : Text(
                              l10n.saveAction.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.5),
                            ),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    LessonSessionState state,
  ) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final detail = state.detail!;
    final rows = detail.rows;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: PremiumCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.lessonSessionTopicLabel.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      letterSpacing: 1,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _topicController,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: l10n.lessonSessionTopicHint,
                      hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.3)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          sliver: SliverToBoxAdapter(
            child: Text(
              l10n.lessonSessionStudentsTitle,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final row = rows[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildStudentRow(context, ref, row, detail.gradingMode),
              );
            }, childCount: rows.length),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentRow(
    BuildContext context,
    WidgetRef ref,
    dynamic row,
    String gradingMode,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPresent = row.isPresent;

    return PremiumCard(
      padding: const EdgeInsets.all(16),
      color: isPresent ? null : TeacherAppColors.error.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AvatarSmall(name: row.studentName, isPresent: isPresent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  row.studentName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isPresent ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ),
              _AttendanceIndicator(isPresent: isPresent),
            ],
          ),
          if (isPresent) ...[
            const SizedBox(height: 20),
            if (gradingMode == 'grade')
              _buildGradeSelector(ref, row)
            else
              _buildCoinSelector(ref, row),
          ],
        ],
      ),
    );
  }

  Widget _buildGradeSelector(WidgetRef ref, dynamic row) {
    final grades = [5, 4, 3, 2, 1];
    return Row(
      children: grades.map((grade) {
        final isSelected = row.grade == grade;
        final color = _getGradeColor(grade);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedPressable(
              onTap: () {
                ref
                    .read(lessonSessionControllerProvider(widget.sessionId).notifier)
                    .updateRowGrade(row.studentId, isSelected ? null : grade);
              },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? color : color.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? color : color.withValues(alpha: 0.1), width: 1.5),
                    boxShadow: isSelected ? [
                      BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
                    ] : [],
                  ),
                  child: Center(
                    child: Text(
                      grade.toString(),
                      style: TextStyle(color: isSelected ? Colors.white : color, fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCoinSelector(WidgetRef ref, dynamic row) {
    final coinValues = [5, 10, 20, 50, 100];
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: coinValues.map((coin) {
          final isSelected = row.coin == coin;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AnimatedPressable(
              onTap: () {
                ref
                    .read(lessonSessionControllerProvider(widget.sessionId).notifier)
                    .updateRowCoin(row.studentId, isSelected ? null : coin);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? TeacherAppColors.warning : TeacherAppColors.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      size: 16,
                      color: isSelected ? Colors.white : TeacherAppColors.warning,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      coin.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : TeacherAppColors.warning,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getGradeColor(int grade) {
    switch (grade) {
      case 5: return TeacherAppColors.grade5;
      case 4: return TeacherAppColors.grade4;
      case 3: return TeacherAppColors.grade3;
      case 2: return TeacherAppColors.grade2;
      case 1: return TeacherAppColors.grade1;
      default: return TeacherAppColors.textSecondary;
    }
  }
}

class _AvatarSmall extends StatelessWidget {
  final String name;
  final bool isPresent;
  const _AvatarSmall({required this.name, required this.isPresent});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isPresent ? colorScheme.primary : TeacherAppColors.error;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'S',
          style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 16),
        ),
      ),
    );
  }
}

class _AttendanceIndicator extends StatelessWidget {
  final bool isPresent;
  const _AttendanceIndicator({required this.isPresent});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = isPresent ? TeacherAppColors.success : TeacherAppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isPresent ? l10n.presentStatusShort : l10n.absentStatusShort,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
