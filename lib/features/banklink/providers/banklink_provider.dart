import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/database.dart';

class BankLinkState {
  final BankSyncConfig? activeConfig;
  final List<AutoDeposit> activeRules;
  final bool isSyncing;
  final List<MockTransaction> recentTransactions;
  final int calculatedRoundUp; // in kopecks

  BankLinkState({
    this.activeConfig,
    this.activeRules = const [],
    this.isSyncing = false,
    this.recentTransactions = const [],
    this.calculatedRoundUp = 0,
  });

  BankLinkState copyWith({
    BankSyncConfig? activeConfig,
    List<AutoDeposit>? activeRules,
    bool? isSyncing,
    List<MockTransaction>? recentTransactions,
    int? calculatedRoundUp,
  }) {
    return BankLinkState(
      activeConfig: activeConfig ?? this.activeConfig,
      activeRules: activeRules ?? this.activeRules,
      isSyncing: isSyncing ?? this.isSyncing,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      calculatedRoundUp: calculatedRoundUp ?? this.calculatedRoundUp,
    );
  }
}

class MockTransaction {
  final String description;
  final int amountKopecks;
  final String category;

  MockTransaction(this.description, this.amountKopecks, this.category);
}

final bankLinkProvider = StateNotifierProvider<BankLinkNotifier, BankLinkState>((ref) {
  final db = ref.watch(databaseProvider);
  return BankLinkNotifier(db);
});



class BankLinkNotifier extends StateNotifier<BankLinkState> {
  final AppDatabase _db;

  BankLinkNotifier(this._db) : super(BankLinkState()) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    final configs = await _db.select(_db.bankSyncConfigs).get();
    BankSyncConfig? config = configs.isNotEmpty ? configs.first : null;

    final rules = await _db.select(_db.autoDeposits).get();

    state = state.copyWith(activeConfig: config, activeRules: rules);
  }

  Future<void> connectProvider(String providerName) async {
    state = state.copyWith(isSyncing: true);
    await Future.delayed(const Duration(seconds: 2));

    final newConfig = BankSyncConfig(
      id: 0,
      provider: providerName,
      status: 'connected',
      maskedAccount: '**** 1234',
      lastSyncAt: DateTime.now(),
      roundUpEnabled: false,
    );

    // Replace old config if any
    await _db.delete(_db.bankSyncConfigs).go();
    await _db.into(_db.bankSyncConfigs).insert(newConfig);

    await _loadInitialState();
    state = state.copyWith(isSyncing: false);
    _generateMockTransactions();
  }

  void _generateMockTransactions() {
    final txs = [
      MockTransaction('Сільпо', 45050, 'Groceries'), // 450.50 UAH -> Round up to 451.00 -> 0.50 UAH
      MockTransaction('Кав\'ярня', 6500, 'Food'), // 65.00 -> 0.00
      MockTransaction('Uber', 13240, 'Transport'), // 132.40 -> 0.60 UAH
    ];

    int roundUp = 0;
    for (var tx in txs) {
      int amount = tx.amountKopecks;
      int nextHundred = ((amount / 100).ceil()) * 100;
      if (nextHundred > amount) {
        roundUp += (nextHundred - amount);
      }
    }

    state = state.copyWith(recentTransactions: txs, calculatedRoundUp: roundUp);
  }

  Future<void> toggleRoundUp(bool enabled) async {
    if (state.activeConfig != null) {
      final updated = state.activeConfig!.copyWith(roundUpEnabled: enabled);
      await _db.update(_db.bankSyncConfigs).replace(updated);
      await _loadInitialState();
    }
  }

  Future<void> syncNow() async {
    state = state.copyWith(isSyncing: true);
    await Future.delayed(const Duration(seconds: 2));
    
    if (state.activeConfig != null) {
      final updated = state.activeConfig!.copyWith(lastSyncAt: drift.Value(DateTime.now()));
      await _db.update(_db.bankSyncConfigs).replace(updated);
    }
    
    _generateMockTransactions();
    await _loadInitialState();
    state = state.copyWith(isSyncing: false);
  }
}
