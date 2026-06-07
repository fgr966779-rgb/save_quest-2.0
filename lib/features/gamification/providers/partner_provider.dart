import 'dart:math';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

// Provides the UserProfile for easy reading of partner data
final partnerProvider = StateNotifierProvider<PartnerNotifier, AsyncValue<UserProfile?>>((ref) {
  return PartnerNotifier(ref);
});

class PartnerNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final Ref _ref;

  PartnerNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final db = _ref.read(databaseProvider);
      final profile = await db.getUserProfile();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setPartnerName(String name) async {
    if (name.trim().isEmpty) return;
    
    final db = _ref.read(databaseProvider);
    final current = state.value;
    if (current == null) return;

    final updated = current.copyWith(
      partnerName: Value(name.trim()),
      // Set to 3 days ago so the quest doesn't auto-complete immediately
      partnerLastDepositDate: Value(DateTime.now().subtract(const Duration(days: 3))),
    );

    await db.updateUserProfile(updated);
    await _loadProfile();
  }

  Future<void> removePartner() async {
    final db = _ref.read(databaseProvider);
    final current = state.value;
    if (current == null) return;

    final updated = current.copyWith(
      partnerName: const Value(null),
      partnerLastDepositDate: const Value(null),
    );

    await db.updateUserProfile(updated);
    await _loadProfile();
  }

  /// Called when user makes a deposit
  Future<bool> simulatePartnerActivity() async {
    final db = _ref.read(databaseProvider);
    final current = state.value;
    if (current == null || current.partnerName == null) return false;

    bool savedQuest = false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    DateTime? partnerLast = current.partnerLastDepositDate;
    
    if (partnerLast != null) {
      final pDate = DateTime(partnerLast.year, partnerLast.month, partnerLast.day);
      final daysSincePartnerDeposit = today.difference(pDate).inDays;
      if (daysSincePartnerDeposit > 1) {
        // Partner missed 1 or more days. User's deposit "saves" the quest!
        savedQuest = true;
        
        // Give bonus XP for saving the quest
        final profile = await db.getUserProfile();
        if (profile != null) {
          await db.updateUserProfile(profile.copyWith(xp: profile.xp + 100));
          _ref.invalidate(userProfileProvider);
        }
      }
    }

    // 20% chance the partner skips today
    final random = Random();
    final skipsToday = random.nextDouble() < 0.20;

    DateTime newPartnerDate = partnerLast ?? today;
    if (!skipsToday) {
      newPartnerDate = now;
    }

    final updated = current.copyWith(
      partnerLastDepositDate: Value(newPartnerDate),
    );

    await db.updateUserProfile(updated);
    await _loadProfile();

    return savedQuest;
  }
  
  bool isDoubleStrikeActive() {
    // Check if partner deposited within last 3 days
    final current = state.value;
    if (current == null || current.partnerName == null || current.partnerLastDepositDate == null) return false;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final partnerLast = current.partnerLastDepositDate!;
    final pDate = DateTime(partnerLast.year, partnerLast.month, partnerLast.day);
    
    return today.difference(pDate).inDays <= 3;
  }
}
