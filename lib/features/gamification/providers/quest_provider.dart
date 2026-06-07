import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/providers/providers.dart';
import '../../../core/models/avatar_config.dart';
import '../models/daily_quest.dart';
import 'karma_provider.dart';

class QuestNotifier extends StateNotifier<AsyncValue<List<DailyQuest>>> {
  final Ref ref;

  QuestNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadQuests();
  }

  Future<void> _loadQuests() async {
    try {
      final settings = ref.read(settingsServiceProvider);
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      List<DailyQuest> quests = [];
      final savedDate = settings.dailyQuestsDate;
      if (savedDate == todayStr) {
        final rawList = settings.dailyQuests;
        if (rawList != null) {
          quests = rawList.map((q) => DailyQuest.fromJson(Map<String, dynamic>.from(q))).toList();
        }
      }
      
      if (quests.isEmpty) {
        // Generate new quests for today
        quests = _generateBaseQuests();
      }

      // Check if Karma Debt is active, append "Heal Karma-Borg" if so
      final db = ref.read(databaseProvider);
      final profile = await db.getUserProfile();
      if (profile != null && profile.karmaDebt > 0) {
        final hasKarmaQuest = quests.any((q) => q.id == 'heal_karma');
        if (!hasKarmaQuest) {
          quests = [
            ...quests,
            const DailyQuest(
              id: 'heal_karma',
              title: 'Вилікувати Карма-Борга',
              description: 'Усуньте вірусну атаку та очистіть карма-борг.',
              rewardXp: 15,
              rewardCredits: 5,
            )
          ];
        }
      } else {
        // Remove it if karma is already 0
        quests = quests.where((q) => q.id != 'heal_karma').toList();
      }

      state = AsyncValue.data(quests);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  List<DailyQuest> _generateBaseQuests() {
    return [
      const DailyQuest(
        id: 'deposit_any',
        title: 'Фінансовий Потік',
        description: 'Зробіть хоча б один внесок сьогодні.',
        rewardXp: 10,
        rewardCredits: 5,
      ),
      const DailyQuest(
        id: 'spin_roulette',
        title: 'Колесо Фортуни',
        description: 'Випробуйте удачу в Daily Spin.',
        rewardXp: 5,
        rewardCredits: 2,
      ),
      const DailyQuest(
        id: 'view_analytics',
        title: 'Аналітик Даних',
        description: 'Перевірте статистику на екрані Аналітики.',
        rewardXp: 5,
        rewardCredits: 2,
      ),
    ];
  }



  void _saveQuests(List<DailyQuest> quests, String dateStr) {
    final settings = ref.read(settingsServiceProvider);
    settings.dailyQuestsDate = dateStr;
    settings.dailyQuests = quests.map((q) => q.toJson()).toList();
    state = AsyncValue.data(quests);
  }

  Future<void> completeQuest(String questId) async {
    final currentQuests = state.value;
    if (currentQuests == null) return;

    final index = currentQuests.indexWhere((q) => q.id == questId);
    if (index == -1) return;

    final quest = currentQuests[index];
    if (quest.isCompleted) return;

    // Mark as completed
    final updatedQuest = quest.copyWith(isCompleted: true);
    final newList = List<DailyQuest>.from(currentQuests);
    newList[index] = updatedQuest;

    // Apply rewards
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile != null) {
      final newHackerXp = profile.hackerXp + quest.rewardXp;
      
      // Load AvatarConfig to add credits
      final existingConfig = profile.avatarConfig != null 
            ? AvatarConfig.fromJson(profile.avatarConfig!)
            : const AvatarConfig();
            
      final updatedConfig = existingConfig.copyWith(
        credits: existingConfig.credits + quest.rewardCredits,
      );
      
      await db.updateUserProfile(profile.copyWith(
        hackerXp: newHackerXp,
        avatarConfig: drift.Value(updatedConfig.toJson()),
      ));
      ref.invalidate(userProfileProvider);

      if (questId == 'heal_karma') {
        // Automatically trigger karma cleansing logic
        // Import of karmaProvider is not needed because it will resolve via ref
        // We will read the karmaProvider notifier and perform cleanse.
        await ref.read(karmaProvider.notifier).cleanseKarma();
      }
    }

    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _saveQuests(newList, todayStr);
  }
}

final questProvider = StateNotifierProvider<QuestNotifier, AsyncValue<List<DailyQuest>>>((ref) {
  return QuestNotifier(ref);
});
