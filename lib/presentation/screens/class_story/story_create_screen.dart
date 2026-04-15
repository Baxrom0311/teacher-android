import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../providers/class_story_provider.dart';

class StoryCreateScreen extends ConsumerStatefulWidget {
  const StoryCreateScreen({super.key});

  @override
  ConsumerState<StoryCreateScreen> createState() => _StoryCreateScreenState();
}

class _StoryCreateScreenState extends ConsumerState<StoryCreateScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isPinned = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final body = _bodyController.text.trim();
    if (body.isEmpty) return;

    final success = await ref.read(classStoryProvider.notifier).createStory(
          body: body,
          title: _titleController.text.trim().isNotEmpty
              ? _titleController.text.trim()
              : null,
          isPinned: _isPinned,
        );

    if (success && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizationsRegistry.instance;
    final state = ref.watch(classStoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.classStoryCreateTitle),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: state.isCreating ? null : _submit,
              child: state.isCreating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(l10n.classStoryPublish),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.classStoryTitleHint,
                hintText: l10n.classStoryTitleHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Body field
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: l10n.classStoryBodyHint,
                hintText: l10n.classStoryBodyHint,
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              maxLines: 8,
              minLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Pin toggle
            SwitchListTile(
              value: _isPinned,
              onChanged: (v) => setState(() => _isPinned = v),
              title: Text(l10n.classStoryPinLabel,
                  style: theme.textTheme.bodyLarge),
              secondary: Icon(Icons.push_pin_rounded,
                  color: _isPinned
                      ? TeacherAppColors.amber
                      : TeacherAppColors.slate400),
              contentPadding: EdgeInsets.zero,
            ),

            if (state.error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TeacherAppColors.danger.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        size: 18, color: TeacherAppColors.danger),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.classStoryCreateFailed,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: TeacherAppColors.danger),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
