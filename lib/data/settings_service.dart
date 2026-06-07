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
  static const String _keyMoodCheckIns = 'mood_check_ins';
  static const String _keyThemeMode = 'theme_mode'; // 'system', 'light', 'dark'
  static const String _keyCloudBackup = 'cloud_backup_enabled';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyDailyReminder = 'daily_reminder_enabled';
  static const String _keyAchievementNotifs = 'achievement_notifs_enabled';
  static const String _keyReminderHour = 'reminder_hour';
  static const String _keyReminderMinute = 'reminder_minute';
  static const String _keyZenModeEnabled = 'zen_mode_enabled';
  static const String _keyHasSeenNewFeaturesTooltips = 'has_seen_new_features_tooltips';

  bool get isZenModeEnabled => _box.get(_keyZenModeEnabled, defaultValue: false);
  set isZenModeEnabled(bool value) => _box.put(_keyZenModeEnabled, value);

  bool get hasSeenNewFeaturesTooltips => _box.get(_keyHasSeenNewFeaturesTooltips, defaultValue: false);
  set hasSeenNewFeaturesTooltips(bool value) => _box.put(_keyHasSeenNewFeaturesTooltips, value);

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

  List<Map<String, dynamic>> get moodCheckIns {
    final raw = _box.get(_keyMoodCheckIns, defaultValue: <dynamic>[]);
    return List<dynamic>.from(raw)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Future<void> recordMoodCheckIn({
    required String moodId,
    required String moodLabel,
    required int amount,
    required String actionType,
    String? depositId,
  }) async {
    final next = moodCheckIns;
    next.add({
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'moodId': moodId,
      'moodLabel': moodLabel,
      'amount': amount,
      'actionType': actionType,
      'depositId': depositId,
      'createdAt': DateTime.now().toIso8601String(),
    });

    const maxStoredCheckIns = 250;
    final trimmed = next.length > maxStoredCheckIns
        ? next.sublist(next.length - maxStoredCheckIns)
        : next;
    await _box.put(_keyMoodCheckIns, trimmed);
  }

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


  static const String _keyLastOverheatNotifiedDate = 'last_overheat_notified_date';

  /// Last date (formatted as yyyy-MM-dd) when an overheating notification was fired.
  String get lastOverheatNotifiedDate => _box.get(_keyLastOverheatNotifiedDate, defaultValue: '');
  set lastOverheatNotifiedDate(String value) => _box.put(_keyLastOverheatNotifiedDate, value);

  static const String _keyDopamineDetoxEnabled = 'dopamine_detox_enabled';
  static const String _keyDopamineDetoxUntil = 'dopamine_detox_until';

  bool get isDopamineDetoxEnabled => _box.get(_keyDopamineDetoxEnabled, defaultValue: false);
  set isDopamineDetoxEnabled(bool value) => _box.put(_keyDopamineDetoxEnabled, value);

  int get dopamineDetoxUntil => _box.get(_keyDopamineDetoxUntil, defaultValue: 0);
  set dopamineDetoxUntil(int value) => _box.put(_keyDopamineDetoxUntil, value);

  /// Checks if Dopamine Detox is currently active.
  bool get isDopamineDetoxActive =>
      isDopamineDetoxEnabled && dopamineDetoxUntil > DateTime.now().millisecondsSinceEpoch;

  static const String _keyFreezerLockedAmount = 'freezer_locked_amount';
  static const String _keyFreezerUnlockTime = 'freezer_unlock_time';
  static const String _keyFreezerItemName = 'freezer_item_name';
  static const String _keyFreezerDurationHours = 'freezer_duration_hours';

  /// Locked amount in minor units (kopecks)
  int get freezerLockedAmount => _box.get(_keyFreezerLockedAmount, defaultValue: 0);
  set freezerLockedAmount(int value) => _box.put(_keyFreezerLockedAmount, value);

  /// Millisecond timestamp of unlock time
  int get freezerUnlockTime => _box.get(_keyFreezerUnlockTime, defaultValue: 0);
  set freezerUnlockTime(int value) => _box.put(_keyFreezerUnlockTime, value);

  /// Target item name of the impulse buy
  String get freezerItemName => _box.get(_keyFreezerItemName, defaultValue: '');
  set freezerItemName(String value) => _box.put(_keyFreezerItemName, value);

  /// Choice of duration hours: 24 or 48
  int get freezerDurationHours => _box.get(_keyFreezerDurationHours, defaultValue: 24);
  set freezerDurationHours(int value) => _box.put(_keyFreezerDurationHours, value);

  // --- Time Merchant ---
  static const String _keyMerchantNextSpawnTime = 'merchant_next_spawn_time';
  static const String _keyMerchantSpawnDuration = 'merchant_spawn_duration';
  static const String _keyMerchantContractTarget = 'merchant_contract_target';
  static const String _keyMerchantContractReward = 'merchant_contract_reward';

  /// Timestamp in ms when the merchant should next spawn (or spawned)
  int get merchantNextSpawnTime => _box.get(_keyMerchantNextSpawnTime, defaultValue: 0);
  set merchantNextSpawnTime(int value) => _box.put(_keyMerchantNextSpawnTime, value);

  /// Duration in ms for how long the merchant stays
  int get merchantSpawnDuration => _box.get(_keyMerchantSpawnDuration, defaultValue: 0);
  set merchantSpawnDuration(int value) => _box.put(_keyMerchantSpawnDuration, value);

  /// The target deposit amount for the current contract
  int get merchantContractTargetAmount => _box.get(_keyMerchantContractTarget, defaultValue: 0);
  set merchantContractTargetAmount(int value) => _box.put(_keyMerchantContractTarget, value);

  /// The reward string/enum value for the current contract (e.g. 'x2_xp', 'lootbox')
  String get merchantContractReward => _box.get(_keyMerchantContractReward, defaultValue: '');
  set merchantContractReward(String value) => _box.put(_keyMerchantContractReward, value);

  // --- Flash Goal ---
  static const String _keyFlashGoalDate = 'flash_goal_date';
  static const String _keyFlashGoalTarget = 'flash_goal_target';
  static const String _keyFlashGoalCurrent = 'flash_goal_current';
  static const String _keyFlashGoalCompleted = 'flash_goal_completed';

  /// Date string (yyyy-MM-dd) when the goal was generated
  String get flashGoalDate => _box.get(_keyFlashGoalDate, defaultValue: '');
  set flashGoalDate(String value) => _box.put(_keyFlashGoalDate, value);

  /// Target amount in minor units (kopecks)
  int get flashGoalTargetAmount => _box.get(_keyFlashGoalTarget, defaultValue: 0);
  set flashGoalTargetAmount(int value) => _box.put(_keyFlashGoalTarget, value);

  /// Current progress in minor units (kopecks)
  int get flashGoalCurrentAmount => _box.get(_keyFlashGoalCurrent, defaultValue: 0);
  set flashGoalCurrentAmount(int value) => _box.put(_keyFlashGoalCurrent, value);

  /// Is the flash goal completed today
  bool get flashGoalIsCompleted => _box.get(_keyFlashGoalCompleted, defaultValue: false);
  set flashGoalIsCompleted(bool value) => _box.put(_keyFlashGoalCompleted, value);
}
