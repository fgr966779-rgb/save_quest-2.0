import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../core/services/openrouter_service.dart';
import '../models/bounty_model.dart';

class BountyNotifier extends StateNotifier<AsyncValue<Bounty?>> {
  final Ref ref;

  BountyNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadBounty();
  }

  Future<void> _loadBounty() async {
    try {
      final settings = ref.read(settingsServiceProvider);
      final bountyJson = settings.activeBounty;
      
      if (bountyJson != null) {
        final bounty = Bounty.fromJson(bountyJson);
        if (bounty.deadline.isBefore(DateTime.now()) && !bounty.isCompleted) {
          await generateNewBounty();
        } else {
          state = AsyncValue.data(bounty);
        }
      } else {
        await generateNewBounty();
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> saveBounty(Bounty? bounty) async {
    final settings = ref.read(settingsServiceProvider);
    settings.activeBounty = bounty?.toJson();
    state = AsyncValue.data(bounty);
  }

  Future<void> generateNewBounty() async {
    state = const AsyncValue.loading();
    try {
      final openRouter = ref.read(openRouterProvider);
      final apiKey = ref.read(settingsServiceProvider).openRouterApiKey;

      if (apiKey.isEmpty) {
        final fallback = Bounty(
          title: 'LOCAL OVERRIDE: Daily Node',
          description: 'Save 100 UAH today to keep the local nodes running.',
          targetAmount: 100.0,
          rewardXp: 50,
          rewardCredits: 10,
          deadline: DateTime.now().add(const Duration(hours: 24)),
        );
        await saveBounty(fallback);
        return;
      }

      const prompt = '''
Generate a short Cyberpunk-themed daily savings bounty mission in Ukrainian language. 
Respond ONLY with a JSON object in this exact format, no markdown or extra text:
{
  "title": "Операція: Неонова Крапля",
  "description": "Короткий опис завдання, що просить відкласти конкретну суму.",
  "targetAmount": 150.0,
  "rewardXp": 80,
  "rewardCredits": 15
}
Keep targetAmount between 50 and 500. Write title and description in Ukrainian.
''';

      final response = await openRouter.generateText(prompt: prompt);
      
      try {
        final cleanJson = response.replaceAll('```json', '').replaceAll('```', '').trim();
        final map = json.decode(cleanJson) as Map<String, dynamic>;
        
        final bounty = Bounty(
          title: map['title'] ?? 'Зашифрований Контракт',
          description: map['description'] ?? 'Збережи кошти для дешифрування.',
          targetAmount: (map['targetAmount'] as num?)?.toDouble() ?? 100.0,
          rewardXp: (map['rewardXp'] as num?)?.toInt() ?? 50,
          rewardCredits: (map['rewardCredits'] as num?)?.toInt() ?? 10,
          deadline: DateTime.now().add(const Duration(hours: 24)),
        );
        await saveBounty(bounty);
      } catch (_) {
        final fallback = Bounty(
          title: 'ПОШКОДЖЕНИЙ КОНТРАКТ',
          description: 'Помилка дешифрування. Ручне завдання: заощадь 100 грн.',
          targetAmount: 100.0,
          rewardXp: 50,
          rewardCredits: 10,
          deadline: DateTime.now().add(const Duration(hours: 24)),
        );
        await saveBounty(fallback);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> checkDeposit(double amount) async {
    final bounty = state.value;
    if (bounty == null || bounty.isCompleted) return;

    if (amount >= bounty.targetAmount) {
      final updated = bounty.copyWith(isCompleted: true);
      await saveBounty(updated);
    }
  }
}

final bountyProvider = StateNotifierProvider<BountyNotifier, AsyncValue<Bounty?>>((ref) {
  return BountyNotifier(ref);
});
