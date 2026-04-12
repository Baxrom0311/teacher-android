import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/assessment_provider.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/animated_pressable.dart';
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

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            l10n.assessmentCreateTitle,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
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
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FormSection(
                    title: l10n.assessmentClassificationTitle,
                    children: [
                      _FormLabel(label: l10n.assessmentQuarterLabel),
                      _buildDropdown<int>(
                        value: _selectedQuarterId,
                        items: quarters
                            .map<DropdownMenuItem<int>>(
                              (e) => DropdownMenuItem<int>(
                                value: e.id as int,
                                child: Text(e.name.toString()),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedQuarterId = val),
                      ),
                      const SizedBox(height: 16),
                      _FormLabel(label: l10n.assessmentGroupLabel),
                      _buildDropdown<int>(
                        value: _selectedGroupId,
                        items: groups
                            .map<DropdownMenuItem<int>>(
                              (e) => DropdownMenuItem<int>(
                                value: e.id as int,
                                child: Text(e.name.toString()),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedGroupId = val),
                      ),
                      const SizedBox(height: 16),
                      _FormLabel(label: l10n.assessmentSubjectLabel),
                      _buildDropdown<int>(
                        value: _selectedSubjectId,
                        items: subjects
                            .map<DropdownMenuItem<int>>(
                              (e) => DropdownMenuItem<int>(
                                value: e.id as int,
                                child: Text(e.name.toString()),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedSubjectId = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _FormSection(
                    title: l10n.assessmentDetailsTitle,
                    children: [
                      _FormLabel(label: l10n.assessmentTypeFieldLabel),
                      _buildDropdown<String>(
                        value: _selectedType,
                        items: _types
                            .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(l10n.assessmentTypeLabelText(e)),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedType = val!),
                      ),
                      const SizedBox(height: 16),
                      _FormLabel(label: l10n.assessmentOptionalTitleLabel),
                      _buildTextField(
                        controller: _titleController,
                        hint: l10n.assessmentOptionalTitleHint,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _FormLabel(label: l10n.assessmentMaxScoreLabel),
                                _buildTextField(
                                  controller: _maxScoreController,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _FormLabel(label: l10n.assessmentWeightLabel),
                                _buildTextField(
                                  controller: _weightController,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _FormSection(
                    title: l10n.assessmentDateLabel,
                    children: [
                      AnimatedPressable(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _heldAt ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) setState(() => _heldAt = date);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 20,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _heldAt != null
                                    ? DateFormat(
                                        'dd.MM.yyyy',
                                        l10n.intlLocaleTag,
                                      ).format(_heldAt!)
                                    : l10n.assessmentSelectDate,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.edit_rounded,
                                size: 16,
                                color: colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  AnimatedPressable(
                    onTap: isLoading ? null : _submit,
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.secondary],
                        ),
                        borderRadius: BorderRadius.circular(20),
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
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                l10n.saveAction.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
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
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          dropdownColor: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        contentPadding: const EdgeInsets.all(18),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FormSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String label;
  const _FormLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
