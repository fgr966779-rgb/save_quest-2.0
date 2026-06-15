// ФАЙЛ: lib/core/services/biometric_service.dart
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/foundation.dart';

/// Service for biometric authentication using device hardware.
/// Supports fingerprint, face recognition, and iris scanning via local_auth.
class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _auth = LocalAuthentication();

  /// Checks if the device supports biometric authentication.
  /// Returns true if at least one biometric sensor is available.
  Future<bool> isAvailable() async {
    try {
      return await _auth.canCheckBiometrics ||
          await _auth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  /// Returns the list of available biometric types on this device.
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Returns a human-readable label for the available biometric type.
  /// For example: "Face ID", "Touch ID", "Fingerprint", etc.
  Future<String> getBiometricLabel() async {
    final types = await getAvailableBiometrics();
    if (types.contains(BiometricType.face)) return 'Face ID';
    if (types.contains(BiometricType.fingerprint)) return 'Touch ID';
    if (types.contains(BiometricType.iris)) return 'Iris';
    return 'Biometric';
  }

  /// Attempts to authenticate the user with biometrics.
  /// 
  /// [reason] — the message shown to the user in the system prompt.
  /// [fallbackToPin] — if true, allows device PIN/passcode as fallback.
  /// 
  /// Returns true if authentication succeeded, false otherwise.
  Future<bool> authenticate({
    String reason = 'Authenticate to access PiggyVault',
    bool fallbackToPin = true,
  }) async {
    try {
      final didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: !fallbackToPin,
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      debugPrint('Biometric auth error: \$1');
      return false;
    }
  }

  /// Checks if biometric is both available AND enrolled (has enrolled prints/face).
  /// Use this to decide whether to show the biometric toggle in settings.
  Future<bool> canEnable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) return false;

      final available = await _auth.getAvailableBiometrics();
      return available.isNotEmpty;
    } on PlatformException {
      return false;
    }
  }
}
