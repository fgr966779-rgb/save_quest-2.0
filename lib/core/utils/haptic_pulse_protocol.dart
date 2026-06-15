import 'package:flutter/services.dart';
import 'dart:async';

/// HAPTIC PULSE PROTOCOL
/// Забезпечує тактильну віддачу (кіберпанк-стиль) під час ключових подій.
class HapticPulseProtocol {
  HapticPulseProtocol._();

  /// Стандартне поповнення (Pulse)
  static Future<void> cyberDepositPulse() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Велике досягнення або 100% цілі (Engine Start / Laser)
  static Future<void> milestonePulse() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  /// Помилка або глітч (Glitch Error)
  static Future<void> errorGlitchPulse() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.heavyImpact();
  }

  /// Натискання на футуристичний UI елемент
  static Future<void> uiTap() async {
    await HapticFeedback.selectionClick();
  }
}
