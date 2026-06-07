import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/settings_service.dart';
import 'providers.dart';

/// Zen Mode provider to manage the state of the reflective "read-only" dashboard.
final zenModeProvider = StateNotifierProvider<ZenModeNotifier, bool>((ref) {
  return ZenModeNotifier(ref.watch(settingsServiceProvider));
});

class ZenModeNotifier extends StateNotifier<bool> {
  final SettingsService _settingsService;

  ZenModeNotifier(this._settingsService) : super(_settingsService.isZenModeEnabled);

  void toggle() {
    state = !state;
    _settingsService.isZenModeEnabled = state;
  }
}
