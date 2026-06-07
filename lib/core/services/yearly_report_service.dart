import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../core/providers/providers.dart';

class AnnualReportData {
  final int year;
  final int totalDeposits; // in minor units
  final int goalsCompleted;
  final int maxStreak;
  final int totalSavedFromImpulse; // penaltyBalance
  final int debtsReturned;
  final int oracleRequests;
  final String title;

  AnnualReportData({
    required this.year,
    required this.totalDeposits,
    required this.goalsCompleted,
    required this.maxStreak,
    required this.totalSavedFromImpulse,
    required this.debtsReturned,
    required this.oracleRequests,
    required this.title,
  });
}

final yearlyReportServiceProvider = Provider<YearlyReportService>((ref) {
  return YearlyReportService(ref.watch(databaseProvider));
});

class YearlyReportService {
  final AppDatabase _db;

  YearlyReportService(this._db);

  Future<AnnualReportData> generateReport(int year) async {
    final deposits = await _db.getAllDeposits();
    final goals = await _db.getAllGoals();
    final profile = await _db.getUserProfile();
    final lending = await _db.select(_db.lendingContracts).get();
    final messages = await _db.select(_db.chatMessages).get();

    final yearlyDeposits = deposits.where((d) => d.createdAt.year == year).toList();
    final totalDeposits = yearlyDeposits.fold(0, (sum, d) => sum + d.amount);
    
    final goalsCompleted = goals.where((g) => g.updatedAt.year == year && g.currentAmount >= g.targetAmount).length;
    
    final maxStreak = profile?.maxStreak ?? 0;
    
    final debtsReturned = lending.where((l) => l.isReturned && l.updatedAt.year == year).length;
    final oracleRequests = messages.where((m) => m.createdAt.year == year).length;

    // Freezer/Impulse: using current state as annual result
    final totalSavedFromImpulse = profile?.penaltyBalance ?? 0;

    final title = _generateTitle(totalDeposits, goalsCompleted, profile?.noSpendStreakCount ?? 0, debtsReturned);

    return AnnualReportData(
      year: year,
      totalDeposits: totalDeposits,
      goalsCompleted: goalsCompleted,
      maxStreak: maxStreak,
      totalSavedFromImpulse: totalSavedFromImpulse,
      debtsReturned: debtsReturned,
      oracleRequests: oracleRequests,
      title: title,
    );
  }

  String _generateTitle(int deposits, int goals, int streak, int debts) {
    if (deposits > 5000000) return "Кибер-Накопитель 2026";
    if (goals > 3) return "Охотник за Боссами";
    if (streak > 15) return "Устойчивый Разум";
    if (debts > 2) return "Феникс Дисциплины";
    return "Кибер-Исследователь";
  }
}
