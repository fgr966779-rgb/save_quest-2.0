import 'package:flutter/services.dart';

class HapticsHelper {
  /// Triggers a double-pulse haptic feedback to simulate a heartbeat.
  static Future<void> heartbeat() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 140));
    await HapticFeedback.lightImpact();
  }
}
