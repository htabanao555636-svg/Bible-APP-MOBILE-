import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FontSizeLevel { small, medium, large, extraLarge }

extension FontSizeLevelX on FontSizeLevel {
  double get scale {
    switch (this) {
      case FontSizeLevel.small:
        return 0.85;
      case FontSizeLevel.medium:
        return 1.0;
      case FontSizeLevel.large:
        return 1.15;
      case FontSizeLevel.extraLarge:
        return 1.3;
    }
  }

  String get label {
    switch (this) {
      case FontSizeLevel.small:
        return 'Small';
      case FontSizeLevel.medium:
        return 'Medium';
      case FontSizeLevel.large:
        return 'Large';
      case FontSizeLevel.extraLarge:
        return 'Extra Large';
    }
  }
}

class FontSizeController extends ChangeNotifier {
  FontSizeController._();
  static final FontSizeController instance = FontSizeController._();

  static const _key = 'font_size_level';
  FontSizeLevel _level = FontSizeLevel.medium;

  FontSizeLevel get level => _level;
  double get scale => _level.scale;

  /// Called once at startup, before the app is shown.
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getInt(_key);
      if (saved != null && saved >= 0 && saved < FontSizeLevel.values.length) {
        _level = FontSizeLevel.values[saved];
      }
    } catch (_) {
      _level = FontSizeLevel.medium;
    }
  }

  Future<void> setLevel(FontSizeLevel level) async {
    if (level == _level) return;
    _level = level;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_key, level.index);
    } catch (_) {
      // The size still changes this session even if saving fails.
    }
  }
}
