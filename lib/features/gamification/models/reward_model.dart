enum RewardRarity { common, rare, epic, legendary }

enum RewardType { achievement, badge }

class Reward {
  final String id;
  final String titleUa;
  final String titleEn;
  final String descriptionUa;
  final String descriptionEn;
  final RewardRarity rarity;
  final String icon; // emoji or asset path
  final RewardType type;

  const Reward({
    required this.id,
    required this.titleUa,
    required this.titleEn,
    required this.descriptionUa,
    required this.descriptionEn,
    this.rarity = RewardRarity.common,
    required this.icon,
    this.type = RewardType.achievement,
  });

  String getTitle(String locale) => locale == 'UA' ? titleUa : titleEn;
  String getDescription(String locale) => locale == 'UA' ? descriptionUa : descriptionEn;
}

const List<Reward> allRewards = [
  // --- Legacy Achievements ---
  Reward(
    id: 'first_step',
    titleUa: 'Перший крок',
    titleEn: 'First Step',
    descriptionUa: 'Зробіть перший депозит у скарбничку',
    descriptionEn: 'Make your first deposit to the savings vault',
    rarity: RewardRarity.common,
    icon: '🎯',
  ),
  Reward(
    id: 'cyber_saver_3',
    titleUa: 'Кібер-Заощаджувач',
    titleEn: 'Cyber Saver',
    descriptionUa: 'Утримуйте 3-денну серію депозитів',
    descriptionEn: 'Maintain a 3-day deposit streak',
    rarity: RewardRarity.common,
    icon: '⚡',
  ),
  Reward(
    id: 'neon_streak_7',
    titleUa: 'Неонова іскра',
    titleEn: 'Neon Spark',
    descriptionUa: 'Утримуйте 7-денну серію депозитів',
    descriptionEn: 'Maintain a 7-day deposit streak',
    rarity: RewardRarity.rare,
    icon: '🔥',
  ),
  Reward(
    id: 'golden_flame_14',
    titleUa: 'Золоте полум\'я',
    titleEn: 'Golden Flame',
    descriptionUa: 'Утримуйте 14-денну серію депозитів',
    descriptionEn: 'Maintain a 14-day deposit streak',
    rarity: RewardRarity.epic,
    icon: '👑',
  ),
  Reward(
    id: 'immortal_fire_30',
    titleUa: 'Безсмертний вогонь',
    titleEn: 'Immortal Fire',
    descriptionUa: 'Утримуйте 30-денну серію депозитів',
    descriptionEn: 'Maintain a 30-day deposit streak',
    rarity: RewardRarity.legendary,
    icon: '🪐',
  ),
  Reward(
    id: 'halfway_ps5',
    titleUa: 'Півдороги до PS5',
    titleEn: 'Halfway to PS5',
    descriptionUa: 'Накопичено 50% від суми для PlayStation 5',
    descriptionEn: 'Accumulated 50% of target amount for PlayStation 5',
    rarity: RewardRarity.rare,
    icon: '🎮',
  ),
  Reward(
    id: 'halfway_monitor',
    titleUa: 'Півдороги до Монітора',
    titleEn: 'Halfway to Monitor',
    descriptionUa: 'Накопичено 50% від суми для Gaming Monitor',
    descriptionEn: 'Accumulated 50% of target amount for Gaming Monitor',
    rarity: RewardRarity.rare,
    icon: '🖥️',
  ),
  Reward(
    id: 'ps5_acquired',
    titleUa: 'Легенда PlayStation',
    titleEn: 'PlayStation Legend',
    descriptionUa: 'Накопичено 100% суми для PlayStation 5',
    descriptionEn: 'Accumulated 100% of target amount for PlayStation 5',
    rarity: RewardRarity.legendary,
    icon: '🌌',
  ),
  Reward(
    id: 'monitor_acquired',
    titleUa: 'Абсолютний візуал',
    titleEn: 'Absolute Visual',
    descriptionUa: 'Накопичено 100% суми для Gaming Monitor',
    descriptionEn: 'Accumulated 100% of target amount for Gaming Monitor',
    rarity: RewardRarity.legendary,
    icon: '🔮',
  ),
  Reward(
    id: 'split_master',
    titleUa: 'Майстер Спліту',
    titleEn: 'Split Master',
    descriptionUa: 'Зробіть депозит з распределом 50% на 50%',
    descriptionEn: 'Make a deposit with 50% to 50% allocation',
    rarity: RewardRarity.common,
    icon: '⚖️',
  ),
  Reward(
    id: 'freeze_shield',
    titleUa: 'Кріогенний щит',
    titleEn: 'Cryogenic Shield',
    descriptionUa: 'Використайте токен заморозки серії',
    descriptionEn: 'Use a streak freeze token',
    rarity: RewardRarity.common,
    icon: '❄️',
  ),
  Reward(
    id: 'xp_hoarder_1',
    titleUa: 'Зростаюча сила',
    titleEn: 'Rising Power',
    descriptionUa: 'Досягніть 5-го рівня XP',
    descriptionEn: 'Reach XP Level 5',
    rarity: RewardRarity.rare,
    icon: '🧬',
  ),
  Reward(
    id: 'centurion',
    titleUa: 'Центурион',
    titleEn: 'Centurion',
    descriptionUa: 'Зробіть одноразовый депозит від 100 одиниць',
    descriptionEn: 'Make a single deposit of 100+ units',
    rarity: RewardRarity.epic,
    icon: '🧱',
  ),

  // --- Legacy Badges ---
  Reward(
    id: 'iron_wallet',
    titleUa: 'Залізний Гаманець',
    titleEn: 'Iron Wallet',
    descriptionUa: 'Відкладай гроші 7 днів поспіль',
    descriptionEn: 'Save money for 7 days in a row',
    rarity: RewardRarity.rare,
    icon: '🔩',
    type: RewardType.badge,
  ),
  Reward(
    id: 'corporate_magnate',
    titleUa: 'Корпоративний Магнат',
    titleEn: 'Corporate Magnate',
    descriptionUa: 'Накопич загальних заощаджень на суму 10 000+',
    descriptionEn: 'Accumulate total savings of 10,000+',
    rarity: RewardRarity.epic,
    icon: '🏢',
    type: RewardType.badge,
  ),
  Reward(
    id: 'speed_runner',
    titleUa: 'Спідранер',
    titleEn: 'Speed Runner',
    descriptionUa: 'Зроби 5 депозитів за 1 день',
    descriptionEn: 'Make 5 deposits in one day',
    rarity: RewardRarity.rare,
    icon: '🚀',
    type: RewardType.badge,
  ),
];
