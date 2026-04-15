import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/class_story_model.dart';
import '../../providers/class_story_provider.dart';

class ClassStoryScreen extends ConsumerStatefulWidget {
  const ClassStoryScreen({super.key});

  @override
  ConsumerState<ClassStoryScreen> createState() => _ClassStoryScreenState();
}

class _ClassStoryScreenState extends ConsumerState<ClassStoryScreen> {
  final _scrollController = ScrollController();
  final _commentControllers = <int, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    ref.read(classStoryProvider.notifier).loadStories();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(classStoryProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final c in _commentControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizationsRegistry.instance;
    final state = ref.watch(classStoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.classStoryTitle),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(TeacherRoutes.storyCreate),
        backgroundColor: TeacherAppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: 12),
                      Text(l10n.classStoryLoadFailed,
                          style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(l10n.retry),
                      ),
                    ],
                  ),
                )
              : state.stories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.article_outlined,
                              size: 56, color: TeacherAppColors.slate400),
                          const SizedBox(height: 12),
                          Text(l10n.classStoryEmpty,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                  color: TeacherAppColors.slate500)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async => _load(),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: state.stories.length +
                            (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.stories.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child:
                                  Center(child: CircularProgressIndicator()),
                            );
                          }
                          return _StoryCard(
                            story: state.stories[index],
                            commentController:
                                _commentControllers.putIfAbsent(
                              state.stories[index].id,
                              () => TextEditingController(),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

class _StoryCard extends ConsumerWidget {
  final ClassStoryModel story;
  final TextEditingController commentController;

  const _StoryCard({required this.story, required this.commentController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizationsRegistry.instance;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: TeacherAppColors.skyBlue50,
                  backgroundImage: story.author.avatarUrl != null
                      ? NetworkImage(story.author.avatarUrl!)
                      : null,
                  child: story.author.avatarUrl == null
                      ? Text(
                          (story.author.name ?? '?')[0].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: TeacherAppColors.skyBlue600,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.author.name ?? '',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      if (story.timeAgo != null)
                        Text(
                          story.timeAgo!,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: TeacherAppColors.slate400),
                        ),
                    ],
                  ),
                ),
                if (story.isPinned)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: TeacherAppColors.amber.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.push_pin_rounded,
                        size: 14, color: TeacherAppColors.amber),
                  ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded,
                      color: TeacherAppColors.slate400),
                  onSelected: (value) {
                    if (value == 'delete') {
                      ref
                          .read(classStoryProvider.notifier)
                          .deleteStory(story.id);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline,
                              size: 18, color: TeacherAppColors.danger),
                          const SizedBox(width: 8),
                          Text(l10n.classStoryDelete),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Title
          if (story.title != null && story.title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                story.title!,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),

          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              story.body,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),

          // Media
          if (story.media.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: story.media.length == 1
                    ? _MediaItem(media: story.media.first)
                    : SizedBox(
                        height: 180,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: story.media.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (_, i) => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 240,
                              child: _MediaItem(media: story.media[i]),
                            ),
                          ),
                        ),
                      ),
              ),
            ),

          // Like & Comment bar
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () => ref
                      .read(classStoryProvider.notifier)
                      .toggleLike(story.id),
                  icon: Icon(
                    story.isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 20,
                    color: story.isLiked
                        ? TeacherAppColors.danger
                        : TeacherAppColors.slate400,
                  ),
                  label: Text(
                    '${story.likesCount}',
                    style: TextStyle(
                      color: story.isLiked
                          ? TeacherAppColors.danger
                          : TeacherAppColors.slate500,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline_rounded,
                      size: 18, color: TeacherAppColors.slate400),
                  label: Text(
                    '${story.commentsCount}',
                    style: const TextStyle(color: TeacherAppColors.slate500),
                  ),
                ),
              ],
            ),
          ),

          // Recent comments
          if (story.comments.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                children: story.comments
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${c.userName ?? ''}: ',
                                style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700),
                              ),
                              Expanded(
                                child: Text(c.body,
                                    style: theme.textTheme.bodySmall),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],

          // Comment input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: l10n.classStoryCommentHint,
                      hintStyle: theme.textTheme.bodySmall
                          ?.copyWith(color: TeacherAppColors.slate400),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline
                              .withValues(alpha: 0.1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline
                              .withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    style: theme.textTheme.bodySmall,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) => _sendComment(ref, value),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () =>
                      _sendComment(ref, commentController.text),
                  icon: const Icon(Icons.send_rounded, size: 20),
                  color: TeacherAppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendComment(WidgetRef ref, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    ref.read(classStoryProvider.notifier).addComment(story.id, trimmed);
    commentController.clear();
  }
}

class _MediaItem extends StatelessWidget {
  final StoryMedia media;

  const _MediaItem({required this.media});

  @override
  Widget build(BuildContext context) {
    if (media.type == 'video') {
      return Container(
        height: 180,
        color: TeacherAppColors.slate200,
        child: const Center(
          child: Icon(Icons.play_circle_fill_rounded,
              size: 48, color: TeacherAppColors.slate500),
        ),
      );
    }
    return Image.network(
      media.url,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 180,
        color: TeacherAppColors.slate200,
        child: const Center(
          child: Icon(Icons.broken_image_rounded,
              size: 36, color: TeacherAppColors.slate400),
        ),
      ),
    );
  }
}
