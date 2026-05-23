/// Badge definitions for Achievements 2.0
class BadgeDef {
  final String id;
  final String emoji;
  final String name;
  final String description;

  const BadgeDef({
    required this.id,
    required this.emoji,
    required this.name,
    required this.description,
  });
}

const List<BadgeDef> allBadges = [
  BadgeDef(
    id: 'iron_wallet',
    emoji: '🔩',
    name: 'Залізний Гаманець',
    description: 'Відкладай гроші 7 днів поспіль',
  ),
  BadgeDef(
    id: 'slick_hacker',
    emoji: '⚡',
    name: 'Спритний Хакер',
    description: 'Зроби перший депозит',
  ),
  BadgeDef(
    id: 'corporate_magnate',
    emoji: '🏢',
    name: 'Корпоративний Магнат',
    description: 'Накопич загальних заощаджень на суму 10 000+',
  ),
  BadgeDef(
    id: 'streak_14',
    emoji: '🔥',
    name: 'Полум\'яна Серія',
    description: 'Стрік 14 днів поспіль',
  ),
  BadgeDef(
    id: 'streak_30',
    emoji: '👑',
    name: 'Нейро-Корона',
    description: 'Стрік 30 днів поспіль',
  ),
  BadgeDef(
    id: 'night_owl',
    emoji: '🦉',
    name: 'Нічна Сова',
    description: 'Зроби депозит після 23:00',
  ),
  BadgeDef(
    id: 'big_spender',
    emoji: '💎',
    name: 'Алмазний Депозит',
    description: 'Заощадь 1 000+ за один депозит',
  ),
  BadgeDef(
    id: 'speed_runner',
    emoji: '🚀',
    name: 'Спідранер',
    description: 'Зроби 5 депозитів за 1 день',
  ),
];

List<String> checkNewBadges({
  required List<String> existingBadges,
  required int newStreak,
  required int totalSavedCents,
  required int depositAmountCents,
  required int hour,
  required int depositsToday,
}) {
  final unlocked = <String>[];

  void tryUnlock(String id) {
    if (!existingBadges.contains(id) && !unlocked.contains(id)) {
      unlocked.add(id);
    }
  }

  // First deposit ever
  if (!existingBadges.contains('slick_hacker')) {
    tryUnlock('slick_hacker');
  }

  // 7-day streak
  if (newStreak >= 7) tryUnlock('iron_wallet');
  // 14-day streak
  if (newStreak >= 14) tryUnlock('streak_14');
  // 30-day streak
  if (newStreak >= 30) tryUnlock('streak_30');

  // Corporate magnate: 10,000 UAH (1,000,000 kopecks)
  if (totalSavedCents >= 1000000) tryUnlock('corporate_magnate');

  // Night owl: deposit after 23:00
  if (hour >= 23) tryUnlock('night_owl');

  // Big deposit: 1000 UAH in one go (100000 kopecks)
  if (depositAmountCents >= 100000) tryUnlock('big_spender');

  // Speed runner: 5 deposits in a day
  if (depositsToday >= 5) tryUnlock('speed_runner');

  return unlocked;
}
