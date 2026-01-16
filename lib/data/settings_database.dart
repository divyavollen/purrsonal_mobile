import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/models/hive/settings.dart';

class SettingsDatabase {
  final Box<Settings> _settingsBox;
  static const String _settingsKey = 'settings';

  SettingsDatabase(this._settingsBox);

  Settings get settings {
    return _settingsBox.get(
      "settings",
      defaultValue: Settings(theme: ThemeMode.light.toString()),
    )!;
  }

  Future<void> saveSettings(Settings newSettings) async {
    await _settingsBox.put(_settingsKey, newSettings);
  }
}
