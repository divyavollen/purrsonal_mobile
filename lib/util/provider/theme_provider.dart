import 'package:flutter/material.dart';
import 'package:workspace/data/settings_database.dart';
import 'package:workspace/models/hive/settings.dart';

class ThemeProvider extends ChangeNotifier {
  final SettingsDatabase _db;
  late Settings _currentSettings;

  bool get isDarkMode => _currentSettings.theme == 'dark';

  ThemeProvider(this._db) {
    _currentSettings = _db.settings;
  }

  ThemeMode get themeMode =>
      _currentSettings.theme == 'dark' ? ThemeMode.dark : ThemeMode.light;

  Future<void> updateTheme(bool isDark) async {
    final newTheme = isDark ? 'dark' : 'light';
    _currentSettings = _currentSettings.copyWith(theme: newTheme);
    notifyListeners();
    await _db.saveSettings(_currentSettings);
  }
}
