import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import '../../../core/providers/providers.dart';
import '../../../data/database.dart';

class JointGoalData {
  final JointGoal goal;
  final List<JointGoalMember> members;

  JointGoalData({required this.goal, required this.members});
}

final jointGoalsProvider = StreamProvider<List<JointGoalData>>((ref) async* {
  final db = ref.watch(databaseProvider);
  
  // Watch all goals
  final stream = db.select(db.jointGoals).watch();
  
  await for (final goals in stream) {
    List<JointGoalData> data = [];
    for (var goal in goals) {
      final members = await (db.select(db.jointGoalMembers)
            ..where((t) => t.goalId.equals(goal.id)))
          .get();
      data.add(JointGoalData(goal: goal, members: members));
    }
    yield data;
  }
});

class JointGoalsNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase db;

  JointGoalsNotifier(this.db) : super(const AsyncValue.data(null));

  Future<void> createGoal(String title, int targetAmount, List<String> friendNames) async {
    state = const AsyncValue.loading();
    try {
      final goalId = const Uuid().v4();
      
      await db.transaction(() async {
        // Create the goal
        await db.into(db.jointGoals).insert(
          JointGoal(
            id: goalId,
            title: title,
            targetAmount: targetAmount,
            currentAmount: 0,
            createdAt: DateTime.now(),
          ),
        );

        // Add current user
        await db.into(db.jointGoalMembers).insert(
          JointGoalMember(
            id: const Uuid().v4(),
            goalId: goalId,
            memberName: 'Я',
            contributedAmount: 0,
            avatarIndex: 0,
            isCurrentUser: true,
          ),
        );

        // Add friends
        for (var i = 0; i < friendNames.length; i++) {
          await db.into(db.jointGoalMembers).insert(
            JointGoalMember(
              id: const Uuid().v4(),
              goalId: goalId,
              memberName: friendNames[i],
              contributedAmount: 0,
              avatarIndex: (i % 10) + 1,
              isCurrentUser: false,
            ),
          );
        }
      });
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addContribution(String goalId, String memberId, int amountToAdd) async {
    state = const AsyncValue.loading();
    try {
      await db.transaction(() async {
        // Update member
        final member = await (db.select(db.jointGoalMembers)..where((t) => t.id.equals(memberId))).getSingle();
        await (db.update(db.jointGoalMembers)..where((t) => t.id.equals(memberId)))
            .write(JointGoalMembersCompanion(
          contributedAmount: Value(member.contributedAmount + amountToAdd),
        ));

        // Update goal
        final goal = await (db.select(db.jointGoals)..where((t) => t.id.equals(goalId))).getSingle();
        await (db.update(db.jointGoals)..where((t) => t.id.equals(goalId)))
            .write(JointGoalsCompanion(
          currentAmount: Value(goal.currentAmount + amountToAdd),
        ));
      });
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final jointGoalsNotifierProvider = StateNotifierProvider<JointGoalsNotifier, AsyncValue<void>>((ref) {
  final db = ref.watch(databaseProvider);
  return JointGoalsNotifier(db);
});
