import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/assessment_provider.dart';
import '../../widgets/app_feedback.dart';

class AssessmentCreateScreen extends ConsumerStatefulWidget {
  const AssessmentCreateScreen({super.key});

  @override
  ConsumerState<AssessmentCreateScreen> createState() =>
      _AssessmentCreateScreenState();
}

class _AssessmentCreateScreenState
    extends ConsumerState<AssessmentCreateScreen> {
  final _titleController = TextEditingController();
  final _maxScoreController = TextEditingController(text: '100');
  final _weightController = TextEditingController(text: '1.0');
  DateTime? _heldAt = DateTime.now();

  int? _selectedQuarterId;
  int? _selectedGroupId;
  int? _selectedSubjectId;
  String _selectedType = 'exam';

  final List<String> _types = ['exam', 'quiz', 'oral', 'project'];

  @override
  void dispose() {
    _titleController.dispose();
    _maxScoreController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submit() async {
    final l10n = context.l10n;

    if (_selectedQuarterId == null ||
        _selectedGroupId == null ||
        _selectedSubjectId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.assessmentRequiredFields)));
      return;
    }

    final data = {
      'quarter_id': _selectedQuarterId,
      'group_id': _selectedGroupId,
      'subject_id': _selectedSubjectId,
      'type': _selectedType,
      'title': _titleController.text.trim(),
      'max_score': int.tryParse(_maxScoreController.text) ?? 100,
      'weight': double.tryParse(_weightController.text) ?? 1.0,
      'held_at': _heldAt != null
          ? DateFormat('yyyy-MM-dd').format(_heldAt!)
          : null,
    };

    final success = await ref
        .read(assessmentControllerProvider.notifier)
        .saveAssessment(data);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.assessmentCreatedSuccess),
          backgroundColor: TeacherAppColors.success,
        ),
      );
      ref.invalidate(assessmentsListProvider({}));
      context.pop();
    } else if (mounted) {
      final state = ref.read(assessmentControllerProvider);
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
    final optionsAsync = ref.watch(assessmentOptionsProvider({}));
    final state = ref.watch(assessmentControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.assessmentCreateTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: optionsAsync.when(
        data: (options) {
          final groups = options['groups'] as List;
          final subjects = options['subjects'] as List;
          final quarters = options['quarters'] as List;

          if (_selectedQuarterId == null && quarters.isNotEmpty) {
            _selectedQuarterId =
                options['currentQuarterId'] ?? quarters.first.id;
          }
          if (_selectedGroupId == null && groups.isNotEmpty) {
            _selectedGroupId = groups.first.id;
          }
          if (_selectedSubjectId == null && subjects.isNotEmpty) {
            _selectedSubjectId = subjects.first.id;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.assessmentQuarterLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                DropdownButtonFormField<int>(
                  initialValue: _selectedQuarterId,
                  decoration: const InputDecoration(),
                  items: quarters
                      .map(
                        (e) => DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedQuarterId = val),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.assessmentGroupLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                DropdownButtonFormField<int>(
                  initialValue: _selectedGroupId,
                  decoration: const InputDecoration(),
                  items: groups
                      .map(
                        (e) => DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedGroupId = val),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.assessmentSubjectLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                DropdownButtonFormField<int>(
                  initialValue: _selectedSubjectId,
                  decoration: const InputDecoration(),
                  items: subjects
                      .map(
                        (e) => DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedSubjectId = val),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.assessmentTypeFieldLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  decoration: const InputDecoration(),
                  items: _types
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(l10n.assessmentTypeLabelText(e)),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedType = val!),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.assessmentOptionalTitleLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: l10n.assessmentOptionalTitleHint,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.assessmentMaxScoreLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          TextField(
                            controller: _maxScoreController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.assessmentWeightLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          TextField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.assessmentDateLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _heldAt ?? DateTime.now(),
                      locale: Locale(l10n.appLocale.name),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) setState(() => _heldAt = date);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outline),
                    ),
                    child: Text(
                      _heldAt != null
                          ? DateFormat(
                              'yyyy-MM-dd',
                              l10n.intlLocaleTag,
                            ).format(_heldAt!)
                          : l10n.assessmentSelectDate,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            l10n.saveAction,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const AppLoadingView(),
        error: (err, stack) => AppErrorView(
          message: ApiErrorHandler.readableMessage(err),
          icon: Icons.note_add_outlined,
        ),
      ),
    );
  }
}
