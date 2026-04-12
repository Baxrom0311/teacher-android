import '../../../core/constants/app_colors.dart';
import '../../../core/constants/liquid_glass.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/subject_provider.dart';
import '../../../data/models/subject_model.dart';
import '../../common/page_background.dart';
import '../../common/premium_card.dart';
import '../../common/animated_pressable.dart';
import '../../widgets/app_feedback.dart';
import 'dart:ui';

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
        'pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'jpg', 'jpeg', 'png',
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
      AppFeedback.showError(context, l10n.topicTitleRequired);
      return;
    }

    if (_filePaths.isEmpty) {
      AppFeedback.showError(context, l10n.topicFilesRequired);
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
      AppFeedback.showSuccess(context, l10n.topicSaved);
      ref.invalidate(subjectDetailProvider(widget.subjectId));
      context.pop();
    } else if (mounted) {
      final state = ref.read(subjectControllerProvider);
      AppFeedback.showError(context, ApiErrorHandler.readableMessage(state.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(subjectControllerProvider);
    final isLoading = state.isLoading;

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.newTopicTitle, style: const TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PremiumCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.people_rounded, color: colorScheme.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.groupLabelText(widget.groupContext.groupName),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              _SectionTitle(title: l10n.topicTitleLabel),
              _InputField(
                controller: _titleController,
                hintText: l10n.topicTitleHint,
                enabled: !isLoading,
              ),
              const SizedBox(height: 20),

              _SectionTitle(title: l10n.topicDescriptionLabel),
              _InputField(
                controller: _descController,
                hintText: l10n.topicDescriptionHint,
                enabled: !isLoading,
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionTitle(title: l10n.attachedFilesTitle),
                  AnimatedPressable(
                    onTap: isLoading ? null : _pickFiles,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add_rounded, size: 18, color: colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            l10n.chooseFileAction,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_filePaths.isEmpty)
                PremiumCard(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          size: 32,
                          color: colorScheme.onSurface.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.noFilesSelected,
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _FileItem(
                        name: filename,
                        onDelete: () => _removeFile(path),
                      ),
                    );
                  },
                ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: AnimatedPressable(
              onTap: isLoading ? null : _submit,
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isLoading 
                      ? [colorScheme.surfaceVariant, colorScheme.surfaceVariant] 
                      : [colorScheme.primary, colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    if (!isLoading)
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                  ],
                ),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          l10n.addTopicAction,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.hintText,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}

class _FileItem extends StatelessWidget {
  final String name;
  final VoidCallback onDelete;

  const _FileItem({required this.name, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.file_present_rounded, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: TeacherAppColors.error, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

