import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teacher_school_app/core/constants/app_colors.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../data/models/gallery_model.dart';
import '../../providers/gallery_provider.dart';

class TeacherGalleryAlbumScreen extends ConsumerStatefulWidget {
  final GalleryAlbumModel album;

  const TeacherGalleryAlbumScreen({super.key, required this.album});

  @override
  ConsumerState<TeacherGalleryAlbumScreen> createState() => _TeacherGalleryAlbumScreenState();
}

class _TeacherGalleryAlbumScreenState extends ConsumerState<TeacherGalleryAlbumScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(galleryPhotosProvider.notifier).loadPhotos(widget.album.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsRegistry.instance;
    final theme = Theme.of(context);
    final state = ref.watch(galleryPhotosProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.album.title), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: state.isUploading ? null : () => _pickAndUpload(),
        child: state.isUploading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.add_a_photo_rounded),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text(l10n.galleryLoadFailed))
              : state.photos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.photo_outlined, size: 56, color: TeacherAppColors.slate400),
                          const SizedBox(height: 12),
                          Text(l10n.galleryNoPhotos,
                              style: theme.textTheme.bodyLarge?.copyWith(color: TeacherAppColors.slate500)),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: state.photos.length,
                      itemBuilder: (context, index) {
                        final photo = state.photos[index];
                        return GestureDetector(
                          onTap: () => _showFullScreen(context, state.photos, index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              photo.filePath,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: TeacherAppColors.slate200,
                                child: const Icon(Icons.broken_image_rounded,
                                    color: TeacherAppColors.slate400),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images.isEmpty) return;

    final paths = images.map((e) => e.path).toList();
    final ok = await ref.read(galleryPhotosProvider.notifier).uploadPhotos(widget.album.id, paths);
    if (!ok && mounted) {
      final l10n = AppLocalizationsRegistry.instance;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.galleryUploadFailed)),
      );
    }
  }

  void _showFullScreen(BuildContext context, List<GalleryPhotoModel> photos, int initialIndex) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _FullScreenGallery(photos: photos, initialIndex: initialIndex),
    ));
  }
}

class _FullScreenGallery extends StatelessWidget {
  final List<GalleryPhotoModel> photos;
  final int initialIndex;

  const _FullScreenGallery({required this.photos, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return InteractiveViewer(
            child: Center(
              child: Image.network(
                photo.filePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image_rounded,
                  size: 48,
                  color: Colors.white54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
