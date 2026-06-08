import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A cache service that wraps [SharedPreferences] and adds TTL (time-to-live)
/// support so stale entries are automatically ignored.
///
/// Each entry is stored as a JSON envelope:
/// ```json
/// { "data": <value>, "expiresAt": <epoch-ms> }
/// ```
///
/// **Default TTLs:**
/// - Product listings: 5 minutes
/// - Single product: 10 minutes
/// - Categories: 30 minutes
/// - Search results: 2 minutes
/// - Cart: no TTL (always fresh from server, cached only as fallback)
///
/// Usage:
/// ```dart
/// final cache = TimedCacheService(prefs);
///
/// // Write with 5-minute TTL
/// await cache.write('products-1', data, ttl: TimedCacheService.ttlProducts);
///
/// // Read — returns null if expired or missing
/// final cached = cache.read<List<dynamic>>('products-1');
/// ```
class TimedCacheService {
  TimedCacheService(this._prefs);

  final SharedPreferences _prefs;

  // ─── Canonical TTLs ───────────────────────────────────────────────────────

  static const Duration ttlProducts = Duration(minutes: 5);
  static const Duration ttlProduct = Duration(minutes: 10);
  static const Duration ttlCategories = Duration(minutes: 30);
  static const Duration ttlSearch = Duration(minutes: 2);
  static const Duration ttlProfile = Duration(minutes: 5);
  static const Duration ttlOrders = Duration(minutes: 2);
  static const Duration ttlReceipts = Duration(minutes: 5);

  /// No TTL — cached only as offline fallback, always refreshed from server.
  static const Duration ttlForever = Duration(days: 365);

  // ─── Write ────────────────────────────────────────────────────────────────

  Future<void> write(
    String key,
    Object value, {
    Duration ttl = ttlProducts,
  }) async {
    final envelope = {
      'data': value,
      'expiresAt': DateTime.now().add(ttl).millisecondsSinceEpoch,
    };
    await _prefs.setString(key, jsonEncode(envelope));
  }

  // ─── Read ─────────────────────────────────────────────────────────────────

  /// Returns the cached value if present and not expired, otherwise `null`.
  T? read<T>(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;

    try {
      final envelope = jsonDecode(raw) as Map<String, dynamic>;
      final expiresAt = envelope['expiresAt'] as int?;
      if (expiresAt != null &&
          DateTime.now().millisecondsSinceEpoch > expiresAt) {
        // Expired — remove silently.
        _prefs.remove(key);
        return null;
      }
      return envelope['data'] as T?;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? readMap(String key) => read<Map<String, dynamic>>(key);

  List<dynamic>? readList(String key) => read<List<dynamic>>(key);

  // ─── Invalidation ─────────────────────────────────────────────────────────

  Future<void> remove(String key) => _prefs.remove(key);

  /// Removes all keys matching [prefix].
  Future<void> removeByPrefix(String prefix) async {
    final keys = _prefs.getKeys().where((k) => k.startsWith(prefix)).toList();
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  /// Removes all expired entries. Call periodically (e.g., on app resume).
  Future<void> evictExpired() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final keys = _prefs.getKeys().toList();
    for (final key in keys) {
      final raw = _prefs.getString(key);
      if (raw == null) continue;
      try {
        final envelope = jsonDecode(raw) as Map<String, dynamic>;
        final expiresAt = envelope['expiresAt'] as int?;
        if (expiresAt != null && now > expiresAt) {
          await _prefs.remove(key);
        }
      } catch (_) {
        // Not a timed cache entry — leave it alone.
      }
    }
  }

  // ─── Compatibility shim (matches CacheService API) ────────────────────────

  Future<void> writeJson(String key, Object value) =>
      write(key, value, ttl: ttlForever);

  Map<String, dynamic>? readJsonMap(String key) => readMap(key);

  List<dynamic>? readJsonList(String key) => readList(key);

  Future<void> writeStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  List<String> readStringList(String key) =>
      _prefs.getStringList(key) ?? const <String>[];
}
