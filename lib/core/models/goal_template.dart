/// Predefined goal templates for quick setup.
class GoalTemplate {
  final String id;
  final String name;
  final int targetHryvnias; // display value (will be converted to kopecks)
  final int termMonths;
  final String emoji;
  final String category;

  const GoalTemplate({
    required this.id,
    required this.name,
    required this.targetHryvnias,
    required this.termMonths,
    required this.emoji,
    required this.category,
  });

  /// Monthly savings needed (display value).
  double get monthlyPayment => targetHryvnias / termMonths;

  static const List<GoalTemplate> all = [
    GoalTemplate(
      id: 'iphone',
      name: 'iPhone',
      targetHryvnias: 50000,
      termMonths: 12,
      emoji: '📱',
      category: 'tech',
    ),
    GoalTemplate(
      id: 'ps5',
      name: 'PlayStation 5',
      targetHryvnias: 25000,
      termMonths: 6,
      emoji: '🎮',
      category: 'tech',
    ),
    GoalTemplate(
      id: 'vacation',
      name: 'Відпустка',
      targetHryvnias: 30000,
      termMonths: 8,
      emoji: '✈️',
      category: 'travel',
    ),
    GoalTemplate(
      id: 'car',
      name: 'Машина',
      targetHryvnias: 500000,
      termMonths: 36,
      emoji: '🚗',
      category: 'transport',
    ),
    GoalTemplate(
      id: 'safety_net',
      name: 'Подушка безпеки',
      targetHryvnias: 100000,
      termMonths: 24,
      emoji: '🛡️',
      category: 'savings',
    ),
    GoalTemplate(
      id: 'laptop',
      name: 'Ноутбук',
      targetHryvnias: 40000,
      termMonths: 10,
      emoji: '💻',
      category: 'tech',
    ),
    GoalTemplate(
      id: 'apartment',
      name: 'Початковий внесок',
      targetHryvnias: 300000,
      termMonths: 24,
      emoji: '🏠',
      category: 'housing',
    ),
    GoalTemplate(
      id: 'course',
      name: 'Онлайн-курс',
      targetHryvnias: 10000,
      termMonths: 3,
      emoji: '📚',
      category: 'education',
    ),
  ];
}
