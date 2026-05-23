import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/settings_service.dart';
import 'providers.dart';

class LocaleNotifier extends StateNotifier<String> {
  final SettingsService _settingsService;

  LocaleNotifier(this._settingsService) : super(_settingsService.locale);

  void setLocale(String locale) {
    _settingsService.locale = locale;
    state = locale;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, String>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  return LocaleNotifier(settings);
});

class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'UA': {
      'settings_title': 'НАЛАШТУВАННЯ СИСТЕМИ',
      'settings_core': 'КОНФІГУРАЦІЯ ЯДРА',
      'settings_export': 'КАРТКА УСПІХУ (ЕКСПОРТ)',
      'settings_rank': 'РІВЕНЬ РАНГУ',
      'settings_streak': 'СЕРІЯ ДНІВ',
      'settings_share_btn': 'ПОДІЛИТИСЬ ДОСЯГНЕННЯМ',
      'settings_custom': 'КАСТОМІЗАЦІЯ',
      'settings_themes': 'ВЛАСНІ ТЕМИ І АВАТАРИ',
      'settings_skills': 'ДЕРЕВО НАВИЧОК (SP)',
      'settings_signals': 'НАЛАШТУВАННЯ ТА СИГНАЛИ',
      'settings_sound': 'Звукові ефекти',
      'settings_sound_sub': 'Супроводжувати накопичення аудіо-сигналами',
      'settings_haptic': 'Тактильний відгук',
      'settings_haptic_sub': 'Кібернетична вібрація при натисканні',
      'settings_reminder': 'Щоденний нагадувач',
      'settings_reminder_sub': 'Нагадувати про внесення коштів кожні 24 години',
      'settings_achievements': 'Сповіщення про досягнення',
      'settings_achievements_sub': 'Отримувати пуші при отриманні нового досягнення',
      'settings_security': 'БЕЗПЕКА ТА ПРИВАТНІСТЬ',
      'settings_privacy': 'Приватний режим',
      'settings_privacy_sub': 'Приховувати суми на головному екрані',
      'settings_biometric': 'Біометричний захист',
      'settings_biometric_sub': 'Вхід за допомогою Face ID / Touch ID',
      'settings_data': 'СИНХРОНІЗАЦІЯ ТА ДАНІ',
      'settings_cloud': 'Хмарне резервування',
      'settings_cloud_sub': 'Автоматично зберігати прогрес у хмарі',
      'settings_export_csv': 'ЕКСПОРТ ДАНИХ (CSV)',
      'settings_hard_reset': 'ВИДАЛИТИ ВСІ ДАНІ',
      'settings_others': 'ДОДАТКОВО',
      'settings_support': 'ДОПОМОГА ТА ПІДТРИМКА',
      'settings_rate': 'ОЦІНИТИ ДОДАТОК',
      'settings_policy': 'ПОЛІТИКА КОНФІДЕНЦІЙНОСТІ',
      'settings_currency': 'ВЛАСНА ВАЛЮТА',
      'settings_language': 'МОВА ІНТЕРФЕЙСУ',
      
      'dash_title': 'СКАРБНИЧКА МРІЇ',
      'dash_balance': 'Баланс Сейфу',
      'dash_add_goal': 'ДОДАТИ ЦІЛЬ',
      'dash_goals': 'ЦІЛІ НАКОПИЧЕННЯ',
      'dash_level': 'РІВЕНЬ',
      'dash_xp': 'ЕКСПА',
      'dash_vault': 'СЕЙФ',
      'dash_no_goals': 'Цілей поки немає. Додайте нову ціль!',
      'dash_market': 'РИНОК',
      'dash_spin': 'РУЛЕТКА',
      'dash_penalty': 'ШТРАФИ',
      'dash_squad': 'АЛЬЯНС',
      'dash_deposit': 'Укласти Транзакцію',
      'dash_streak_active': 'СТРІК АКТИВНИЙ:',
      'dash_streak_inactive': 'АКТИВНИЙ СТРІК ВІДСУТНІЙ',
      'dash_streak_tip_active': 'Здійснюй щоденні внески для розпалу полум\'я!',
      'dash_streak_tip_inactive': 'Зроби свій перший внесок сьогодні!',
      'dash_days': 'ДНІВ',
      
      // Bottom Navigation
      'nav_vault': 'Склад',
      'nav_analytics': 'Аналітика',
      'nav_history': 'Історія',
      'nav_streak': 'Стрік',
      'nav_trophies': 'Кубки',
      'nav_options': 'Опції',

      // Achievements
      'ach_header': 'ДОСЯГНЕННЯ ТА РАНГ',
      'ach_title': 'КІБЕР-ТРОФЕЇ',
      'ach_skill_tree': 'ДЕРЕВО НАВИЧОК',
      'ach_skill_desc': 'Витратіть SP на потужні пасивні навички та перки',
      'ach_unlocked': 'РОЗБЛОКОВАНО ТРОФЕЇВ',
      'ach_unlocked_desc': 'Збільшуйте суму накопичень для відкриття нових',
      'ach_locked': 'ЗАБЛОКОВАНО',
      
      // Streak / Flame Chamber
      'streak_header': 'ГАМІФІКАЦІЯ ТА СТАТУС',
      'streak_title': 'КАМЕРА ПОЛУМ\'Я',
      'streak_days': 'ДНІВ ПОСПІЛЬ',
      'streak_tokens': 'КРІОГЕННІ ТОКЕНИ',
      'streak_tokens_desc': 'Запобігають згасанню вогню при пропуску дня.',
      'streak_tokens_btn': 'КОДІВ',
      'streak_heatmap': 'КАРТА ТЕПЛОВОЇ АКТИВНОСТІ',
      'streak_heatmap_low': 'Слабкий',
      'streak_heatmap_high': 'Потужний',
    },
    'EN': {
      'settings_title': 'SYSTEM SETTINGS',
      'settings_core': 'CORE CONFIGURATION',
      'settings_export': 'SUCCESS CARD (EXPORT)',
      'settings_rank': 'RANK LEVEL',
      'settings_streak': 'DAY STREAK',
      'settings_share_btn': 'SHARE ACHIEVEMENT',
      'settings_custom': 'CUSTOMIZATION',
      'settings_themes': 'CUSTOM THEMES & AVATARS',
      'settings_skills': 'SKILL TREE (SP)',
      'settings_signals': 'SETTINGS & SIGNALS',
      'settings_sound': 'Sound Effects',
      'settings_sound_sub': 'Accompany savings with audio signals',
      'settings_haptic': 'Haptic Feedback',
      'settings_haptic_sub': 'Cybernetic vibration on tap',
      'settings_reminder': 'Daily Reminder',
      'settings_reminder_sub': 'Remind me to secure deposits every 24 hours',
      'settings_achievements': 'Achievement Notifications',
      'settings_achievements_sub': 'Receive push notifications for new achievements',
      'settings_security': 'SECURITY & PRIVACY',
      'settings_privacy': 'Privacy Mode',
      'settings_privacy_sub': 'Hide amounts on the main screen',
      'settings_biometric': 'Biometric Protection',
      'settings_biometric_sub': 'Login using Face ID / Touch ID',
      'settings_data': 'SYNC & DATA',
      'settings_cloud': 'Cloud Backup',
      'settings_cloud_sub': 'Automatically save progress to the cloud',
      'settings_export_csv': 'EXPORT DATA (CSV)',
      'settings_hard_reset': 'DELETE ALL DATA',
      'settings_others': 'ADDITIONAL',
      'settings_support': 'HELP & SUPPORT',
      'settings_rate': 'RATE THE APP',
      'settings_policy': 'PRIVACY POLICY',
      'settings_currency': 'CUSTOM CURRENCY',
      'settings_language': 'INTERFACE LANGUAGE',
      
      'dash_title': 'PIGGY VAULT',
      'dash_balance': 'Vault Balance',
      'dash_add_goal': 'ADD GOAL',
      'dash_goals': 'SAVINGS GOALS',
      'dash_level': 'LEVEL',
      'dash_xp': 'XP',
      'dash_vault': 'VAULT',
      'dash_no_goals': 'No goals yet. Add a new goal!',
      'dash_market': 'MARKET',
      'dash_spin': 'ROULETTE',
      'dash_penalty': 'PENALTIES',
      'dash_squad': 'ALLIANCE',
      'dash_deposit': 'Execute Transaction',
      'dash_streak_active': 'STREAK ACTIVE:',
      'dash_streak_inactive': 'NO ACTIVE STREAK',
      'dash_streak_tip_active': 'Make daily deposits to fuel the flame!',
      'dash_streak_tip_inactive': 'Make your first deposit today!',
      'dash_days': 'DAYS',
      
      // Bottom Navigation
      'nav_vault': 'Vault',
      'nav_analytics': 'Analytics',
      'nav_history': 'History',
      'nav_streak': 'Streak',
      'nav_trophies': 'Trophies',
      'nav_options': 'Options',

      // Achievements
      'ach_header': 'ACHIEVEMENTS & RANK',
      'ach_title': 'CYBER TROPHIES',
      'ach_skill_tree': 'SKILL TREE',
      'ach_skill_desc': 'Spend SP on powerful passive skills and perks',
      'ach_unlocked': 'UNLOCKED TROPHIES',
      'ach_unlocked_desc': 'Increase your savings to unlock new ones',
      'ach_locked': 'LOCKED',
      
      // Streak / Flame Chamber
      'streak_header': 'GAMIFICATION & STATUS',
      'streak_title': 'FLAME CHAMBER',
      'streak_days': 'DAYS IN A ROW',
      'streak_tokens': 'CRYOGENIC TOKENS',
      'streak_tokens_desc': 'Prevents the flame from dying if you miss a day.',
      'streak_tokens_btn': 'CODES',
      'streak_heatmap': 'THERMAL ACTIVITY MAP',
      'streak_heatmap_low': 'Weak',
      'streak_heatmap_high': 'Strong',
    }
  };

  static String get(String locale, String key) {
    if (!_localizedValues.containsKey(locale)) {
      return _localizedValues['UA']?[key] ?? key;
    }
    return _localizedValues[locale]?[key] ?? key;
  }
}
