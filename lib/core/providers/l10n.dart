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
      // =============================================
      // COMMON (shared across screens)
      // =============================================
      'common_cancel': 'СКАСУВАТИ',
      'common_delete': 'ВИДАЛИТИ',
      'common_confirm': 'ПІДТРИМАТИ',
      'common_back': 'Назад',
      'common_next': 'Далі',
      'common_continue': 'Продовжити',
      'common_close': 'ЗАКРИТИ',
      'common_save': 'ЗБЕРЕГТИ',
      'common_add': 'ДОДАТИ',
      'common_open': 'ВІДКРИТИ',
      'common_done': 'Готово',
      'common_loading': 'Завантаження...',
      'common_error': 'Помилка',
      'common_empty': 'Немає даних',
      'common_currency_uah': '₴',
      'common_active': 'Активний',
      'common_locked': 'Заблоковано',
      'common_yes': 'Так',
      'common_no': 'Ні',
      'common_all': 'Усі',
      'common_search': 'Пошук...',
      'common_select': 'ОБРАТИ',
      'common_in_dev': 'В розробці',
      'common_ok': 'ОК',
      'common_days_abbr': 'дн.',

      // =============================================
      // NAVIGATION
      // =============================================
      'nav_vault': 'Склад',
      'nav_home': 'Головна',
      'nav_analytics': 'Аналітика',
      'nav_history': 'Історія',
      'nav_streak': 'Стрік',
      'nav_trophies': 'Кубки',
      'nav_options': 'Опції',

      // =============================================
      // DASHBOARD
      // =============================================
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
      'dash_welcome': 'З поверненням 👋',
      'dash_profile_tooltip': 'Профіль',
      'dash_notifications_tooltip': 'Сповіщення',
      'dash_daily_quests': 'Щоденні квести',
      'dash_leaderboard': 'Лідерборд',
      'dash_class': 'Клас',
      'dash_active_penalties': 'Активні штрафи',
      'dash_penalties_detected':
          'Виявлено транзакції з чорного списку. Штрафи нараховано.',
      'dash_penalties_btn': 'Штрафи',
      'dash_quick_deposit_snack': 'Швидкий внесок: 50.00 ₴ успішно!',
      'dash_quick_deposit_error': 'Помилка при збереженні транзакції',
      'dash_goal_a': 'Ціль А',
      'dash_goal_b': 'Ціль Б',

      // =============================================
      // GOAL DETAIL
      // =============================================
      'goal_details': 'ДЕТАЛІ ЦІЛІ',
      'goal_transaction_history': 'ІСТОРІЯ ТРАНЗАКЦІЙ ЦІЛІ',
      'goal_accumulation_status': 'СТАТУС НАКОПИЧЕННЯ',
      'goal_accumulated': 'НАКОПИЧЕНО',
      'goal_remaining': 'ЗАЛИШИЛОСЬ',
      'goal_target': 'ФІНАНСОВА МІШЕНЬ',
      'goal_forecast_need_more': 'Потрібно більше транзакцій для прогнозу',
      'goal_forecast_pace': 'За поточного темпу ви досягнете цілі через',
      'goal_forecast_first': 'Внесіть перший вклад для прогнозу',
      'goal_analytic_projection': 'АНАЛІТИЧНИЙ ПРОГНОЗ ПОТОКУ',
      'goal_no_transactions': 'Жодних транзакцій ще не здійснено',
      'goal_deposit_note': 'Вклад у Скарбницю',
      'goal_price_scanner': 'СКАНЕР РИНКОВИХ ЦІН',
      'goal_price_check': 'Перевірити актуальні ціни на ринку',
      'goal_reversal_title': 'РЕВЕРСІЯ ТРАНЗАКЦІЇ',
      'goal_reversal_confirm':
          'Ви дійсно бажаєте анулювати цей вклад? Ця дія незворотна.',
      'goal_reversal_success': 'Вклад успішно анульовано!',
      'goal_not_found': 'Ціль не знайдено',
      'scan_market_prices': 'СКАНЕР РИНКОВИХ ЦІН',
      'price_not_found': 'Ціну не знайдено в пріоритетних магазинах',
      'price_actual': 'Ціна актуальна',
      'update_target_title': 'Оновити мішень?',
      'update_target_content': 'Знайдено ціну: {0} грн. Поточна мішень: {1} грн. Оновити?',
      'target_updated': 'Мішень успішно оновлено!',

      // =============================================
      // PRICE ANALYSIS
      // =============================================
      'price_enter_product': 'Введіть назву товару для аналізу',
      'price_fetch_error': 'Не вдалося отримати ціни: ',
      'price_scanner_header': 'СКАНЕР РИНКУ',
      'price_analysis_title': 'АНАЛІЗ ЦІНИ',
      'price_target_product': 'ЦІЛЬОВИЙ ТОВАР',
      'price_hint': 'Наприклад: PS5, монітор 27"',
      'price_quick_picks': 'Швидкі запити',
      'price_live_source': 'Актуальні ринкові ціни через SerpAPI',
      'price_live_badge': 'LIVE MARKET',
      'price_fallback_badge': 'DEMO ESTIMATE',
      'price_scan_btn': 'СКАНУВАТИ ЦІНИ',
      'price_range_header': 'ДІАПАЗОН ЦІН',
      'price_estimate': 'ОЦІНКА',
      'price_min': 'МІНІМУМ',
      'price_avg': 'СЕРЕДНЯ',
      'price_max': 'МАКСИМУМ',
      'price_spread': 'Розкид: ',
      'price_trend_title': 'Динаміка цін',
      'price_below_market': 'Ціль менша за ринкову ціну — чудова нагода!',
      'price_above_market': 'Ваша ціль вища за ринкову середню',
      'price_comparison': 'ПОРІВНЯННЯ З ЦІЛЛЮ',
      'price_by_store': 'ЦІНИ ПО МАГАЗИНАХ',
      'price_conclusion': 'ВИСНОВОК АНАЛІТИКА',

      // =============================================
      // GOAL COMPLETE
      // =============================================
      'goal_complete_title': 'ЦІЛЬ ДОСЯГНУТА!',
      'goal_complete_desc': 'Ви успішно накопичили повну суму. Вітаємо!',
      'goal_complete_bonus': 'БОНУС ЗОЛОТОГО СЕЙФУ',
      'goal_complete_bonus_desc': '+500 XP нараховано на ваш рахунок!',
      'goal_complete_back': 'ПОВЕРНУТИСЬ В СЕЙФ',

      // =============================================
      // DEPOSIT
      // =============================================
      'dep_note_manual': 'Ручний депозит з терміналу',
      'dep_save_error': 'Помилка при збереженні транзакції',
      'dep_step_vault': 'Внесок у сейф',
      'dep_step_split': 'Розподіл коштів',
      'dep_step_confirm': 'Підтвердження',
      'dep_load_error': 'Помилка завантаження: ',
      'dep_enter_amount': 'Введіть суму',
      'dep_continue_btn': 'Продовжити',
      'dep_split_title': 'Розподіл коштів',
      'dep_split_instruction': 'Перетягніть повзунок для розподілу внеску',
      'dep_goal_label': 'Ціль: ',
      'dep_set_split': 'Встановити розподіл',
      'dep_confirm_title': 'Підтвердження',
      'dep_confirm_subtitle': 'Перевірте проекцію впливу перед підтвердженням',
      'dep_progress_current': 'Поточний прогрес',
      'dep_progress_after': 'Після депозиту',
      'dep_confirm_btn': 'Затвердити транзакцію',
      'dep_undo_title': 'Обробка транзакції',
      'dep_undo_subtitle': 'Залишився час для скасування',
      'dep_undo_btn': 'Скасувати',
      'dep_success_title': 'Транзакція успішна',
      'dep_success_desc': 'кошти розподілено у ваші фонди',
      'dep_reward_critical': 'Критичний внесок!',
      'dep_reward_vault': 'Нагорода відсіку',
      'dep_reward_xp': 'Досвід XP',
      'dep_reward_streak': 'Серія',
      'dep_reward_crit_bonus': 'Бонус крита',
      'dep_reward_lootbox': 'Лутбокс',
      'dep_open_vault': 'Відкрити золотий сейф',
      'dep_return_btn': 'Повернутися',

      // =============================================
      // HISTORY
      // =============================================
      'hist_title': 'Історія транзакцій',
      'hist_subtitle': 'Усі ваші внески у одномісці',
      'hist_load_error': 'Помилка завантаження: ',
      'hist_empty_title': 'Транзакцій не знайдено',
      'hist_empty_desc': 'Зробіть свій перший внесок, щоб побачити історію',
      'hist_search_hint': 'Пошук за сумою...',
      'hist_filter_all': 'Усі',
      'hist_swipe_delete': 'Видалити',
      'hist_entry_label': 'Внесок #',
      'hist_cancel_dialog_title': 'Скасувати транзакцію?',
      'hist_cancel_dialog_desc': 'Ви дійсно бажаєте видалити цей запис?',
      'hist_detail_title': 'Деталі транзакції',
      'hist_detail_time': 'Час транзакції:',
      'hist_detail_status': 'Статус редагування:',
      'hist_status_active': 'Активний',
      'hist_status_locked': 'Заблоковано',

      // =============================================
      // ANALYTICS
      // =============================================
      'analytics_title': 'Аналітика',
      'analytics_subtitle': 'Прогрес та динаміка накопичень',
      'analytics_distribution': 'Розподіл накопичених коштів',
      'analytics_dynamics': 'Динаміка накопичень',
      'analytics_projection': 'Тижнева активність та прогноз',
      'analytics_weekly_sum': 'За 7 днів: ',
      'analytics_to_100': 'До 100%',

      // =============================================
      // SETTINGS (additions)
      // =============================================
      'settings_title': 'НАЛАШТУВАННЯ СИСТЕМИ',
      'settings_core': 'КОНФІГУРАЦІЯ ЯДРА',
      'settings_export': 'КАРТКА УСПІХУ (ЕКСПОРТ)',
      'settings_export_success': 'Картку успішно експортовано!',
      'settings_rank': 'РІВЕНЬ РАНГУ',
      'settings_rank_level': 'Рівень ',
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
      'settings_achievements_sub':
          'Отримувати пуші при отриманні нового досягнення',
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
      'settings_ai_personality': 'Особистість ШІ-помічника',
      'settings_ai_hint': 'Оберіть стиль',
      'settings_theme_section': 'Тема інтерфейсу',
      'settings_theme_light': 'Світла',
      'settings_theme_dark': 'Темна',
      'settings_theme_system': 'Системна',
      'settings_antigoals_section': 'Анти-цілі (авто-штрафи)',
      'settings_antigoals_btn': 'Керування чорним списком',
      'settings_debug_section': 'Налагодження',
      'settings_debug_bank': 'Банківська симуляція',
      'settings_debug_gen_tx': 'Згенерувати транзакцію',
      'settings_debug_gen_tx_success': 'Транзакцію згенеровано!',
      'settings_debug_clear_bank': 'Очистити історію банку',
      'settings_debug_events': 'Події',
      'settings_debug_gen_event': 'Згенерувати подію',
      'settings_debug_gen_event_success': 'Нову подію згенеровано!',
      'settings_debug_stop_event': 'Зупинити активну подію',
      'settings_debug_remote': 'Дистанційне керування',
      'settings_debug_remote_btn': 'Управління ПК',
      'settings_reset_word': 'ВИДАЛИТИ',
      'settings_reset_dialog_title': '⚠️ ВИДАЛЕННЯ ВСІХ ДАНИХ',
      'settings_reset_dialog_desc':
          'Ця дія НЕЗВОРОТНА. Всі цілі, транзакції, досягнення та налаштування буде видалено назавжди.',
      'settings_reset_dialog_instruction': 'Для підтвердження введіть слово:',
      'settings_reset_error': 'Помилка при видаленні: ',
      'settings_export_backup': 'ЕКСПОРТ БЕКАПУ',
      'settings_import_backup': 'ІМПОРТ БЕКАПУ',
      'settings_cloud_sub_off': 'Хмарне резервування вимкнено',
      'backup_exporting': 'Створення бекапу...',
      'backup_success': 'Бекап успішно створено!',
      'backup_share_title': 'PiggyVault Backup',
      'backup_error': 'Помилка при створенні бекапу: ',
      'backup_importing': 'Відновлення бекапу...',
      'backup_import_success': 'Бекап успішно відновлено!',
      'backup_import_error': 'Помилка при відновленні: ',
      'backup_import_invalid': 'Невірний формат файлу бекапу',
      'backup_import_confirm_title': 'Відновити бекап?',
      'backup_import_confirm_desc':
          'Поточні дані будуть ПЕРЕЗАПИСАНІ даними з файлу бекапу. Ця дія незворотна.',
      'backup_import_confirm_yes': 'Відновити',
      'backup_import_confirm_no': 'Скасувати',
      'csv_exporting': 'Генерація CSV...',
      'csv_success': 'CSV файл успішно створено!',
      'csv_error': 'Помилка експорту CSV: ',
      'csv_empty': 'Немає транзакцій для експорту',

      // =============================================
      // BIOMETRIC AUTH
      // =============================================
      'biometric_auth_title': 'Біометрична автентифікація',
      'biometric_auth_reason': 'Підтвердьте особу для доступу до PiggyVault',
      'biometric_success': 'Біометрію підтверджено',
      'biometric_failed': 'Помилка автентифікації',
      'biometric_unavailable': 'Біометрія недоступна на цьому пристрої',
      'biometric_disabled': 'Біометричний захист вимкнено',

      // =============================================
      // NOTIFICATIONS
      // =============================================
      'notif_title': 'СПОВІЩЕННЯ',
      'notif_empty': 'Немає нових сповіщень',
      'notif_mark_all': 'Позначити всі прочитаними',
      'notif_delete_all': 'Видалити всі',
      'notif_reminder_title': 'Час відкласти!',
      'notif_reminder_body':
          'Сьогодні ще не було вкладень. Зробіть внесок у Скарбничку!',
      'notif_streak_title': 'Стрік під загрозою!',
      'notif_streak_body': 'Зробіть вкладення до опівночі, щоб зберегти стрік.',
      'notif_achievement_title': 'Нове досягнення!',
      'notif_milestone_title': 'Milestone досягнуто!',
      'notif_levelup_title': 'Новий рівень!',
      'notif_levelup_body': 'Ви досягли рівня ',

      // =============================================
      // SOUND EFFECTS
      // =============================================
      'sound_deposit': 'deposit.mp3',
      'sound_achievement': 'achievement.mp3',
      'sound_lootbox': 'lootbox.mp3',

      // =============================================
      // DAILY SPIN
      // =============================================
      'spin_history_title': 'Історія спінів',
      'spin_today_done': 'Сьогодні вже обертали!',
      'spin_reward_xp': '+{amount} XP',
      'spin_reward_freeze': '+1 Жетон заморозки',
      'spin_reward_crystal': '+{amount} Кристалів',
      'spin_reward_badge': 'Нове досягнення!',

      // =============================================
      // PETS
      // =============================================
      'pet_feed_success': 'Вихованця нагодовано!',
      'pet_feed_cooldown': 'Спробуйте пізніше',
      'pet_levelup_title': 'Вихованець виріс!',
      'pet_levelup_body': 'Рівень {level}',
      'pet_happy': 'Щасливий',
      'pet_hungry': 'Голодний',
      'pet_sad': 'Сумний',

      // =============================================
      // LEADERBOARD
      // =============================================
      'lb_weekly': 'Тиждень',
      'lb_monthly': 'Місяць',
      'lb_alliance': 'Альянси',
      'lb_share': 'Поділитися',
      'lb_share_text': 'Я на {position} місці з {score} XP у PiggyVault!',
      'lb_online_soon': 'Онлайн-рейтинг — скоро',

      // =============================================
      // ONBOARDING
      // =============================================
      'onb_splash_tagline': 'Твоя скарбничка мрій',
      'onb_welcome_subtitle':
          'Твій персональний інструмент для\nнакопичення коштів',
      'onb_welcome_desc':
          'Відкладай на дві мрії одночасно, відстежуй прогрес і досягай фінансових цілей',
      'onb_start_btn': 'Розпочати',
      'onb_step_1_3': 'Крок 1 з 3',
      'onb_step_2_3': 'Крок 2 з 3',
      'onb_step_3_3': 'Крок 3 з 3',
      'onb_goal_a_title': 'Перша ціль',
      'onb_goal_b_title': 'Друга ціль',
      'onb_goal_a_desc': 'Налаштуй свою першу ціль накопичення',
      'onb_goal_b_desc': 'Налаштуй свою другу ціль накопичення',
      'onb_goal_card_header_a': 'Ціль А',
      'onb_goal_card_header_b': 'Ціль Б',
      'onb_goal_name_label': 'Назва цілі',
      'onb_goal_name_hint': 'Введіть назву цілі',
      'onb_goal_name_validator': 'Будь ласка, вкажіть назву цілі',
      'onb_goal_amount_label': 'Фінансова мета (UAH)',
      'onb_goal_amount_validator': 'Будь ласка, вкажіть суму',
      'onb_goal_amount_invalid': 'Введіть коректне позитивне число',
      'onb_finish_title': 'Фінальні налаштування',
      'onb_finish_desc': 'Обери валюту та розподіл внесків',
      'onb_finish_save_error': 'Помилка при збереженні: ',
      'onb_finish_currency': 'Валюта',
      'onb_finish_split': 'Розподіл внесків',
      'onb_finish_split_desc':
          'Кожен твій внесок буде автоматично розподілятися між цілями відповідно до обраного відсотка',
      'onb_finish_start_btn': 'Розпочати накопичувати',

      // =============================================
      // GAMIFICATION: ACHIEVEMENTS
      // =============================================
      'ach_header': 'ДОСЯГНЕННЯ ТА РАНГ',
      'ach_title': 'КІБЕР-ТРОФЕЇ',
      'ach_skill_tree': 'ДЕРЕВО НАВИЧОК',
      'ach_skill_desc': 'Витратіть SP на потужні пасивні навички та перки',
      'ach_unlocked': 'РОЗБЛОКОВАНО ТРОФЕЇВ',
      'ach_unlocked_desc': 'Збільшуйте суму накопичень для відкриття нових',
      'ach_locked': 'ЗАБЛОКОВАНО',

      // =============================================
      // GAMIFICATION: STREAK / FLAME CHAMBER
      // =============================================
      'streak_header': 'ГАМІФІКАЦІЯ ТА СТАТУС',
      'streak_title': 'КАМЕРА ПОЛУМ\'Я',
      'streak_days': 'ДНІВ ПОСПІЛЬ',
      'streak_tokens': 'КРІОГЕННІ ТОКЕНИ',
      'streak_tokens_desc': 'Запобігають згасанню вогню при пропуску дня.',
      'streak_tokens_btn': 'КОДІВ',
      'streak_heatmap': 'КАРТА ТЕПЛОВОЇ АКТИВНОСТІ',
      'streak_heatmap_low': 'Слабкий',
      'streak_heatmap_high': 'Потужний',

      // =============================================
      // GAMIFICATION: LEADERBOARD
      // =============================================
      'lb_title': 'ТАБЛИЦЯ ЛІДЕРІВ',
      'lb_in_dev': 'Лідерборд у розробці',

      // =============================================
      // GAMIFICATION: REGRET ARCHIVE
      // =============================================
      'regret_title': 'АРХІВ ЖАЛЮ',
      'regret_add_btn': 'ДОДАТИ НЕКУПЛЕНЕ',
      'regret_empty_title': 'ВАШ АРХІВ ПОРОЖНІЙ',
      'regret_empty_desc':
          'Тут зберігаються речі, від яких ви свідомо відмовились',
      'regret_empty_btn': 'ДОДАТИ ПЕРШИЙ ЗАПИС',
      'regret_total_saved': 'ВСЬОГО ВРЯТОВАНО',
      'regret_dialog_title': 'ДОДАТИ В АРХІВ',
      'regret_dialog_what': 'Що ви не купили?',
      'regret_dialog_price': 'Ціна (₴)',
      'regret_dialog_save': 'ЗБЕРЕГТИ',

      // =============================================
      // GAMIFICATION: PETS
      // =============================================
      'pet_no_sp': 'Недостатньо SP для годування (Потрібно 1 SP)!',
      'pet_title': 'КІБЕР-ПІТОМЦІ',
      'pet_happiness': 'ЩАСТЯ',
      'pet_feed_btn': 'НАГОДУВАТИ (1 SP)',
      'pet_empty_title': 'У ВАС НЕМАЄ ПІТОМЦЯ...',
      'pet_dragon': 'КІБЕР-ДРАКОН',
      'pet_dog': 'МЕХА-ПЕС',
      'pet_adopt_btn': 'ВЗЯТИ',
      'pet_core_temp': 'Реактор вихованця (Core Temp)',
      'pet_overheating_warning':
          'УВАГА: КРИТИЧНИЙ ПЕРЕГРІВ РЕАКТОРА! Здійсніть заощадження для охолодження.',
      'dopamine_detox_title': 'Дофаміновий детокс',
      'dopamine_detox_subtitle':
          'ДОФАМІНОВИЙ ДЕТОКС АКТИВНИЙ: Доступ до ринку та налаштувань аватара заблоковано. Зосередьтеся на накопиченні капіталу.',
      'settings_detox_mode': 'Дофаміновий детокс',
      'settings_detox_mode_sub':
          'Автоматично вимикає кольори додатку та блокує гейміфікацію при боргах або перегріві реактора.',
      'settings_detox_trigger': 'Почати 24г детокс',

      // =============================================
      // GAMIFICATION: BLACKLIST
      // =============================================
      'blacklist_title': 'АВТО-ШТРАФИ (BLACKLIST)',
      'blacklist_desc':
          'Якщо система виявить покупку з цих категорій — нарахується автоматичний штраф',
      'blacklist_active': 'АКТИВНИЙ БЛЕКЛІСТ',
      'blacklist_empty': 'Жодної категорії не додано. Натисніть "+" щоб додати',
      'blacklist_hint': 'Введіть назву категорії...',
      'blacklist_frequent': 'ЧАСТІ ПОРУШНИКИ:',
      'blacklist_cat_fastfood': 'Фастфуд',
      'blacklist_cat_games': 'Ігри',
      'blacklist_cat_coffee': 'Кава',
      'blacklist_cat_subs': 'Підписки',
      'blacklist_cat_shopping': 'Шопінг',
      'blacklist_cat_alcohol': 'Алкоголь',

      // =============================================
      // GAMIFICATION: SQUADS / JOINT GOALS
      // =============================================
      'squad_title': 'АЛЬЯНС / СПІЛЬНІ ЦІЛІ',
      'squad_new_btn': 'Нова спільна ціль',
      'squad_empty_title': 'НЕМАЄ СПІЛЬНИХ ЦІЛЕЙ',
      'squad_empty_desc':
          'Створіть спільну ціль з друзями для спільного накопичення',
      'squad_collected': 'Зібрано: ',
      'squad_members': 'Учасників: ',
      'joint_detail_together': 'СПІЛЬНО',
      'joint_detail_members': 'УЧАСНИКИ',
      'joint_detail_contribution': 'Внесок: ',
      'joint_detail_add_tooltip': 'Додати внесок',
      'joint_detail_dialog_title': 'Внесок від: ',
      'joint_detail_dialog_amount': 'Сума (₴)',

      // =============================================
      // GAMIFICATION: AVATAR BUILDER
      // =============================================
      'avatar_saved': 'Кібер-Аватар успішно збережено!',
      'avatar_title': 'RPG АВАТАР',
      'avatar_tab_chassis': 'КАРКАС',
      'avatar_tab_optics': 'ОПТИКА',
      'avatar_tab_neon': 'НЕОН',
      'avatar_tab_decals': 'ДЕКАЛІ',
      'avatar_save_btn': 'ЗБЕРЕГТИ КОНФІГУРАЦІЮ',
      'avatar_chassis_standard': 'Стандарт',
      'avatar_chassis_heavy': 'Важкий',
      'avatar_chassis_agile': 'Спритний',
      'avatar_visor_cyclops': 'Циклоп',
      'avatar_visor_split': 'Спліт',
      'avatar_visor_sniper': 'Снайпер',
      'avatar_visor_terminator': 'Термінатор',
      'avatar_color_cyan': 'Ціан',
      'avatar_color_magenta': 'Маджента',
      'avatar_color_gold': 'Золото',
      'avatar_color_fire': 'Вогонь',
      'avatar_color_toxin': 'Токсин',
      'avatar_color_clean': 'Чистота',
      'avatar_decal_none': 'Немає',
      'avatar_decal_stripes': 'Смуги',
      'avatar_decal_scar': 'Шрам',
      'avatar_decal_circuits': 'Схеми',
      'avatar_item_locked': 'Цей предмет заблоковано!',
      'avatar_color_level': 'Колір відкривається на рівні ',

      // =============================================
      // GAMIFICATION: PENALTY VAULT
      // =============================================
      'penalty_title': 'ШТРАФНИЙ ІЗОЛЯТОР',
      'penalty_damaged': '⚠️ СИСТЕМУ ПОШКОДЖЕНО ⚠️',
      'penalty_stable': 'СИСТЕМА СТАБІЛЬНА',
      'penalty_integrity': 'Цілісність: ',
      'penalty_active': 'АКТИВНІ КІБЕР-ШТРАФИ',
      'penalty_debt': 'Борг: ',
      'penalty_pay_btn': 'СПЛАТИТИ',
      'penalty_paid': 'Штраф сплачено. Цілісність відновлено!',
      'penalty_empty':
          'У вас немає активних штрафів. Система працює стабільно.',

      // =============================================
      // GAMIFICATION: LOOTBOX
      // =============================================
      'loot_opened_title': 'ЛУТБОКС ВІДКРИТО!',
      'loot_your_reward': 'Ваша нагорода:',
      'loot_awesome_btn': 'КРУТО!',
      'loot_title': 'ЛУТБОКСИ',
      'loot_empty': 'У вас немає закритих лутбоксів.',
      'loot_empty_hint': 'Робіть внески, щоб отримати шанс на дроп!',
      'loot_rarity_rare': 'РІДКІСНИЙ',
      'loot_rarity_common': 'ЗВИЧАЙНИЙ',
      'loot_open_btn': 'ВІДКРИТИ',
      'loot_opening': 'Відкриття лутбоксу...',

      // =============================================
      // GAMIFICATION: CLASS SELECTION
      // =============================================
      'class_changed': 'Клас успішно змінено!',
      'class_title': 'ВИБІР КЛАСУ',
      'class_warrior_name': 'ВОЇН (Warrior)',
      'class_warrior_desc':
          'Майстер щоденних депозитів. Бонуси за стрік та стабільність.',
      'class_mage_name': 'МАГ (Mage)',
      'class_mage_desc': 'Майстер цифр. Бонуси за аналітику та прогнози.',
      'class_rogue_name': 'РОЗБІЙНИК (Rogue)',
      'class_rogue_desc': 'Майстер заощаджень. Бонуси за скасування покупок.',
      'class_choose_btn': 'ОБРАТИ ЦЕЙ КЛАС',
      'class_current': 'ПОТОЧНИЙ КЛАС',

      // =============================================
      // GAMIFICATION: CUSTOMIZATION
      // =============================================
      'custom_theme_changed': 'Тему змінено на ',
      'custom_title': 'КАСТОМІЗАЦІЯ',
      'custom_colors': 'КОЛЬОРОВІ ТЕМИ',
      'custom_personal': 'ПЕРСОНАЛІЗАЦІЯ',
      'custom_avatar_link': 'RPG АВАТАР',
      'custom_avatar_desc': 'Налаштуйте вигляд вашого кібер-робота',
      'custom_locked': 'Блоковано: ',
      'custom_select_btn': 'ОБРАТИ',
      'custom_theme_neon': 'НЕОНОВИЙ КІБЕРПАНК (NEON)',
      'custom_theme_gold': 'ПРЕСТИЖНИЙ ЗОЛОТИЙ (GOLD)',
      'custom_theme_crimson': 'БАГРЯНИЙ ЖАХ (CRIMSON)',
      'custom_unlock_level_5': 'Досягніть 5-го рівня',
      'custom_unlock_level_10': 'Досягніть 10-го рівня',
      'custom_theme_saved': 'Тему змінено на {theme}!',

      // =============================================
      // GAMIFICATION: SKILL TREE
      // =============================================
      'skill_title': 'ДЕРЕВО НАВИЧОК',
      'skill_error': 'Помилка: ',
      'skill_req_level': 'Потрібно: ',
      'skill_req_text': 'Рівень ',
      'skill_name_hacker': 'Hacker',
      'skill_desc_hacker':
          'Майстер терміналу. Отримуйте ХР за використання CLI, розшифровку даних та Incognito Mode. Підвищує шанс критичного внеску.',
      'skill_name_magnate': 'Magnate',
      'skill_desc_magnate':
          'Фінансовий геній. Отримуйте ХР за великі депозити та системність. Дає множники ХР та знижки на Чорному Ринку.',
      'skill_name_resilience': 'Resilience',
      'skill_desc_resilience':
          'Незламний кібер-самурай. Отримуйте ХР за відновлення серії та сплату штрафів. Зменшує вартість штрафів.',
      'skill_locked_dep': 'Попередній вузол заблоковано.',
      'skill_ghost_desc': 'Відкриває секретні команди в терміналі.',
      'skill_crit_title': 'Критичний Обхід',
      'skill_crit_desc': '+10% до шансу критичного внеску (25% → 35%).',
      'skill_dividends_title': 'Дивіденди XP',
      'skill_dividends_desc': '+5% XP за кожен внесок.',
      'skill_trade_title': 'Торгова Хитрість',
      'skill_trade_desc': 'Знижки на всі товари Чорного Ринку.',
      'skill_shield_title': 'Щит Серії',
      'skill_shield_desc':
          'Авто-захист при пропуску 1 дня (не витрачає Freeze Token).',
      'skill_iron_title': 'Залізний Кордон',
      'skill_iron_desc': 'Вартість штрафів знижена на 15%.',

      // =============================================
      // GAMIFICATION: MARKET
      // =============================================
      'market_no_credits': 'Недостатньо Кібер-Кредитів!',
      'market_purchased': 'Придбано: ',
      'market_title': 'ЧОРНИЙ РИНОК',
      'market_sp': 'SKILL POINTS',
      'market_cr': 'КІБЕР-КРЕДИТИ',
      'market_tab_boosters': 'БУСТЕРИ (SP)',
      'market_tab_cosmetics': 'КОСМЕТИКА (CR)',
      'market_streak_freeze': 'ЗАМОРОЖЕННЯ СТРІКУ',
      'market_streak_freeze_desc': 'Захищає стрік від згасання на 1 день',
      'market_common_lootbox': 'ЗВИЧАЙНИЙ ЛУТБОКС',
      'market_common_lootbox_desc': 'Містить випадкову нагороду',
      'market_integration_soon':
          'В розробці: Будуть інтегровані реальні нагороди',
      'market_exclusive_optics': 'ЕКСКЛЮЗИВНА ОПТИКА',
      'market_terminator': 'Термінатор',
      'market_terminator_desc': 'Червоне кібер-око',
      'market_premium_paints': 'ПРЕМІУМ ФАРБИ',
      'market_decals_scars': 'ДЕКАЛІ ТА ШРАМИ',
      'market_purchased_badge': 'ПРИДБАНО',
      'market_purchased_success':
          'Придбано: {name}! Тепер він доступний у конструкторі.',
      'market_item_holo_desc': 'Голографічна смуга',
      'market_item_quantum_desc': 'Абсолютний неон',
      'market_item_gold_desc': 'Сяйво еліти',
      'market_item_circuit_desc': 'Електронні доріжки',

      // =============================================
      // GAMIFICATION: DAILY BONUS
      // =============================================
      'daily_bonus_title': 'ЩОДЕННА ВИНАГОРОДА',
      'daily_bonus_streak': '🔥 Стрік: ',
      'daily_bonus_days': ' днів',
      'daily_bonus_claimed': 'Отримано!',
      'daily_bonus_claim_btn': 'Забрати',

      // =============================================
      // GAMIFICATION: DAILY SPIN
      // =============================================
      'spin_already': 'Ви вже крутили рулетку сьогодні!',
      'spin_title': 'ЩОДЕННА РУЛЕТКА',
      'spin_result': 'ВАШ ПРИЗ:',
      'spin_spin_btn': 'КРУТИТИ!',
      'spin_spinning': 'КРУТИТЬСЯ...',
      'spin_close_btn': 'ЗАКРИТИ',

      // =============================================
      // GAMIFICATION: CREATE JOINT GOAL
      // =============================================
      'joint_create_title': 'НОВА СПІЛЬНА ЦІЛЬ',
      'joint_create_name_label': 'Назва цілі (Напр. ПС5)',
      'joint_create_amount_label': 'Сума (₴)',
      'joint_create_members': 'Учасники (Віртуальні/Офлайн)',
      'joint_create_name_hint': 'Ім\'я друга',
      'joint_create_btn': 'СТВОРИТИ',

      // =============================================
      // GAMIFICATION: SHIELD ACTIVATION
      // =============================================
      'shield_title': 'Стрік Врятовано!',
      'shield_desc':
          'Ваш Shield (кріо-токен) автоматично захистив вашу серію від згасання!',
      'shield_used': 'Використано Shield: ',
      'shield_unit': ' шт.',
      'shield_btn': 'Супер!',

      // --- Price Hunter ---
      'price_hunter_title': 'Охотник за цінами',
      'price_hunter_setup_btn': 'ВІДСТЕЖУВАТИ ЦІНУ',
      'price_hunter_update_btn': 'ОНОВИТИ ЦІНУ',
      'price_hunter_shield': 'ЩИТ БОСА',
      'price_hunter_target': 'ЦІЛЬОВА',
      'price_hunter_current': 'ПОТОЧНА',
      'price_hunter_critical': 'КРИТИЧНИЙ УДАР!',
      'price_hunter_cooldown': 'Сканер перезаряджається. Спробуйте пізніше.',
      'price_hunter_dialog_title': 'Відстежувати товар',
      'price_hunter_dialog_desc': 'Введіть посилання на товар та його поточну ціну. Якщо ціна впаде, бос отримає урон!',
      'price_hunter_dialog_url': 'URL товару',
      'price_hunter_dialog_price': 'Поточна ціна',

      // --- Cyber Partner ---
      'partner_card_title': 'Кібер-Напарник',
      'partner_status_online': '✅ Напарник активний!',
      'partner_status_offline': '⏳ Очікує на твій депозит...',
      'partner_empty_title': 'Напарник не знайдений',
      'partner_empty_desc': 'Запроси союзника, щоб отримувати подвійний XP!',
      'partner_btn_add': 'ДОДАТИ НАПАРНИКА',
      'partner_btn_change': 'Змінити напарника',
      'partner_quest_title': 'Подвійний удар',
      'partner_quest_desc': 'Обидва зробили депозит цього тижня',
      'partner_dialog_title': 'Знайди Кібер-Напарника!',
      'partner_dialog_desc': 'Спільні депозити = подвійний XP та бонусні лутбокси. Введіть ім\'я напарника, щоб об\'єднатися.',
      'partner_dialog_input': 'Ім\'я напарника',
      'partner_saved_quest': 'Ти врятував спільний квест! Напарник вдячний!',

      // =============================================
      // BANKING INSIGHTS
      // =============================================
      'bank_analyzing': 'VAULT-7 аналізує транзакцію...',
      'bank_transferred': '✅ Переказано у Сховище!',
      'bank_ignored': 'Проігноровано пораду VAULT-17',
      'bank_remembered': '⚠️ VAULT-17 запам\'ятав це порушення',
      'bank_deposit_btn': 'ВНЕСТИ',

      // =============================================
      // REMOTE CONTROL
      // =============================================
      'remote_title': 'КІБЕР-УПРАВЛІННЯ ПК',
      'remote_mode_direct': 'Режим: Прямий Клік',
      'remote_mode_trackpad': 'Режим: Трекпад',
      'remote_latency': 'Виміряти затримку',
      'remote_disconnect': 'Відключитися',
      'remote_desc':
          'Встановіть з\'єднання з хост-сервером для віддаленого управління',
      'remote_ip_label': 'IP АДРЕСА ПК',
      'remote_port_label': 'ПОРТ WebSocket',
      'remote_pin_label': 'КІБЕР-ПАРОЛЬ (PIN)',
      'remote_pin_hint': 'Введіть пароль від сервера',
      'remote_connect_btn': 'ВСТАНОВИТИ З\'ЄДНАННЯ',
      'remote_connected': 'З\'ЄДНАНО',
      'remote_ping': 'ПІНГ: ',
      'remote_ping_ms': 'мс',
      'remote_quality': 'ЯКІСТЬ: ',
      'remote_streaming': 'Очікування потоку екрану...',
      'remote_scroll_down': 'Скрол Вниз',
      'remote_scroll_up': 'Скрол Вгору',
      'remote_text_btn': 'ТЕКСТ',
      'remote_text_dialog_title': 'ВВЕДЕННЯ ТЕКСТУ НА ПК',
      'remote_text_dialog_desc':
          'Введений нижче текст буде послідовно надіслано на віддалений ПК',
      'remote_text_hint': 'Введіть текст...',
      'remote_send_btn': 'НАДІСЛАТИ',

      // =============================================
      // FEAT-01: SAVINGS CALCULATOR
      // =============================================
      'calc_title': 'Калькулятор накопичень',
      'calc_target_amount': 'Цільова сума',
      'calc_target_hint': 'Введіть суму (грн)',
      'calc_term': 'Термін',
      'calc_days': 'днів',
      'calc_weeks': 'тижнів',
      'calc_months': 'місяців',
      'calc_per_day': 'На день',
      'calc_per_week': 'На тиждень',
      'calc_per_month': 'На місяць',
      'calc_result': 'Потрібно відкладати',
      'calc_empty': 'Введіть цільову суму та термін',

      // =============================================
      // FEAT-04: WEEKLY CHALLENGES
      // =============================================
      'challenge_title': 'Щотижневі челенджі',
      'challenge_new': 'Новий челендж',
      'challenge_edit': 'Редагувати',
      'challenge_name': 'Назва',
      'challenge_name_hint': 'Наприклад: Відкласти 500 грн',
      'challenge_target': 'Цільова сума',
      'challenge_deadline': 'Дедлайн',
      'challenge_create': 'Створити',
      'challenge_active': 'Активні',
      'challenge_done': 'Виконані',
      'challenge_expired': 'Прострочені',
      'challenge_empty': 'Поки немає челенджів',

      // =============================================
      // FEAT-06: PENALTY / AVOIDED STATS
      // =============================================
      'stats_title': 'Статистика заощаджень',
      'stats_penalties': 'Штрафи (habits)',
      'stats_avoided': 'Зекономлено',
      'stats_top_penalties': 'Топ-5 звичок-штрафів',
      'stats_weekly_trend': 'Тижневий тренд заощаджень',

      // =============================================
      // FEAT-07: FINANCIAL HEALTH THERMOMETER
      // =============================================
      'health_title': 'Температура фінансового здоров\'я',
      'health_streak': 'Стрік',
      'health_goals': 'Цілі',
      'health_avoided': 'Зекономлене',

      // =============================================
      // FEAT-08: GOAL TEMPLATES
      // =============================================
      'template_title': 'Шаблони цілей',
      'template_subtitle': 'Оберіть шаблон або введіть вручну',
      'template_btn': 'Обрати шаблон',
      'template_months_short': 'міс',

      // =============================================
      // FEAT-14: PER-GOAL CURRENCY
      // =============================================
      'onb_currency_label': 'Валюта',

      // =============================================
      // CSV IMPORT
      // =============================================
      'csv_import': 'Імпорт CSV',
      'csv_import_success': 'Імпортовано: {count} транзакцій',
      'csv_import_error': 'Помилка імпорту',
      'csv_import_invalid':
          'Невірний формат CSV. Очікуються колонки: date, amount',

      // =============================================
      // IMPULSE FREEZER (UA)
      // =============================================
      'freezer_title': 'КРІО-ЗАМОРОЖУВАЧ',
      'freezer_desc': 'Заморожуйте імпульсивні фінансові бажання та перевіряйте їх після охолодження.',
      'freezer_locked': 'ІМПУЛЬС ЗАМОРОЖЕНО',
      'freezer_unfreeze_save': 'КРІО-СЕЙВ (+150 XP)',
      'freezer_unfreeze_buy': 'ЗЛАМАТИ & КУПИТИ',
      'freezer_duration': 'Тривалість',
      'freezer_duration_24': '24 Години',
      'freezer_duration_48': '48 Годин',
      'freezer_item_name': 'Назва бажання',
      'freezer_item_name_hint': 'Наприклад: Механічна клавіатура',
      'freezer_item_name_validator': 'Будь ласка, введіть назву',
      'freezer_amount': 'Сума (₴)',
      'freezer_amount_hint': 'Сума для заморозки',
      'freezer_amount_validator': 'Будь ласка, введіть суму',
      'freezer_freeze_btn': 'ЗАПУСТИТИ КРІО-ЗАМОРОЖКУ',
      'freezer_hours': 'год.',
      'freezer_active_badge': 'КРІО-ЩИТ АКТИВНИЙ',
      'freezer_saved_toast': 'Перемога сили волі! Кошти збережено у сейф!',
      'freezer_bought_toast': 'Кріо-щит зламано. Товар куплено.',
      'freezer_debug_fast_forward': '⚡ ШВИДКИЙ ПЕРЕМОТ (DEBUG)',

      // =============================================
      // NO-SPEND STREAK (UA)
      // =============================================
      'no_spend_title': '🛡️ ЧЕЛЛЕНДЖ «НУЛЬОВІ ВИТРАТИ»',
      'no_spend_subtitle': 'Не витрачай зайвого — отримуй нагороди!',
      'no_spend_claim_btn': 'Сьогодні я не витрачав зайвого',
      'no_spend_claimed': '✅ Вже зафіксовано сьогодні',
      'no_spend_streak_label': '🛡️ Серія без витрат',
      'no_spend_days': ' дн.',
      'no_spend_chest_progress': 'До наступного ящика:',
      'no_spend_success_title': '🛡️ ДЕНЬ БЕЗ ВИТРАТ!',
      'no_spend_success_reward': '+15 Кібер-Кредитів',
      'no_spend_success_streak': 'Серія:',
      'no_spend_success_progress': 'Прогрес до скрині:',
      'no_spend_lootbox_title': '🎁 НАГОРОДА 7-ДЕННОЇ СЕРІЇ!',
      'no_spend_lootbox_desc': 'Ви отримали ЛУТБОКС за 7-денну серію без витрат!',
      'no_spend_debug_btn': '⚡ DEBUG: +1 день (тест)',

      // =============================================
      // KARMA DEBT (UA)
      // =============================================
      'karma_title': '👾 КАРМА-БОРГ',
      'karma_subtitle': 'Активний дебафф: -20% XP',
      'karma_debuff_hours': 'Дебафф активний ще {hours} год.',
      'karma_debuff_desc': 'Систему скомпрометовано! Накопичено карма-борг через зайві витрати. Виконуйте щоденні квести очищення для відновлення пета.',
      'karma_cleanse_btn': '🔮 Очистити Карму (-25 боргу)',
      'karma_report_btn': '💥 Я сорвався / Зайва витрата',
      'karma_report_dialog_title': '💥 Зафіксувати срив',
      'karma_report_dialog_desc': 'Чесність — перший крок до виправлення. Введіть суму витрат (необов’язково) для фіксації.',
      'report_amount_label': 'Сума зриву (₴)',
      'report_confirm': 'ПІДТВЕРДИТИ ЗРИВ',
      'karma_compromised_toast': '👾 Карма-Борг атаковав! Твій кібер-пет отримав дебафф -20% XP на 48 годин!',
      'karma_cleansed_toast': '🔮 Карма очищена! Залишилося боргу: {amount}',
      'karma_healed_toast': '✨ Кібер-Пет повністю вилікуваний! Дебафф знято!',
      'karma_quest_title': 'Heal Karma-Borg (Вилікувати Карма-Борга)',

      // =============================================
      // PRICE HUNTER
      // =============================================
      'ph_title': '🎯 Охотник за цінами',
      'ph_track_btn': 'ВІДСТЕЖУВАТИ ЦІНУ',
      'ph_update_btn': 'ОНОВИТИ ЦІНУ',
      'ph_url_label': 'Посилання на товар',
      'ph_initial_price_label': 'Початкова ціна (₴)',
      'ph_current_price_label': 'Поточна ціна (₴)',
      'ph_new_price_label': 'Нова ціна (₴)',
      'ph_cooldown_msg': 'Ціну можна оновлювати не частіше 1 разу на годину.',
      'ph_critical_hit': 'КРИТИЧНИЙ УДАР!',
      'ph_critical_desc': 'Щит ціни знищено! Бос вразливий. +50 XP',
      'ph_boss_vulnerable': '⚡ БОС УРАЗЛИВИЙ! Ціна впала!',

      // =============================================
      // STREAK SHIELD
      // =============================================
      'streak_shield_activated': 'Щит активовано! (-50 CRYSH)',
      'streak_shield_error': 'Недостатньо CRYSH (потрібно 50)',
      'flash_goal_title': 'Щоденна Мікро-Ціль',
      'flash_goal_desc': 'Відклади %s ₴ до опівночі',
      'flash_goal_completed': '✅ Виконано! +30 XP',
    },
    'EN': {
      // =============================================
      // COMMON
      // =============================================
      'common_cancel': 'CANCEL',
      'common_delete': 'DELETE',
      'common_confirm': 'CONFIRM',
      'common_back': 'Back',
      'common_next': 'Next',
      'common_continue': 'Continue',
      'common_close': 'CLOSE',
      'common_save': 'SAVE',
      'common_add': 'ADD',
      'common_open': 'OPEN',
      'common_done': 'Done',
      'common_loading': 'Loading...',
      'common_error': 'Error',
      'common_empty': 'No data',
      'common_currency_uah': '₴',
      'common_active': 'Active',
      'common_locked': 'Locked',
      'common_yes': 'Yes',
      'common_no': 'No',
      'common_all': 'All',
      'common_search': 'Search...',
      'common_select': 'SELECT',
      'common_in_dev': 'In development',
      'common_ok': 'OK',
      'common_days_abbr': 'd',

      // =============================================
      // NAVIGATION
      // =============================================
      'nav_vault': 'Vault',
      'nav_home': 'Home',
      'nav_analytics': 'Analytics',
      'nav_history': 'History',
      'nav_streak': 'Streak',
      'nav_trophies': 'Trophies',
      'nav_options': 'Options',

      // =============================================
      // DASHBOARD
      // =============================================
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
      'dash_welcome': 'Welcome back 👋',
      'dash_profile_tooltip': 'Profile',
      'dash_notifications_tooltip': 'Notifications',
      'dash_daily_quests': 'Daily Quests',
      'dash_leaderboard': 'Leaderboard',
      'dash_class': 'Class',
      'dash_active_penalties': 'Active Penalties',
      'dash_penalties_detected':
          'Blacklist transactions detected. Penalties applied.',
      'dash_penalties_btn': 'Penalties',
      'dash_quick_deposit_snack': 'Quick deposit: 50.00 ₴ successful!',
      'dash_quick_deposit_error': 'Error saving transaction',
      'dash_goal_a': 'Goal A',
      'dash_goal_b': 'Goal B',

      // =============================================
      // GOAL DETAIL
      // =============================================
      'goal_details': 'GOAL DETAILS',
      'goal_transaction_history': 'GOAL TRANSACTION HISTORY',
      'goal_accumulation_status': 'ACCUMULATION STATUS',
      'goal_accumulated': 'ACCUMULATED',
      'goal_remaining': 'REMAINING',
      'goal_target': 'FINANCIAL TARGET',
      'goal_forecast_need_more': 'More transactions needed for forecast',
      'goal_forecast_pace': 'At current pace you will reach your goal in',
      'goal_forecast_first': 'Make your first deposit for a forecast',
      'goal_analytic_projection': 'ANALYTIC FLOW PROJECTION',
      'goal_no_transactions': 'No transactions have been made yet',
      'goal_deposit_note': 'Vault Deposit',
      'goal_price_scanner': 'MARKET PRICE SCANNER',
      'goal_price_check': 'Check current market prices',
      'goal_reversal_title': 'TRANSACTION REVERSAL',
      'goal_reversal_confirm':
          'Are you sure you want to reverse this deposit? This action is irreversible.',
      'goal_reversal_success': 'Deposit successfully reversed!',
      'goal_not_found': 'Goal not found',
      'scan_market_prices': 'MARKET PRICE SCANNER',
      'price_not_found': 'Price not found in priority stores',
      'price_actual': 'Price is actual',
      'update_target_title': 'Update target?',
      'update_target_content': 'Price found: {0} ₴. Current target: {1} ₴. Update target?',
      'target_updated': 'Target updated successfully!',

      // =============================================
      // PRICE ANALYSIS
      // =============================================
      'price_enter_product': 'Enter product name for analysis',
      'price_fetch_error': 'Failed to fetch prices: ',
      'price_scanner_header': 'MARKET SCANNER',
      'price_analysis_title': 'PRICE ANALYSIS',
      'price_target_product': 'TARGET PRODUCT',
      'price_hint': 'e.g. PS5, monitor 27"',
      'price_quick_picks': 'Quick picks',
      'price_live_source': 'Live market prices via SerpAPI',
      'price_live_badge': 'LIVE MARKET',
      'price_fallback_badge': 'DEMO ESTIMATE',
      'price_scan_btn': 'SCAN PRICES',
      'price_range_header': 'PRICE RANGE',
      'price_estimate': 'ESTIMATE',
      'price_min': 'MINIMUM',
      'price_avg': 'AVERAGE',
      'price_max': 'MAXIMUM',
      'price_spread': 'Spread: ',
      'price_trend_title': 'Price trend',
      'price_below_market': 'Target is below market price — great opportunity!',
      'price_above_market': 'Your target is above market average',
      'price_comparison': 'COMPARISON WITH TARGET',
      'price_by_store': 'PRICES BY STORE',
      'price_conclusion': 'ANALYST CONCLUSION',

      // =============================================
      // GOAL COMPLETE
      // =============================================
      'goal_complete_title': 'GOAL ACHIEVED!',
      'goal_complete_desc':
          'You have successfully saved the full amount. Congratulations!',
      'goal_complete_bonus': 'GOLDEN VAULT BONUS',
      'goal_complete_bonus_desc': '+500 XP added to your account!',
      'goal_complete_back': 'RETURN TO VAULT',

      // =============================================
      // DEPOSIT
      // =============================================
      'dep_note_manual': 'Manual deposit from terminal',
      'dep_save_error': 'Error saving transaction',
      'dep_step_vault': 'Vault Deposit',
      'dep_step_split': 'Fund Split',
      'dep_step_confirm': 'Confirmation',
      'dep_load_error': 'Loading error: ',
      'dep_enter_amount': 'Enter amount',
      'dep_continue_btn': 'Continue',
      'dep_split_title': 'Fund Split',
      'dep_split_instruction': 'Drag the slider to distribute your deposit',
      'dep_goal_label': 'Goal: ',
      'dep_set_split': 'Set distribution',
      'dep_confirm_title': 'Confirmation',
      'dep_confirm_subtitle': 'Review the impact projection before confirming',
      'dep_progress_current': 'Current progress',
      'dep_progress_after': 'After deposit',
      'dep_confirm_btn': 'Confirm transaction',
      'dep_undo_title': 'Processing transaction',
      'dep_undo_subtitle': 'Time remaining to cancel',
      'dep_undo_btn': 'Cancel',
      'dep_success_title': 'Transaction successful',
      'dep_success_desc': 'funds distributed to your vaults',
      'dep_reward_critical': 'Critical deposit!',
      'dep_reward_vault': 'Vault reward',
      'dep_reward_xp': 'Experience XP',
      'dep_reward_streak': 'Streak',
      'dep_reward_crit_bonus': 'Crit bonus',
      'dep_reward_lootbox': 'Lootbox',
      'dep_open_vault': 'Open golden vault',
      'dep_return_btn': 'Return',

      // =============================================
      // HISTORY
      // =============================================
      'hist_title': 'Transaction History',
      'hist_subtitle': 'All your deposits in one place',
      'hist_load_error': 'Loading error: ',
      'hist_empty_title': 'No transactions found',
      'hist_empty_desc': 'Make your first deposit to see the history',
      'hist_search_hint': 'Search by amount...',
      'hist_filter_all': 'All',
      'hist_swipe_delete': 'Delete',
      'hist_entry_label': 'Deposit #',
      'hist_cancel_dialog_title': 'Cancel transaction?',
      'hist_cancel_dialog_desc': 'Are you sure you want to delete this record?',
      'hist_detail_title': 'Transaction Details',
      'hist_detail_time': 'Transaction time:',
      'hist_detail_status': 'Edit status:',
      'hist_status_active': 'Active',
      'hist_status_locked': 'Locked',

      // =============================================
      // ANALYTICS
      // =============================================
      'analytics_title': 'Analytics',
      'analytics_subtitle': 'Progress and savings dynamics',
      'analytics_distribution': 'Savings Distribution',
      'analytics_dynamics': 'Savings Dynamics',
      'analytics_projection': 'Weekly activity and forecast',
      'analytics_weekly_sum': 'Last 7 days: ',
      'analytics_to_100': 'To 100%',

      // =============================================
      // SETTINGS (additions)
      // =============================================
      'settings_title': 'SYSTEM SETTINGS',
      'settings_core': 'CORE CONFIGURATION',
      'settings_export': 'SUCCESS CARD (EXPORT)',
      'settings_export_success': 'Card exported successfully!',
      'settings_rank': 'RANK LEVEL',
      'settings_rank_level': 'Level ',
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
      'settings_achievements_sub':
          'Receive push notifications for new achievements',
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
      'settings_ai_personality': 'AI Assistant Personality',
      'settings_ai_hint': 'Choose a style',
      'settings_theme_section': 'Interface Theme',
      'settings_theme_light': 'Light',
      'settings_theme_dark': 'Dark',
      'settings_theme_system': 'System',
      'settings_antigoals_section': 'Anti-goals (auto-penalties)',
      'settings_antigoals_btn': 'Manage blacklist',
      'settings_debug_section': 'Debugging',
      'settings_debug_bank': 'Banking Simulation',
      'settings_debug_gen_tx': 'Generate transaction',
      'settings_debug_gen_tx_success': 'Transaction generated!',
      'settings_debug_clear_bank': 'Clear bank history',
      'settings_debug_events': 'Events',
      'settings_debug_gen_event': 'Generate event',
      'settings_debug_gen_event_success': 'New event generated!',
      'settings_debug_stop_event': 'Stop active event',
      'settings_debug_remote': 'Remote Control',
      'settings_debug_remote_btn': 'PC Control',
      'settings_reset_word': 'DELETE',
      'settings_reset_dialog_title': '⚠️ DELETE ALL DATA',
      'settings_reset_dialog_desc':
          'This action is IRREVERSIBLE. All goals, transactions, achievements and settings will be permanently deleted.',
      'settings_reset_dialog_instruction': 'Type the word to confirm:',
      'settings_reset_error': 'Error deleting: ',
      'settings_export_backup': 'EXPORT BACKUP',
      'settings_import_backup': 'IMPORT BACKUP',
      'settings_cloud_sub_off': 'Cloud backup is disabled',
      'backup_exporting': 'Creating backup...',
      'backup_success': 'Backup created successfully!',
      'backup_share_title': 'PiggyVault Backup',
      'backup_error': 'Backup error: ',
      'backup_importing': 'Restoring backup...',
      'backup_import_success': 'Backup restored successfully!',
      'backup_import_error': 'Restore error: ',
      'backup_import_invalid': 'Invalid backup file format',
      'backup_import_confirm_title': 'Restore Backup?',
      'backup_import_confirm_desc':
          'Current data will be OVERWRITTEN with the backup file data. This action cannot be undone.',
      'backup_import_confirm_yes': 'Restore',
      'backup_import_confirm_no': 'Cancel',
      'csv_exporting': 'Generating CSV...',
      'csv_success': 'CSV file created successfully!',
      'csv_error': 'CSV export error: ',
      'csv_empty': 'No transactions to export',

      // =============================================
      // BIOMETRIC AUTH
      // =============================================
      'biometric_auth_title': 'Biometric Authentication',
      'biometric_auth_reason': 'Verify your identity to access PiggyVault',
      'biometric_success': 'Biometric authenticated',
      'biometric_failed': 'Authentication failed',
      'biometric_unavailable': 'Biometrics not available on this device',
      'biometric_disabled': 'Biometric protection disabled',

      // =============================================
      // NOTIFICATIONS
      // =============================================
      'notif_title': 'NOTIFICATIONS',
      'notif_empty': 'No new notifications',
      'notif_mark_all': 'Mark all as read',
      'notif_delete_all': 'Delete all',
      'notif_reminder_title': 'Time to save!',
      'notif_reminder_body':
          "You haven't made a deposit today. Add to your PiggyVault!",
      'notif_streak_title': 'Streak at risk!',
      'notif_streak_body':
          'Make a deposit before midnight to keep your streak.',
      'notif_achievement_title': 'New achievement!',
      'notif_milestone_title': 'Milestone reached!',
      'notif_levelup_title': 'Level up!',
      'notif_levelup_body': 'You reached level ',

      // =============================================
      // SOUND EFFECTS
      // =============================================
      'sound_deposit': 'deposit.mp3',
      'sound_achievement': 'achievement.mp3',
      'sound_lootbox': 'lootbox.mp3',

      // =============================================
      // DAILY SPIN
      // =============================================
      'spin_history_title': 'Spin History',
      'spin_today_done': 'Already spun today!',
      'spin_reward_xp': '+{amount} XP',
      'spin_reward_freeze': '+1 Freeze Token',
      'spin_reward_crystal': '+{amount} Crystals',
      'spin_reward_badge': 'New achievement!',

      // =============================================
      // PETS
      // =============================================
      'pet_feed_success': 'Pet fed!',
      'pet_feed_cooldown': 'Try again later',
      'pet_levelup_title': 'Pet leveled up!',
      'pet_levelup_body': 'Level {level}',
      'pet_happy': 'Happy',
      'pet_hungry': 'Hungry',
      'pet_sad': 'Sad',

      // =============================================
      // LEADERBOARD
      // =============================================
      'lb_weekly': 'Weekly',
      'lb_monthly': 'Monthly',
      'lb_alliance': 'Alliances',
      'lb_share': 'Share',
      'lb_share_text': "I'm #{position} with {score} XP in PiggyVault!",
      'lb_online_soon': 'Online ranking — coming soon',

      // =============================================
      // ONBOARDING
      // =============================================
      'onb_splash_tagline': 'Your dream piggy bank',
      'onb_welcome_subtitle': 'Your personal tool\nfor saving money',
      'onb_welcome_desc':
          'Save for two dreams at once, track progress and achieve financial goals',
      'onb_start_btn': 'Get Started',
      'onb_step_1_3': 'Step 1 of 3',
      'onb_step_2_3': 'Step 2 of 3',
      'onb_step_3_3': 'Step 3 of 3',
      'onb_goal_a_title': 'First Goal',
      'onb_goal_b_title': 'Second Goal',
      'onb_goal_a_desc': 'Set up your first savings goal',
      'onb_goal_b_desc': 'Set up your second savings goal',
      'onb_goal_card_header_a': 'Goal A',
      'onb_goal_card_header_b': 'Goal B',
      'onb_goal_name_label': 'Goal name',
      'onb_goal_name_hint': 'Enter goal name',
      'onb_goal_name_validator': 'Please enter a goal name',
      'onb_goal_amount_label': 'Financial target (UAH)',
      'onb_goal_amount_validator': 'Please enter an amount',
      'onb_goal_amount_invalid': 'Enter a valid positive number',
      'onb_finish_title': 'Final Settings',
      'onb_finish_desc': 'Choose currency and deposit distribution',
      'onb_finish_save_error': 'Error saving: ',
      'onb_finish_currency': 'Currency',
      'onb_finish_split': 'Deposit Distribution',
      'onb_finish_split_desc':
          'Each deposit will be automatically distributed between goals according to the selected percentage',
      'onb_finish_start_btn': 'Start Saving',

      // =============================================
      // GAMIFICATION: ACHIEVEMENTS
      // =============================================
      'ach_header': 'ACHIEVEMENTS & RANK',
      'ach_title': 'CYBER TROPHIES',
      'ach_skill_tree': 'SKILL TREE',
      'ach_skill_desc': 'Spend SP on powerful passive skills and perks',
      'ach_unlocked': 'UNLOCKED TROPHIES',
      'ach_unlocked_desc': 'Increase your savings to unlock new ones',
      'ach_locked': 'LOCKED',

      // =============================================
      // GAMIFICATION: STREAK
      // =============================================
      'streak_header': 'GAMIFICATION & STATUS',
      'streak_title': 'FLAME CHAMBER',
      'streak_days': 'DAYS IN A ROW',
      'streak_tokens': 'CRYOGENIC TOKENS',
      'streak_tokens_desc': 'Prevents the flame from dying if you miss a day.',
      'streak_tokens_btn': 'CODES',
      'streak_heatmap': 'THERMAL ACTIVITY MAP',
      'streak_heatmap_low': 'Weak',
      'streak_heatmap_high': 'Strong',

      // =============================================
      // GAMIFICATION: LEADERBOARD
      // =============================================
      'lb_title': 'LEADERBOARD',
      'lb_in_dev': 'Leaderboard in development',

      // =============================================
      // GAMIFICATION: REGRET ARCHIVE
      // =============================================
      'regret_title': 'REGRET ARCHIVE',
      'regret_add_btn': 'ADD UNSPURCHASED',
      'regret_empty_title': 'YOUR ARCHIVE IS EMPTY',
      'regret_empty_desc':
          'Items you consciously chose not to buy are saved here',
      'regret_empty_btn': 'ADD FIRST RECORD',
      'regret_total_saved': 'TOTAL SAVED',
      'regret_dialog_title': 'ADD TO ARCHIVE',
      'regret_dialog_what': 'What did you not buy?',
      'regret_dialog_price': 'Price (₴)',
      'regret_dialog_save': 'SAVE',

      // =============================================
      // GAMIFICATION: PETS
      // =============================================
      'pet_no_sp': 'Not enough SP to feed (Need 1 SP)!',
      'pet_title': 'CYBER PETS',
      'pet_happiness': 'HAPPINESS',
      'pet_feed_btn': 'FEED (1 SP)',
      'pet_empty_title': 'YOU DON\'T HAVE A PET...',
      'pet_dragon': 'CYBER-DRAGON',
      'pet_dog': 'MECHA-DOG',
      'pet_adopt_btn': 'ADOPT',
      'pet_core_temp': 'Pet Reactor Core Temp',
      'pet_overheating_warning':
          'WARNING: CRITICAL REACTOR OVERHEATING! Save money to cool down.',

      // PET EVOLUTION
      'pet_evo_wise': 'Wise Pet',
      'pet_evo_wealthy': 'Wealthy Pet',
      'pet_evo_resilient': 'Resilient Pet',
      'pet_evo_base': 'Base Pet',
      'pet_evo_progress': 'Evolution: {progress}/7 days {ritual}',
      'pet_evo_success': 'Your pet evolved into {type}!',
      'ritual_no_spend': 'No-Spend',
      'ritual_deposits': 'Deposits',
      'ritual_karma': 'Karma Healing',
      'ritual_mixed': 'Mixed',

      // =============================================
      // GAMIFICATION: BLACKLIST
      // =============================================
      'blacklist_title': 'AUTO-PENALTIES (BLACKLIST)',
      'blacklist_desc':
          'If the system detects a purchase from these categories, an automatic penalty will be applied',
      'blacklist_active': 'ACTIVE BLACKLIST',
      'blacklist_empty': 'No categories added. Press "+" to add one',
      'blacklist_hint': 'Enter category name...',
      'blacklist_frequent': 'FREQUENT OFFENDERS:',
      'blacklist_cat_fastfood': 'Fast food',
      'blacklist_cat_games': 'Games',
      'blacklist_cat_coffee': 'Coffee',
      'blacklist_cat_subs': 'Subscriptions',
      'blacklist_cat_shopping': 'Shopping',
      'blacklist_cat_alcohol': 'Alcohol',

      // =============================================
      // GAMIFICATION: SQUADS
      // =============================================
      'squad_title': 'ALLIANCE / JOINT GOALS',
      'squad_new_btn': 'New joint goal',
      'squad_empty_title': 'NO JOINT GOALS',
      'squad_empty_desc': 'Create a joint goal with friends to save together',
      'squad_collected': 'Collected: ',
      'squad_members': 'Members: ',
      'joint_detail_together': 'TOGETHER',
      'joint_detail_members': 'MEMBERS',
      'joint_detail_contribution': 'Contribution: ',
      'joint_detail_add_tooltip': 'Add contribution',
      'joint_detail_dialog_title': 'Contribution from: ',
      'joint_detail_dialog_amount': 'Amount (₴)',

      // =============================================
      // GAMIFICATION: AVATAR BUILDER
      // =============================================
      'avatar_saved': 'Cyber-Avatar saved successfully!',
      'avatar_title': 'RPG AVATAR',
      'avatar_tab_chassis': 'CHASSIS',
      'avatar_tab_optics': 'OPTICS',
      'avatar_tab_neon': 'NEON',
      'avatar_tab_decals': 'DECALS',
      'avatar_save_btn': 'SAVE CONFIGURATION',
      'avatar_chassis_standard': 'Standard',
      'avatar_chassis_heavy': 'Heavy',
      'avatar_chassis_agile': 'Agile',
      'avatar_visor_cyclops': 'Cyclops',
      'avatar_visor_split': 'Split',
      'avatar_visor_sniper': 'Sniper',
      'avatar_visor_terminator': 'Terminator',
      'avatar_color_cyan': 'Cyan',
      'avatar_color_magenta': 'Magenta',
      'avatar_color_gold': 'Gold',
      'avatar_color_fire': 'Fire',
      'avatar_color_toxin': 'Toxin',
      'avatar_color_clean': 'Clean',
      'avatar_decal_none': 'None',
      'avatar_decal_stripes': 'Stripes',
      'avatar_decal_scar': 'Scar',
      'avatar_decal_circuits': 'Circuits',
      'avatar_item_locked': 'This item is locked!',
      'avatar_color_level': 'Color unlocks at level ',

      // =============================================
      // GAMIFICATION: PENALTY VAULT
      // =============================================
      'penalty_title': 'PENALTY ISOLATOR',
      'penalty_damaged': '⚠️ SYSTEM DAMAGED ⚠️',
      'penalty_stable': 'SYSTEM STABLE',
      'penalty_integrity': 'Integrity: ',
      'penalty_active': 'ACTIVE CYBER-PENALTIES',
      'penalty_debt': 'Debt: ',
      'penalty_pay_btn': 'PAY',
      'penalty_paid': 'Penalty paid. Integrity restored!',
      'penalty_empty':
          'You have no active penalties. The system is running stable.',

      // =============================================
      // GAMIFICATION: LOOTBOX
      // =============================================
      'loot_opened_title': 'LOOTBOX OPENED!',
      'loot_your_reward': 'Your reward:',
      'loot_awesome_btn': 'AWESOME!',
      'loot_title': 'LOOTBOXES',
      'loot_empty': 'You have no sealed lootboxes.',
      'loot_empty_hint': 'Make deposits for a chance at a drop!',
      'loot_rarity_rare': 'RARE',
      'loot_rarity_common': 'COMMON',
      'loot_open_btn': 'OPEN',
      'loot_opening': 'Opening lootbox...',

      // =============================================
      // GAMIFICATION: CLASS SELECTION
      // =============================================
      'class_changed': 'Class changed successfully!',
      'class_title': 'CLASS SELECTION',
      'class_warrior_name': 'WARRIOR',
      'class_warrior_desc':
          'Master of daily deposits. Bonuses for streak and consistency.',
      'class_mage_name': 'MAGE',
      'class_mage_desc':
          'Master of numbers. Bonuses for analytics and forecasts.',
      'class_rogue_name': 'ROGUE',
      'class_rogue_desc': 'Savings master. Bonuses for canceling purchases.',
      'class_choose_btn': 'CHOOSE THIS CLASS',
      'class_current': 'CURRENT CLASS',

      // =============================================
      // GAMIFICATION: CUSTOMIZATION
      // =============================================
      'custom_theme_changed': 'Theme changed to ',
      'custom_title': 'CUSTOMIZATION',
      'custom_colors': 'COLOR THEMES',
      'custom_personal': 'PERSONALIZATION',
      'custom_avatar_link': 'RPG AVATAR',
      'custom_avatar_desc': 'Customize the look of your cyber-robot',
      'custom_locked': 'Locked: ',
      'custom_select_btn': 'SELECT',
      'custom_theme_neon': 'NEON CYBERPUNK (NEON)',
      'custom_theme_gold': 'PRESTIGE GOLD (GOLD)',
      'custom_theme_crimson': 'CRIMSON DREAD (CRIMSON)',
      'custom_unlock_level_5': 'Reach level 5',
      'custom_unlock_level_10': 'Reach level 10',
      'custom_theme_saved': 'Theme changed to {theme}!',

      // =============================================
      // GAMIFICATION: SKILL TREE
      // =============================================
      'skill_title': 'SKILL TREE',
      'skill_error': 'Error: ',
      'skill_req_level': 'Required: ',
      'skill_req_text': 'Level ',
      'skill_name_hacker': 'Hacker',
      'skill_desc_hacker':
          'Terminal master. Earn XP for CLI usage, data decryption and Incognito Mode. Increases critical deposit chance.',
      'skill_name_magnate': 'Magnate',
      'skill_desc_magnate':
          'Financial genius. Earn XP for large deposits and consistency. Grants XP multipliers and Black Market discounts.',
      'skill_name_resilience': 'Resilience',
      'skill_desc_resilience':
          'Unbreakable cyber-samurai. Earn XP for streak recovery and penalty payments. Reduces penalty costs.',
      'skill_locked_dep': 'Previous node locked.',
      'skill_ghost_desc': 'Unlocks secret terminal commands.',
      'skill_crit_title': 'Critical Bypass',
      'skill_crit_desc': '+10% to critical deposit chance (25% → 35%).',
      'skill_dividends_title': 'XP Dividends',
      'skill_dividends_desc': '+5% XP for each deposit.',
      'skill_trade_title': 'Trade Trickery',
      'skill_trade_desc': 'Discounts on all Black Market items.',
      'skill_shield_title': 'Streak Shield',
      'skill_shield_desc':
          'Auto-protection when skipping 1 day (no Freeze Token consumed).',
      'skill_iron_title': 'Iron Border',
      'skill_iron_desc': 'Penalty costs reduced by 15%.',

      // =============================================
      // GAMIFICATION: MARKET
      // =============================================
      'market_no_credits': 'Not enough Cyber-Credits!',
      'market_purchased': 'Purchased: ',
      'market_title': 'BLACK MARKET',
      'market_sp': 'SKILL POINTS',
      'market_cr': 'CYBER-CREDITS',
      'market_tab_boosters': 'BOOSTERS (SP)',
      'market_tab_cosmetics': 'COSMETICS (CR)',
      'market_streak_freeze': 'STREAK FREEZE',
      'market_streak_freeze_desc':
          'Protects your streak from expiring for 1 day',
      'market_common_lootbox': 'COMMON LOOTBOX',
      'market_common_lootbox_desc': 'Contains a random reward',
      'market_integration_soon':
          'In development: Real rewards will be integrated',
      'market_exclusive_optics': 'EXCLUSIVE OPTICS',
      'market_terminator': 'Terminator',
      'market_terminator_desc': 'Red cyber-eye',
      'market_premium_paints': 'PREMIUM PAINTS',
      'market_decals_scars': 'DECALS & SCARS',
      'market_purchased_badge': 'PURCHASED',
      'market_purchased_success':
          'Purchased: {name}! Now available in the builder.',
      'market_item_holo_desc': 'Holographic band',
      'market_item_quantum_desc': 'Absolute neon',
      'market_item_gold_desc': 'Elite glow',
      'market_item_circuit_desc': 'Electronic traces',

      // =============================================
      // GAMIFICATION: DAILY BONUS
      // =============================================
      'daily_bonus_title': 'DAILY REWARD',
      'daily_bonus_streak': '🔥 Streak: ',
      'daily_bonus_days': ' days',
      'daily_bonus_claimed': 'Claimed!',
      'daily_bonus_claim_btn': 'Claim',

      // =============================================
      // GAMIFICATION: DAILY SPIN
      // =============================================
      'spin_already': 'You already spun the roulette today!',
      'spin_title': 'DAILY ROULETTE',
      'spin_result': 'YOUR PRIZE:',
      'spin_spin_btn': 'SPIN!',
      'spin_spinning': 'SPINNING...',
      'spin_close_btn': 'CLOSE',

      // =============================================
      // GAMIFICATION: CREATE JOINT GOAL
      // =============================================
      'joint_create_title': 'NEW JOINT GOAL',
      'joint_create_name_label': 'Goal name (e.g. PS5)',
      'joint_create_amount_label': 'Amount (₴)',
      'joint_create_members': 'Members (Virtual/Offline)',
      'joint_create_name_hint': 'Friend\'s name',
      'joint_create_btn': 'CREATE',

      // =============================================
      // GAMIFICATION: SHIELD
      // =============================================
      'shield_title': 'Streak Saved!',
      'shield_desc':
          'Your Shield (cryo-token) automatically protected your streak from expiring!',
      'shield_used': 'Shield used: ',
      'shield_unit': ' pcs.',
      'shield_btn': 'Awesome!',

      // =============================================
      // BANKING INSIGHTS
      // =============================================
      'bank_analyzing': 'VAULT-7 is analyzing transaction...',
      'bank_transferred': '✅ Transferred to Vault!',
      'bank_ignored': 'VAULT-17 advice ignored',
      'bank_remembered': '⚠️ VAULT-17 recorded this violation',
      'bank_deposit_btn': 'DEPOSIT',

      // =============================================
      // REMOTE CONTROL
      // =============================================
      'remote_title': 'CYBER PC CONTROL',
      'remote_mode_direct': 'Mode: Direct Click',
      'remote_mode_trackpad': 'Mode: Trackpad',
      'remote_latency': 'Measure latency',
      'remote_disconnect': 'Disconnect',
      'remote_desc': 'Establish connection with host server for remote control',
      'remote_ip_label': 'PC IP ADDRESS',
      'remote_port_label': 'WebSocket PORT',
      'remote_pin_label': 'CYBER-PASSWORD (PIN)',
      'remote_pin_hint': 'Enter server password',
      'remote_connect_btn': 'CONNECT',
      'remote_connected': 'CONNECTED',
      'remote_ping': 'PING: ',
      'remote_ping_ms': 'ms',
      'remote_quality': 'QUALITY: ',
      'remote_streaming': 'Waiting for screen stream...',
      'remote_scroll_down': 'Scroll Down',
      'remote_scroll_up': 'Scroll Up',
      'remote_text_btn': 'TEXT',
      'remote_text_dialog_title': 'TEXT INPUT ON PC',
      'remote_text_dialog_desc':
          'The text below will be sequentially sent to the remote PC',
      'remote_text_hint': 'Enter text...',
      'remote_send_btn': 'SEND',

      // =============================================
      // FEAT-01: SAVINGS CALCULATOR
      // =============================================
      'calc_title': 'Savings Calculator',
      'calc_target_amount': 'Target amount',
      'calc_target_hint': 'Enter amount',
      'calc_term': 'Term',
      'calc_days': 'days',
      'calc_weeks': 'weeks',
      'calc_months': 'months',
      'calc_per_day': 'Per day',
      'calc_per_week': 'Per week',
      'calc_per_month': 'Per month',
      'calc_result': 'You need to save',
      'calc_empty': 'Enter target amount and term',

      // =============================================
      // FEAT-04: WEEKLY CHALLENGES
      // =============================================
      'challenge_title': 'Weekly Challenges',
      'challenge_new': 'New Challenge',
      'challenge_edit': 'Edit',
      'challenge_name': 'Name',
      'challenge_name_hint': 'e.g. Save 500 UAH',
      'challenge_target': 'Target amount',
      'challenge_deadline': 'Deadline',
      'challenge_create': 'Create',
      'challenge_active': 'Active',
      'challenge_done': 'Completed',
      'challenge_expired': 'Expired',
      'challenge_empty': 'No challenges yet',

      // =============================================
      // FEAT-06: PENALTY / AVOIDED STATS
      // =============================================
      'stats_title': 'Savings Stats',
      'stats_penalties': 'Penalties',
      'stats_avoided': 'Saved',
      'stats_top_penalties': 'Top-5 Penalty Habits',
      'stats_weekly_trend': 'Weekly Savings Trend',

      // =============================================
      // FEAT-07: FINANCIAL HEALTH THERMOMETER
      // =============================================
      'health_title': 'Financial Health',
      'health_streak': 'Streak',
      'health_goals': 'Goals',
      'health_avoided': 'Saved',

      // =============================================
      // FEAT-08: GOAL TEMPLATES
      // =============================================
      'template_title': 'Goal Templates',
      'template_subtitle': 'Pick a template or enter manually',
      'template_btn': 'Choose Template',
      'template_months_short': 'mo',

      // =============================================
      // FEAT-14: PER-GOAL CURRENCY
      // =============================================
      'onb_currency_label': 'Currency',

      // =============================================
      // CSV IMPORT
      // =============================================
      'csv_import': 'Import CSV',
      'csv_import_success': 'Imported: {count} transactions',
      'csv_import_error': 'Import error',
      'csv_import_invalid':
          'Invalid CSV format. Expected columns: date, amount',

      // =============================================
      // IMPULSE FREEZER (EN)
      // =============================================
      'freezer_title': 'CRYO-FREEZER',
      'freezer_desc': 'Freeze impulse spending desires and review them after the cooldown.',
      'freezer_locked': 'IMPULSE FROZEN',
      'freezer_unfreeze_save': 'CRYO-SAVE (+150 XP)',
      'freezer_unfreeze_buy': 'BREAK FREEZE & BUY',
      'freezer_duration': 'Duration',
      'freezer_duration_24': '24 Hours',
      'freezer_duration_48': '48 Hours',
      'freezer_item_name': 'Impulse Buy Item',
      'freezer_item_name_hint': 'e.g. Mechanical Keyboard',
      'freezer_item_name_validator': 'Please enter the item name',
      'freezer_amount': 'Amount (₴)',
      'freezer_amount_hint': 'Enter amount to freeze',
      'freezer_amount_validator': 'Please enter the amount',
      'freezer_freeze_btn': 'ACTIVATE CRYO-FREEZE',
      'freezer_hours': 'hours',
      'freezer_active_badge': 'CRYO-SHIELD ACTIVE',
      'freezer_saved_toast': 'Willpower victory! Impulse funds saved!',
      'freezer_bought_toast': 'Freeze broken. Item purchased.',
      'freezer_debug_fast_forward': '⚡ FAST FORWARD (DEBUG)',

      // =============================================
      // NO-SPEND STREAK (EN)
      // =============================================
      'no_spend_title': '🛡️ NO-SPEND CHALLENGE',
      'no_spend_subtitle': 'Avoid unnecessary spending — earn rewards!',
      'no_spend_claim_btn': 'I spent nothing extra today',
      'no_spend_claimed': '✅ Already logged today',
      'no_spend_streak_label': '🛡️ No-Spend Streak',
      'no_spend_days': ' d.',
      'no_spend_chest_progress': 'To next chest:',
      'no_spend_success_title': '🛡️ NO-SPEND DAY!',
      'no_spend_success_reward': '+15 Cyber-Credits',
      'no_spend_success_streak': 'Streak:',
      'no_spend_success_progress': 'Chest progress:',
      'no_spend_lootbox_title': '🎁 7-DAY STREAK REWARD!',
      'no_spend_lootbox_desc': 'You earned a LOOTBOX for a 7-day no-spend streak!',
      'no_spend_debug_btn': '⚡ DEBUG: +1 day (test)',

      // =============================================
      // KARMA DEBT (EN)
      // =============================================
      'karma_title': '👾 KARMA-DEBT',
      'karma_subtitle': 'Active Debuff: -20% XP',
      'karma_debuff_hours': 'Debuff active for {hours}h',
      'karma_debuff_desc': 'System compromised! Karma-debt accumulated due to impulse spending. Complete cleansing quests to restore your cyber pet.',
      'karma_cleanse_btn': '🔮 Cleanse Karma (-25 debt)',
      'karma_report_btn': '💥 I Relapsed / Log Spends',
      'karma_report_dialog_title': '💥 Log Impulse Spend',
      'karma_report_dialog_desc': 'Honesty is the path to recovery. Enter spent amount (optional) to log the lapse.',
      'karma_report_amount_label': 'Spent amount (₴)',
      'karma_report_confirm_btn': 'REPORT IMPULSE BUY',
      'karma_compromised_toast': '👾 Karma-Borg attacked! Cyber-Pet got a -20% XP debuff for 48 hours!',
      'karma_cleansed_toast': '🔮 Karma cleansed! Remaining debt: {amount}',
      'karma_healed_toast': '✨ Cyber-Pet fully healed! XP debuff removed!',
      'karma_quest_title': 'Heal Karma-Borg',

      // =============================================
      // PRICE HUNTER
      // =============================================
      'ph_title': '🎯 Price Hunter',
      'ph_track_btn': 'TRACK PRICE',
      'ph_update_btn': 'UPDATE PRICE',
      'ph_url_label': 'Product URL',
      'ph_initial_price_label': 'Initial Price',
      'ph_current_price_label': 'Current Price',
      'ph_new_price_label': 'New Price',
      'ph_cooldown_msg': 'Price can only be updated once per hour.',
      'ph_critical_hit': 'CRITICAL HIT!',
      'ph_critical_desc': 'Price shield shattered! Boss is vulnerable. +50 XP',
      'ph_boss_vulnerable': '⚡ BOSS VULNERABLE! Price dropped!',

      // =============================================
      // STREAK SHIELD
      // =============================================
      'streak_shield_activated': 'Shield activated! (-50 CRYSH)',
      'streak_shield_error': 'Not enough CRYSH (50 needed)',
      'flash_goal_title': 'Daily Flash Goal',
      'flash_goal_desc': 'Save %s ₴ before midnight',
      'flash_goal_completed': '✅ Completed! +30 XP',

      // =============================================
      // LENDING TRACKER (EN)
      // =============================================
      'lend_title': 'LENDING TRACKER (BETA)',
      'lend_subtitle': 'Active contracts and debts',
      'lend_add_btn': 'NEW CONTRACT',
      'lend_debtor_name': 'Debtor Name',
      'lend_amount': 'Debt Amount (₴)',
      'lend_return_date': 'Return Date',
      'lend_quick_7': '7 Days',
      'lend_quick_30': '30 Days',
      'lend_pick_date': 'Pick Date',
      'lend_save_btn': 'SIGN CONTRACT',
      'lend_empty': 'No active contracts. Time to lend some money?',
      'lend_status_active': 'ACTIVE',
      'lend_status_overdue': 'OVERDUE',
      'lend_status_returned': 'RETURNED',
      'lend_return_btn': 'MARK AS RETURNED',
      'lend_returned_toast': 'Contract closed! +50 XP awarded.',
      'lend_days_left': '{days}d left',
      'lend_overdue_by': 'Overdue by {days}d',

      // =============================================
      // CYBER-ORACLE (EN)
      // =============================================
      'oracle_title': 'CYBER-ORACLE',
      'oracle_subtitle': 'AI Financial Prophet',
      'oracle_input_hint': 'Query the void...',
      'oracle_error_unavailable': 'Signal lost. Oracle is offline.',
      'oracle_system_prompt': 'You are the Cyber-Oracle, a financial assistant in the world of Save Quest. Respond concisely, using cyberpunk slang. Help with savings, budgeting, and motivation. Use terms like "credits", "host", "data-center", "protocol". Your goal is to maximize user capital.',
      'oracle_clear_history': 'Clear memory',
    }
  };

  static String get(String locale, String key) {
    if (!_localizedValues.containsKey(locale)) {
      return _localizedValues['UA']?[key] ?? key;
    }
    return _localizedValues[locale]?[key] ?? key;
  }

  static String format(String locale, String key, Map<String, String> params) {
    String base = get(locale, key);
    for (final entry in params.entries) {
      base = base.replaceAll('{${entry.key}}', entry.value);
    }
    return base;
  }
}
