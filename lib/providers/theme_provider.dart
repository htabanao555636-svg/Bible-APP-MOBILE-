import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_app/app/theme.dart';

class ThemeController extends ChangeNotifier {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  static const _key = 'dark_mode';
  bool _isDark = false;
  int _restoreTab = 0;

  bool get isDark => _isDark;

  /// Called once at startup, before the app is shown.
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDark = prefs.getBool(_key) ?? false;
    } catch (_) {
      _isDark = false;
    }
    AppColors.isDark = _isDark;
  }

  /// MainScreen calls this once so you land back on the tab you switched from.
  int takeRestoreTab() {
    final tab = _restoreTab;
    _restoreTab = 0;
    return tab;
  }

  Future<void> setDark(bool value, {int restoreTab = 0}) async {
    if (value == _isDark) return;
    _isDark = value;
    AppColors.isDark = value;
    _restoreTab = restoreTab;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, value);
    } catch (_) {
      // The theme still changes this session even if saving fails.
    }
  }
}
