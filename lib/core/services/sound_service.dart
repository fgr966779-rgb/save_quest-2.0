// FILE: lib/core/services/sound_service.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Service for playing UI sound effects.
/// All playback is gated behind `isSoundEnabled` setting.
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isSoundEnabled = true;

  /// Update sound enabled state (from Settings).
  set isSoundEnabled(bool value) => _isSoundEnabled = value;

  /// Play deposit confirmation sound.
  Future<void> playDeposit() async {
    if (!_isSoundEnabled) return;
    try {
      await _player.play(AssetSource('sounds/deposit.mp3'));
    } catch (e) {
      debugPrint('SoundService.playDeposit error: $e');
    }
  }

  /// Play achievement unlock sound.
  Future<void> playAchievement() async {
    if (!_isSoundEnabled) return;
    try {
      await _player.play(AssetSource('sounds/achievement.mp3'));
    } catch (e) {
      debugPrint('SoundService.playAchievement error: $e');
    }
  }

  /// Play lootbox open / daily spin sound.
  Future<void> playLootbox() async {
    if (!_isSoundEnabled) return;
    try {
      await _player.play(AssetSource('sounds/lootbox.mp3'));
    } catch (e) {
      debugPrint('SoundService.playLootbox error: $e');
    }
  }

  /// Play a UI tap / navigation click sound.
  Future<void> playClick() async {
    if (!_isSoundEnabled) return;
    // Lightweight click — using the deposit sound at low volume as placeholder
    // until custom click.mp3 is added
    try {
      _player.setVolume(0.3);
      await _player.play(AssetSource('sounds/deposit.mp3'));
      _player.setVolume(1.0);
    } catch (e) {
      debugPrint('SoundService.playClick error: $e');
    }
  }

  /// Dispose the audio player.
  void dispose() {
    _player.dispose();
  }
}
