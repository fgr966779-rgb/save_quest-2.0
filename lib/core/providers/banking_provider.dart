import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/openrouter_service.dart';
import '../../data/database.dart';
import '../../data/settings_service.dart';
import '../utils/money_utils.dart';
import 'providers.dart';

// --- Models ---

class BankTransaction {
  final String id;
  final String title;
  final String category;
  final int amountKopecks;
  final DateTime date;

  BankTransaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amountKopecks,
    required this.date,
  });
}

class AIInsight {
  final String id;
  final String title;
  final String description;
  final String type; // 'round_up', 'savings_opportunity', 'spending_alert', 'cyber_coach'
  final int suggestedAmountKopecks;

  AIInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.suggestedAmountKopecks = 0,
  });
}

// --- Providers ---

final mockBankingProvider =
    StateNotifierProvider<MockBankingNotifier, List<BankTransaction>>((ref) {
  return MockBankingNotifier(ref);
});

/// Async provider that fetches LLM insights when a key is available,
/// otherwise falls back to local heuristic insights.
final aiInsightsProvider =
    FutureProvider.autoDispose<List<AIInsight>>((ref) async {
  final transactions = ref.watch(mockBankingProvider);
  final settings = ref.watch(settingsServiceProvider);
  final apiKey = settings.openRouterApiKey;
  return _generateInsights(transactions, apiKey: apiKey, settings: settings);
});

// --- Mock Banking Notifier ---

class MockBankingNotifier extends StateNotifier<List<BankTransaction>> {
  final Ref ref;

  MockBankingNotifier(this.ref) : super([]) {
    _seedHistoricalData();
  }

  void addTransaction(String title, String category, double amount) {
    final transaction = BankTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      category: category,
      amountKopecks: (amount * 100).toInt(),
      date: DateTime.now(),
    );
    state = [transaction, ...state];
  }

  void simulateRandomTransaction() {
    final random = Random();
    final data = [
      ('Сільпо', 'Supermarket', 30.0 + random.nextDouble() * 200),
      ('Aroma Kava', 'Cafe', 55.0 + random.nextDouble() * 60),
      ('Uklon', 'Transport', 80.0 + random.nextDouble() * 120),
      ('Steam', 'Entertainment', 150.0 + random.nextDouble() * 500),
      ('Rozetka', 'Tech', 300.0 + random.nextDouble() * 3000),
      ('Ukrposhta', 'Services', 40.0 + random.nextDouble() * 80),
    ];
    final pick = data[random.nextInt(data.length)];
    final amount = double.parse(pick.$3.toStringAsFixed(2));
    
    // Check for Blacklist Categories
    final settings = ref.read(settingsServiceProvider);
    final isBlacklisted = settings.blacklistedCategories.contains(pick.$1) || 
                          settings.blacklistedCategories.contains(pick.$2);
    
    if (isBlacklisted) {
      // Penalty: 10% of transaction amount
      final penaltyCents = (amount * 100 * 0.10).toInt();
      ref.read(penaltyProvider.notifier).issueFine('Blacklist: ${pick.$1}', penaltyCents);
    }
    
    addTransaction(pick.$1, pick.$2, amount);
  }

  void simulateSpecific(String title, String category, double amount) {
    addTransaction(title, category, amount);
  }

  void clearTransactions() {
    state = [];
  }

  void _seedHistoricalData() {
    final now = DateTime.now();
    state = [
      BankTransaction(
          id: 't1',
          title: 'Aroma Kava',
          category: 'Cafe',
          amountKopecks: 8500,
          date: now.subtract(const Duration(hours: 2))),
      BankTransaction(
          id: 't2',
          title: 'Сільпо',
          category: 'Supermarket',
          amountKopecks: 45050,
          date: now.subtract(const Duration(hours: 26))),
      BankTransaction(
          id: 't3',
          title: 'Uklon',
          category: 'Transport',
          amountKopecks: 12000,
          date: now.subtract(const Duration(hours: 48))),
    ];
  }
}

// --- Insights Engine ---

Future<List<AIInsight>> _generateInsights(
  List<BankTransaction> transactions, {
  String apiKey = '',
  required SettingsService settings,
}) async {
  if (transactions.isEmpty) return [];

  final insights = <AIInsight>[];
  final now = DateTime.now();
  int totalPendingRoundUp = 0;

  for (final t in transactions) {
    if (t.date.isAfter(now.subtract(const Duration(days: 1)))) {
      final amountUAH = t.amountKopecks / 100.0;
      final roundedUAH = (amountUAH / 10).ceil() * 10;
      final diffKopecks = ((roundedUAH - amountUAH) * 100).round();
      if (diffKopecks > 0) totalPendingRoundUp += diffKopecks;
    }
  }

  // --- Try LLM for the latest transaction ---
  final latestTx = transactions.first;
  final service = OpenRouterService(
    apiKey: apiKey, 
    personality: CoachPersonalityExt.fromKey(settings.coachPersonality)
  );

  if (service.isAvailable) {
    final llmText = await service.generateInsight(
      transactionTitle: latestTx.title,
      transactionCategory: latestTx.category,
      transactionAmount: latestTx.amountKopecks / 100.0,
    );

    if (llmText != null && llmText.isNotEmpty) {
      // Calculate a suggested save amount (10% of tx, min 5 UAH, max 100 UAH)
      final suggested =
          ((latestTx.amountKopecks * 0.10).clamp(500, 10000)).toInt();

      final coachName = service.personality == CoachPersonality.analyst ? '🤖 UNIT-A:' 
          : service.personality == CoachPersonality.enthusiast ? '🌟 SPARK:' 
          : '🤖 VAULT-17:';

      insights.add(AIInsight(
        id: 'llm_${latestTx.id}',
        title: coachName,
        description: llmText,
        type: 'cyber_coach',
        suggestedAmountKopecks: suggested,
      ));
      // LLM insight is enough — no need for fallback
      return insights;
    }
  }

  // --- Fallback: Local heuristic insights ---
  if (totalPendingRoundUp >= 500) {
    insights.add(AIInsight(
      id: 'round_up_1',
      title: 'Магія Округлення ✨',
      description:
          'Ви здійснили кілька покупок. Округлити їх і відкласти ${centsToDisplay(totalPendingRoundUp)}?',
      type: 'round_up',
      suggestedAmountKopecks: totalPendingRoundUp,
    ));
  }

  final todayCafeKopecks = transactions
      .where((t) =>
          t.category == 'Cafe' &&
          t.date.day == now.day &&
          t.date.month == now.month)
      .fold(0, (sum, t) => sum + t.amountKopecks);

  if (todayCafeKopecks > 0 && todayCafeKopecks < 5000) {
    insights.add(AIInsight(
      id: 'ai_save_1',
      title: 'Розумна Економія 🧠',
      description:
          'Схоже, сьогодні ви зекономили на каві! Можливо, перекажемо 50 грн у Сховище?',
      type: 'savings_opportunity',
      suggestedAmountKopecks: 5000,
    ));
  } else if (latestTx.category == 'Entertainment' ||
      latestTx.category == 'Tech') {
    insights.add(AIInsight(
      id: 'ai_spend_1',
      title: 'Ігровий Баланс 🎮',
      description:
          'Ви щойно витратили на розваги. Збалансуйте карму — закиньте 100 грн на ціль!',
      type: 'spending_alert',
      suggestedAmountKopecks: 10000,
    ));
  }

  return insights;
}
