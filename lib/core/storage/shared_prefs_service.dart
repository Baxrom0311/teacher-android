import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  static Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  static Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }

  /// Foydalanuvchi ID sini kesh kalitlarini ajratish uchun ishlatamiz
  static String? getUserScope() {
    return getString('user_scope_id');
  }

  static Future<void> setUserScope(String? id) async {
    if (id == null) {
      await remove('user_scope_id');
    } else {
      await setString('user_scope_id', id);
    }
  }
}
