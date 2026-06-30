import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_theme.dart';

/// Хранит и персистит пользовательские настройки приложения:
/// тема (светлая/тёмная/системная), оформление (палитра+иконки) и язык
/// интерфейса. Не хранит секретов — для PIN/биометрии см. [SecurityProvider].
class SettingsProvider extends ChangeNotifier {
  static const _keyThemeMode = 'settings.themeMode';
  static const _keyLocale = 'settings.locale';
  static const _keyAppearance = 'settings.appearance';

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  AppAppearance _appearance = AppAppearance.power;
  AppAppearance get appearance => _appearance;
  AppearanceSpec get appearanceSpec => AppTheme.specFor(_appearance);

  /// null означает "следовать системному языку".
  Locale? _locale;
  Locale? get locale => _locale;

  static const supportedLocales = [
    Locale('uz'),
    Locale('ru'),
    Locale('en'),
  ];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_keyThemeMode);
    if (modeIndex != null && modeIndex >= 0 && modeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[modeIndex];
    }
    final appearanceIndex = prefs.getInt(_keyAppearance);
    if (appearanceIndex != null &&
        appearanceIndex >= 0 &&
        appearanceIndex < AppAppearance.values.length) {
      _appearance = AppAppearance.values[appearanceIndex];
    }
    final localeCode = prefs.getString(_keyLocale);
    if (localeCode != null && localeCode.isNotEmpty) {
      _locale = Locale(localeCode);
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
  }

  Future<void> setAppearance(AppAppearance appearance) async {
    _appearance = appearance;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAppearance, appearance.index);
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_keyLocale);
    } else {
      await prefs.setString(_keyLocale, locale.languageCode);
    }
  }
}
