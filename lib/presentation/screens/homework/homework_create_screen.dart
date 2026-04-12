import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/homework_provider.dart';
import '../../providers/lesson_provider.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/animated_pressable.dart';

class HomeworkCreateScreen extends ConsumerStatefulWidget {
  final int sessionId;

  const HomeworkCreateScreen({super.key, required this.sessionId});

  @override
  ConsumerState<HomeworkCreateScreen> createState() =>
      _HomeworkCreateScreenState();
}

class _HomeworkCreateScreenState extends ConsumerState<HomeworkCreateScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() async {
    final l10n = context.l10n;
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.homeworkTitleRequired)));
      return;
    }

    final success = await ref
        .read(homeworkControllerProvider.notifier)
        .createHomework(
          sessionId: widget.sessionId,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          dueDate: _dueDate != null
              ? DateFormat('yyyy-MM-dd').format(_dueDate!)
              : null,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.homeworkCreatedSuccess),
          backgroundColor: TeacherAppColors.success,
        ),
      );
      final sessionState = ref.read(
        lessonSessionControllerProvider(widget.sessionId),
      );
      final quarterId =
          sessionState.detail?.session.quarterId ??
          ref.read(currentHomeworkQuarterIdProvider);

      if (quarterId != null) {
        ref.invalidate(lessonHomeworksProvider({'quarter_id': quarterId}));
      }
      context.pop();
    } else if (mounted) {
      final state = ref.read(homeworkControllerProvider);
      final errorMsg = ApiErrorHandler.readableMessage(state.error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
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
    final state = ref.watch(homeworkControllerProvider);
    final isLoading = state.isLoading;

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            l10n.homeworkCreateTitle,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          physics: const BouncingScrollPhysics(),
          children: [
            PremiumCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FormLabel(label: l10n.homeworkTitleLabel),
                  const SizedBox(height: 12),
                  _GlassTextField(
                    controller: _titleController,
                    hint: l10n.homeworkTitleHint,
                    fontWeight: FontWeight.w800,
                  ),
                  const SizedBox(height: 24),
                  _FormLabel(label: l10n.homeworkDescriptionTitle),
                  const SizedBox(height: 12),
                  _GlassTextField(
                    controller: _descController,
                    hint: l10n.homeworkDescriptionHint,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PremiumCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FormLabel(label: l10n.homeworkDueDateTitle),
                  const SizedBox(height: 12),
                  AnimatedPressable(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        locale: Locale(l10n.appLocale.name),
                        initialDate: DateTime.now().add(
                          const Duration(days: 1),
                        ),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => _dueDate = date);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _dueDate != null
                              ? colorScheme.primary.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 20,
                            color: _dueDate != null
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _dueDate != null
                                ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                                : l10n.homeworkSelectDueDate,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _dueDate != null
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurface.withValues(
                                      alpha: 0.3,
                                    ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: colorScheme.onSurface.withValues(alpha: 0.2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            AnimatedPressable(
              onTap: isLoading ? null : _submit,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l10n.saveAction.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 1.5,
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

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final FontWeight fontWeight;

  const _GlassTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(fontWeight: fontWeight, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String label;
  const _FormLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 11,
        letterSpacing: 1,
        color: colorScheme.primary.withValues(alpha: 0.8),
      ),
    );
  }
}
