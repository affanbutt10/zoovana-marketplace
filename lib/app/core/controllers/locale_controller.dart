import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  LocaleController(this._prefs);

  final SharedPreferences _prefs;
  static const _prefKey = 'zoovana_locale';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  @override
  void onInit() {
    super.onInit();
    final code = _prefs.getString(_prefKey) ?? 'en';
    _locale = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale.languageCode == locale.languageCode) return;
    _locale = locale;
    await _prefs.setString(_prefKey, locale.languageCode);
    // Update GetX's internal locale — this triggers an immediate full-app
    // rebuild with the new locale without requiring a hot restart.
    Get.updateLocale(locale);
    update();
  }
}
