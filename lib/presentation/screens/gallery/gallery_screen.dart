import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_school_app/core/constants/app_colors.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/gallery_model.dart';
import '../../providers/gallery_provider.dart';

class TeacherGalleryScreen extends ConsumerStatefulWidget {
  const TeacherGalleryScreen({super.key});

  @override
  ConsumerState<TeacherGalleryScreen> createState() => _TeacherGalleryScreenState();
}

class _TeacherGalleryScreenState extends ConsumerState<TeacherGalleryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(galleryAlbumsProvider.notifier).loadAlbums();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsRegistry.instance;
    final theme = Theme.of(context);
    final state = ref.watch(galleryAlbumsProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.galleryTitle), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateAlbumDialog(context),
        child: const Icon(Icons.add_photo_alternate_rounded),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: 12),
                      Text(l10n.galleryLoadFailed, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => ref.read(galleryAlbumsProvider.notifier).loadAlbums(),
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(l10n.retry),
                      ),
                    ],
                  ),
                )
              : state.albums.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.photo_library_outlined, size: 56, color: TeacherAppColors.slate400),
                          const SizedBox(height: 12),
                          Text(l10n.galleryEmpty,
                              style: theme.textTheme.bodyLarge?.copyWith(color: TeacherAppColors.slate500)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async => ref.read(galleryAlbumsProvider.notifier).loadAlbums(),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: state.albums.length,
                        itemBuilder: (context, index) => _AlbumCard(
                          album: state.albums[index],
                          isDark: isDark,
                          onDelete: () => _confirmDelete(context, state.albums[index]),
                        ),
                      ),
                    ),
    );
  }

  void _showCreateAlbumDialog(BuildContext context) {
    final l10n = AppLocalizationsRegistry.instance;
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.galleryCreateAlbum),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(hintText: l10n.galleryAlbumTitleHint),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(hintText: l10n.galleryAlbumDescHint),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              final ok = await ref.read(galleryAlbumsProvider.notifier).createAlbum(
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                  );
              if (!ok && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.galleryCreateFailed)),
                );
              }
            },
            child: Text(l10n.galleryCreate),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, GalleryAlbumModel album) {
    final l10n = AppLocalizationsRegistry.instance;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.galleryDeleteAlbum),
        content: Text('"${album.title}"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(galleryAlbumsProvider.notifier).deleteAlbum(album.id);
            },
            child: Text(l10n.galleryDelete),
          ),
        ],
      ),
    );
  }
}

class _AlbumCard extends StatelessWidget {
  final GalleryAlbumModel album;
  final bool isDark;
  final VoidCallback onDelete;

  const _AlbumCard({required this.album, required this.isDark, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizationsRegistry.instance;

    return GestureDetector(
      onTap: () => context.push(TeacherRoutes.galleryAlbum, extra: album),
      onLongPress: onDelete,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: album.coverUrl != null
                    ? Image.network(
                        album.coverUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _PlaceholderCover(),
                      )
                    : _PlaceholderCover(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.title,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${album.photosCount} ${l10n.galleryPhotos}',
                    style: theme.textTheme.bodySmall?.copyWith(color: TeacherAppColors.slate400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: TeacherAppColors.slate100,
      child: const Center(
        child: Icon(Icons.photo_library_rounded, size: 32, color: TeacherAppColors.slate300),
      ),
    );
  }
}
