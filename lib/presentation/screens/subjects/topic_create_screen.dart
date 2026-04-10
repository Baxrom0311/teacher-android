import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/subject_provider.dart';
import '../../../data/models/subject_model.dart';

class TopicCreateScreen extends ConsumerStatefulWidget {
  final int subjectId;
  final SubjectDetail groupContext;

  const TopicCreateScreen({
    super.key,
    required this.subjectId,
    required this.groupContext,
  });

  @override
  ConsumerState<TopicCreateScreen> createState() => _TopicCreateScreenState();
}

class _TopicCreateScreenState extends ConsumerState<TopicCreateScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final List<String> _filePaths = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'ppt',
        'pptx',
        'xls',
        'xlsx',
        'jpg',
        'jpeg',
        'png',
      ],
    );

    if (result != null) {
      setState(() {
        for (var file in result.paths) {
          if (file != null && !_filePaths.contains(file)) {
            _filePaths.add(file);
          }
        }
      });
    }
  }

  void _removeFile(String path) {
    setState(() {
      _filePaths.remove(path);
    });
  }

  void _submit() async {
    final l10n = context.l10n;
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.topicTitleRequired)));
      return;
    }

    if (_filePaths.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.topicFilesRequired)));
      return;
    }

    final success = await ref
        .read(subjectControllerProvider.notifier)
        .createTopic(
          widget.subjectId,
          widget.groupContext.groupSubjectId,
          title,
          _descController.text.trim(),
          _filePaths,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.topicSaved),
          backgroundColor: TeacherAppColors.success,
        ),
      );
      ref.invalidate(subjectDetailProvider(widget.subjectId));
      context.pop();
    } else if (mounted) {
      final state = ref.read(subjectControllerProvider);
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
    final state = ref.watch(subjectControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.newTopicTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l10n.groupLabelText(widget.groupContext.groupName),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.topicTitleLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: l10n.topicTitleHint),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.topicDescriptionLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(hintText: l10n.topicDescriptionHint),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.attachedFilesTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                TextButton.icon(
                  onPressed: isLoading ? null : _pickFiles,
                  icon: const Icon(Icons.attach_file),
                  label: Text(l10n.chooseFileAction),
                ),
              ],
            ),
            if (_filePaths.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  l10n.noFilesSelected,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filePaths.length,
                itemBuilder: (context, index) {
                  final path = _filePaths[index];
                  final filename = path.split('/').last;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outline),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      leading: Icon(
                        Icons.file_present,
                        color: colorScheme.primary,
                      ),
                      title: Text(
                        filename,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: TeacherAppColors.error,
                        ),
                        onPressed: () => _removeFile(path),
                      ),
                    ),
                  );
                },
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
                        l10n.addTopicAction,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
