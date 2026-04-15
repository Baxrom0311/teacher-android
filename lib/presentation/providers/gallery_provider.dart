import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/gallery_api.dart';
import '../../data/models/gallery_model.dart';
import 'auth_provider.dart';

final galleryApiProvider = Provider<GalleryApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return GalleryApi(apiService);
});

// ─── Albums ───

class GalleryAlbumsState {
  final bool isLoading;
  final String? error;
  final List<GalleryAlbumModel> albums;
  final bool isCreating;

  const GalleryAlbumsState({
    this.isLoading = false,
    this.error,
    this.albums = const [],
    this.isCreating = false,
  });
}

class GalleryAlbumsNotifier extends StateNotifier<GalleryAlbumsState> {
  final GalleryApi _api;

  GalleryAlbumsNotifier(this._api) : super(const GalleryAlbumsState());

  Future<void> loadAlbums() async {
    state = const GalleryAlbumsState(isLoading: true);
    try {
      final albums = await _api.getAlbums();
      state = GalleryAlbumsState(albums: albums);
    } catch (e) {
      state = GalleryAlbumsState(error: e.toString());
    }
  }

  Future<bool> createAlbum({required String title, String? description}) async {
    state = GalleryAlbumsState(albums: state.albums, isCreating: true);
    try {
      final album = await _api.createAlbum(title: title, description: description);
      state = GalleryAlbumsState(albums: [album, ...state.albums]);
      return true;
    } catch (e) {
      state = GalleryAlbumsState(albums: state.albums, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteAlbum(int albumId) async {
    try {
      await _api.deleteAlbum(albumId);
      state = GalleryAlbumsState(
        albums: state.albums.where((a) => a.id != albumId).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

final galleryAlbumsProvider =
    StateNotifierProvider.autoDispose<GalleryAlbumsNotifier, GalleryAlbumsState>(
  (ref) {
    final api = ref.watch(galleryApiProvider);
    return GalleryAlbumsNotifier(api);
  },
);

// ─── Photos ───

class GalleryPhotosState {
  final bool isLoading;
  final String? error;
  final List<GalleryPhotoModel> photos;
  final bool isUploading;

  const GalleryPhotosState({
    this.isLoading = false,
    this.error,
    this.photos = const [],
    this.isUploading = false,
  });
}

class GalleryPhotosNotifier extends StateNotifier<GalleryPhotosState> {
  final GalleryApi _api;

  GalleryPhotosNotifier(this._api) : super(const GalleryPhotosState());

  Future<void> loadPhotos(int albumId) async {
    state = const GalleryPhotosState(isLoading: true);
    try {
      final photos = await _api.getPhotos(albumId);
      state = GalleryPhotosState(photos: photos);
    } catch (e) {
      state = GalleryPhotosState(error: e.toString());
    }
  }

  Future<bool> uploadPhotos(int albumId, List<String> filePaths) async {
    state = GalleryPhotosState(photos: state.photos, isUploading: true);
    try {
      final newPhotos = await _api.uploadPhotos(albumId, filePaths);
      state = GalleryPhotosState(photos: [...state.photos, ...newPhotos]);
      return true;
    } catch (e) {
      state = GalleryPhotosState(photos: state.photos, error: e.toString());
      return false;
    }
  }
}

final galleryPhotosProvider =
    StateNotifierProvider.autoDispose<GalleryPhotosNotifier, GalleryPhotosState>(
  (ref) {
    final api = ref.watch(galleryApiProvider);
    return GalleryPhotosNotifier(api);
  },
);
