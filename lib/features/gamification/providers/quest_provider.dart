import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/providers/providers.dart';
import '../../../core/models/avatar_config.dart';
import '../models/daily_quest.dart';

class QuestNotifier extends StateNotifier<AsyncValue<List<DailyQuest>>> {
  final Ref ref;

  QuestNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadQuests();
  }

  Future<void> _loadQuests() async {
    try {
      final settings = ref.read(settingsServiceProvider);
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      final savedDate = settings.dailyQuestsDate;
      if (savedDate == todayStr) {
        final rawList = settings.dailyQuests;
        if (rawList != null) {
          final quests = rawList.map((q) => DailyQuest.fromJson(Map<String, dynamic>.from(q))).toList();
          state = AsyncValue.data(quests);
          return;
        }
      }
      
      // Generate new quests for today
      await _generateNewQuests(todayStr);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> _generateNewQuests(String dateStr) async {
    state = const AsyncValue.loading();
    
    // We will always have 3 quests. 
    // The first one could represent the AI Bounty conceptually, but since Bounty is handled via BountyNotifier,
    // we'll keep DailyQuests for specific UI actions.
    
    final newQuests = [
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
    
    _saveQuests(newQuests, dateStr);
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
    }

    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _saveQuests(newList, todayStr);
  }
}

final questProvider = StateNotifierProvider<QuestNotifier, AsyncValue<List<DailyQuest>>>((ref) {
  return QuestNotifier(ref);
});
