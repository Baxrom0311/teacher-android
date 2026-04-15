import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../providers/quiz_provider.dart';

class QuizCreateScreen extends ConsumerStatefulWidget {
  const QuizCreateScreen({super.key});

  @override
  ConsumerState<QuizCreateScreen> createState() => _QuizCreateScreenState();
}

class _QuizCreateScreenState extends ConsumerState<QuizCreateScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _timeLimitController = TextEditingController();
  final _questions = <_QuestionForm>[];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _addQuestion();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _timeLimitController.dispose();
    for (final q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  void _addQuestion() {
    setState(() {
      _questions.add(_QuestionForm());
    });
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final questions = <Map<String, dynamic>>[];
    for (final q in _questions) {
      final text = q.questionController.text.trim();
      if (text.isEmpty) continue;
      final options = q.optionControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      if (options.length < 2) continue;
      questions.add({
        'question': text,
        'options': options,
        'correct_answer': q.correctIndex,
      });
    }

    if (questions.isEmpty) return;

    setState(() => _isSubmitting = true);

    final payload = {
      'title': title,
      if (_descController.text.trim().isNotEmpty)
        'description': _descController.text.trim(),
      if (_timeLimitController.text.trim().isNotEmpty)
        'time_limit_minutes': int.tryParse(_timeLimitController.text.trim()),
      'questions': questions,
      'max_score': questions.length,
    };

    final success = await ref.read(teacherQuizProvider.notifier).createQuiz(payload);
    if (success && mounted) {
      context.pop();
    } else {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizationsRegistry.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quizCreateTitle),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(l10n.quizSave),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: l10n.quizTitleHint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            decoration: InputDecoration(
              labelText: l10n.quizDescHint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _timeLimitController,
            decoration: InputDecoration(
              labelText: l10n.quizTimeLimitHint,
              suffixText: 'min',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          Text(l10n.quizQuestions, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ..._questions.asMap().entries.map((entry) {
            final idx = entry.key;
            final q = entry.value;
            return _QuestionFormWidget(
              key: ValueKey(idx),
              index: idx + 1,
              form: q,
              onRemove: _questions.length > 1
                  ? () => setState(() {
                        _questions[idx].dispose();
                        _questions.removeAt(idx);
                      })
                  : null,
            );
          }),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _addQuestion,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.quizAddQuestion),
          ),
        ],
      ),
    );
  }
}

class _QuestionForm {
  final questionController = TextEditingController();
  final optionControllers = List.generate(4, (_) => TextEditingController());
  int correctIndex = 0;

  void dispose() {
    questionController.dispose();
    for (final c in optionControllers) {
      c.dispose();
    }
  }
}

class _QuestionFormWidget extends StatefulWidget {
  final int index;
  final _QuestionForm form;
  final VoidCallback? onRemove;

  const _QuestionFormWidget({
    super.key,
    required this.index,
    required this.form,
    this.onRemove,
  });

  @override
  State<_QuestionFormWidget> createState() => _QuestionFormWidgetState();
}

class _QuestionFormWidgetState extends State<_QuestionFormWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizationsRegistry.instance;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${l10n.quizQuestionN} ${widget.index}',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              if (widget.onRemove != null)
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: TeacherAppColors.danger,
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.form.questionController,
            decoration: InputDecoration(
              hintText: l10n.quizQuestionHint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          ...widget.form.optionControllers.asMap().entries.map((entry) {
            final idx = entry.key;
            final ctrl = entry.value;
            final isCorrect = widget.form.correctIndex == idx;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => widget.form.correctIndex = idx),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCorrect ? TeacherAppColors.success : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCorrect ? TeacherAppColors.success : TeacherAppColors.slate300,
                          width: 2,
                        ),
                      ),
                      child: isCorrect
                          ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: ctrl,
                      decoration: InputDecoration(
                        hintText: '${l10n.quizOptionHint} ${String.fromCharCode(65 + idx)}',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
