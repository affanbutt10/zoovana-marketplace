import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  CacheService(this._prefs);

  final SharedPreferences _prefs;

  /// Exposes the underlying prefs for use by [TimedCacheService].
  SharedPreferences get prefs => _prefs;

  Future<void> writeJson(String key, Object value) async {
    await _prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? readJsonMap(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  List<dynamic>? readJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return List<dynamic>.from(jsonDecode(raw) as List);
  }

  Future<void> writeStringList(String key, List<String> value) {
    return _prefs.setStringList(key, value);
  }

  List<String> readStringList(String key) {
    return _prefs.getStringList(key) ?? const <String>[];
  }

  Future<void> remove(String key) => _prefs.remove(key);
}
