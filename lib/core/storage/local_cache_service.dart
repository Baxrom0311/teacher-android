import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'shared_prefs_service.dart';

final localCacheServiceProvider = Provider<LocalCacheService>((ref) {
  return LocalCacheService();
});

class LocalCacheService {
  static const String _boxName = 'teacher_api_cache_box';
  Box? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  String _resolveKey(String key) {
    final scope = SharedPrefsService.getUserScope();
    return scope != null ? '$scope$key' : key;
  }

  /// Write data to cache
  Future<void> save(String key, dynamic data) async {
    if (_box == null) await init();
    try {
      final jsonString = jsonEncode(data);
      await _box!.put(_resolveKey(key), jsonString);
    } catch (e) {
      // Ignore cache write errors
    }
  }

  /// Read data from cache
  Future<dynamic> read(String key) async {
    if (_box == null) await init();
    try {
      final jsonString = _box!.get(_resolveKey(key)) as String?;
      if (jsonString != null) {
        return jsonDecode(jsonString);
      }
    } catch (e) {
      // Ignore read parsing errors
    }
    return null;
  }

  /// Delete cache by key
  Future<void> delete(String key) async {
    if (_box == null) await init();
    await _box!.delete(_resolveKey(key));
  }

  /// Clear all cache within user scope
  Future<void> clearAll() async {
    if (_box == null) await init();
    final scope = SharedPrefsService.getUserScope();
    if (scope == null) {
      await _box!.clear();
    } else {
      final keysToDelete = _box!.keys
          .where((k) => k.toString().startsWith(scope))
          .toList();
      await _box!.deleteAll(keysToDelete);
    }
  }
}
