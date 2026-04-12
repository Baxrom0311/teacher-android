import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/subject_model.dart';
import '../../providers/subject_provider.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/animated_pressable.dart';
import '../../widgets/app_feedback.dart';

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
    final detailAsync = ref.watch(subjectDetailProvider(widget.subjectId));

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: detailAsync.when(
          data: (data) {
            final groups = data['groups'] as List<SubjectDetail>;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (groups.isEmpty)
                  SliverFillRemaining(
                    child: AppEmptyView(
                      title: l10n.noTopicsYet,
                      icon: Icons.topic_outlined,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final group = groups[index];
                        return _GroupSection(
                          group: group,
                          subjectId: widget.subjectId,
                          onLaunchUrl: _launchUrl,
                        );
                      }, childCount: groups.length),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: AppLoadingView()),
          error: (err, stack) => Center(
            child: AppErrorView(
              message: ApiErrorHandler.readableMessage(err),
              onRetry: () =>
                  ref.invalidate(subjectDetailProvider(widget.subjectId)),
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupSection extends StatelessWidget {
  final SubjectDetail group;
  final int subjectId;
  final Function(String) onLaunchUrl;

  const _GroupSection({
    required this.group,
    required this.subjectId,
    required this.onLaunchUrl,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group.groupName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              AnimatedPressable(
                onTap: () => GoRouter.of(
                  context,
                ).push('/subjects/$subjectId/create-topic', extra: group),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.addTopicTooltip,
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
        ),
        if (group.topics.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
            child: Text(
              l10n.noTopicsForGroup,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          ...group.topics.map(
            (topic) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TopicItem(topic: topic, onLaunchUrl: onLaunchUrl),
            ),
          ),
        const SizedBox(height: 16),
        Divider(color: Colors.white.withValues(alpha: 0.05), thickness: 1),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _TopicItem extends StatelessWidget {
  final TopicData topic;
  final Function(String) onLaunchUrl;
  const _TopicItem({required this.topic, required this.onLaunchUrl});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '#${topic.orderNo ?? '-'}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    if (topic.description?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 6),
                      Text(
                        topic.description!,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 14,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (topic.resources.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.attachment_rounded,
                    size: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.filesTitle.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      letterSpacing: 0.5,
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topic.resources
                  .map(
                    (res) => _ResourceChip(
                      res: res,
                      onTap: () => onLaunchUrl(res.url),
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

class _ResourceChip extends StatelessWidget {
  final TopicResource res;
  final VoidCallback onTap;
  const _ResourceChip({required this.res, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.file_open_rounded, size: 16, color: colorScheme.primary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                res.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
