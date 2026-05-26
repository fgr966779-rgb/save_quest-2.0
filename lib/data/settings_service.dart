import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static const String boxName = 'settings_box';
  final Box _box;

  SettingsService(this._box);

  static const String _keyOnboarding = 'has_completed_onboarding';
  static const String _keyCurrency = 'currency';
  static const String _keySound = 'sound_enabled';
  static const String _keyHaptic = 'haptic_enabled';
  static const String _keyLocale = 'locale';
  static const String _keyLastSpinDate = 'last_spin_date';
  static const String _keyOpenRouterApiKey = 'openrouter_api_key';
  static const String _keyCoachPersonality = 'coach_personality';
  static const String _keyBlacklistedCategories = 'blacklisted_categories';
  static const String _keyPrivacyMode = 'privacy_mode';
  static const String _keyActiveBounty = 'active_bounty';
  static const String _keyDailyQuests = 'daily_quests';
  static const String _keyDailyQuestsDate = 'daily_quests_date';
  static const String _keyThemeMode = 'theme_mode'; // 'system', 'light', 'dark'
  static const String _keyCloudBackup = 'cloud_backup_enabled';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyDailyReminder = 'daily_reminder_enabled';
  static const String _keyAchievementNotifs = 'achievement_notifs_enabled';
  static const String _keyReminderHour = 'reminder_hour';
  static const String _keyReminderMinute = 'reminder_minute';

  bool get hasCompletedOnboarding => _box.get(_keyOnboarding, defaultValue: false);
  set hasCompletedOnboarding(bool value) => _box.put(_keyOnboarding, value);

  String get currency => _box.get(_keyCurrency, defaultValue: '₴');
  set currency(String value) => _box.put(_keyCurrency, value);

  bool get isSoundEnabled => _box.get(_keySound, defaultValue: true);
  set isSoundEnabled(bool value) => _box.put(_keySound, value);

  bool get isHapticEnabled => _box.get(_keyHaptic, defaultValue: true);
  set isHapticEnabled(bool value) => _box.put(_keyHaptic, value);

  bool get privacyMode => _box.get(_keyPrivacyMode, defaultValue: false);
  set privacyMode(bool value) => _box.put(_keyPrivacyMode, value);

  String get locale => _box.get(_keyLocale, defaultValue: 'uk');
  set locale(String value) => _box.put(_keyLocale, value);

  DateTime? get lastSpinDate {
    final ms = _box.get(_keyLastSpinDate);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }
  
  set lastSpinDate(DateTime? value) {
    if (value == null) {
      _box.delete(_keyLastSpinDate);
    } else {
      _box.put(_keyLastSpinDate, value.millisecondsSinceEpoch);
    }
  }

  String get openRouterApiKey => _box.get(_keyOpenRouterApiKey, defaultValue: '');
  set openRouterApiKey(String value) => _box.put(_keyOpenRouterApiKey, value);

  /// One of: 'hacker', 'analyst', 'enthusiast'
  String get coachPersonality => _box.get(_keyCoachPersonality, defaultValue: 'hacker');
  set coachPersonality(String value) => _box.put(_keyCoachPersonality, value);

  List<String> get blacklistedCategories => 
      _box.get(_keyBlacklistedCategories, defaultValue: <String>[])?.cast<String>() ?? [];
  set blacklistedCategories(List<String> value) => _box.put(_keyBlacklistedCategories, value);

  String? get activeBounty => _box.get(_keyActiveBounty);
  set activeBounty(String? value) {
    if (value == null) {
      _box.delete(_keyActiveBounty);
    } else {
      _box.put(_keyActiveBounty, value);
    }
  }

  List<dynamic>? get dailyQuests {
    final raw = _box.get(_keyDailyQuests);
    if (raw == null) return null;
    return List<dynamic>.from(raw);
  }
  set dailyQuests(List<dynamic>? value) {
    if (value == null) {
      _box.delete(_keyDailyQuests);
    } else {
      _box.put(_keyDailyQuests, value);
    }
  }

  String get dailyQuestsDate => _box.get(_keyDailyQuestsDate, defaultValue: '');
  set dailyQuestsDate(String value) => _box.put(_keyDailyQuestsDate, value);

  /// Theme mode: 'system' (default), 'light', or 'dark'.
  String get themeMode => _box.get(_keyThemeMode, defaultValue: 'system');
  set themeMode(String value) => _box.put(_keyThemeMode, value);

  /// Cloud backup enabled (default: false — user must explicitly opt in).
  bool get isCloudBackupEnabled => _box.get(_keyCloudBackup, defaultValue: false);
  set isCloudBackupEnabled(bool value) => _box.put(_keyCloudBackup, value);

  /// Biometric authentication enabled (default: false).
  bool get isBiometricEnabled => _box.get(_keyBiometricEnabled, defaultValue: false);
  set isBiometricEnabled(bool value) => _box.put(_keyBiometricEnabled, value);

  /// Daily deposit reminder enabled (default: true).
  bool get isDailyReminderEnabled => _box.get(_keyDailyReminder, defaultValue: true);
  set isDailyReminderEnabled(bool value) => _box.put(_keyDailyReminder, value);

  /// Achievement notifications enabled (default: true).
  bool get isAchievementNotifsEnabled => _box.get(_keyAchievementNotifs, defaultValue: true);
  set isAchievementNotifsEnabled(bool value) => _box.put(_keyAchievementNotifs, value);

  /// Reminder hour (0-23), default 20 (8 PM).
  int get reminderHour => _box.get(_keyReminderHour, defaultValue: 20);
  set reminderHour(int value) => _box.put(_keyReminderHour, value);

  /// Reminder minute (0-59), default 0.
  int get reminderMinute => _box.get(_keyReminderMinute, defaultValue: 0);
  set reminderMinute(int value) => _box.put(_keyReminderMinute, value);
}
