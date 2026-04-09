import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/subject_model.dart';
import '../../providers/subject_provider.dart';

class SubjectDetailScreen extends ConsumerStatefulWidget {
  final int subjectId;
  final String title;

  const SubjectDetailScreen({
    super.key,
    required this.subjectId,
    required this.title,
  });

  @override
  ConsumerState<SubjectDetailScreen> createState() =>
      _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends ConsumerState<SubjectDetailScreen> {
  Future<void> _launchUrl(String url) async {
    final l10n = context.l10n;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.fileOpenFailed)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final detailAsync = ref.watch(subjectDetailProvider(widget.subjectId));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: detailAsync.when(
        data: (data) {
          final groups = data['groups'] as List<SubjectDetail>;

          if (groups.isEmpty) {
            return Center(
              child: Text(
                l10n.noTopicsYet,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return _buildGroupSection(context, group);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text(ApiErrorHandler.readableMessage(err))),
      ),
    );
  }

  Widget _buildGroupSection(BuildContext context, SubjectDetail group) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              group.groupName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle, color: colorScheme.primary),
              tooltip: l10n.addTopicTooltip,
              onPressed: () {
                context.push(
                  '/subjects/${widget.subjectId}/create-topic',
                  extra: group,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (group.topics.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              l10n.noTopicsForGroup,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          )
        else
          ...group.topics.map((topic) => _buildTopicCard(topic)),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTopicCard(TopicData topic) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#${topic.orderNo ?? '-'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  topic.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          if (topic.description != null && topic.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              topic.description!,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
          if (topic.resources.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.filesTitle,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topic.resources
                  .map(
                    (res) => InkWell(
                      onTap: () => _launchUrl(res.url),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colorScheme.outline),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.download,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                res.title,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
