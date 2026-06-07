import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../../data/settings_service.dart';

/// Notifier that persists [ThemeMode] to [SettingsService].
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SettingsService _settings;

  ThemeModeNotifier(this._settings)
      : super(_settings.themeMode == 'light'
            ? ThemeMode.light
            : _settings.themeMode == 'dark'
                ? ThemeMode.dark
                : ThemeMode.system);

  void setThemeMode(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    _settings.themeMode = value;
    state = mode;
  }
}

/// Provides the current [ThemeMode] based on the persisted setting.
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  return ThemeModeNotifier(settings);
});
