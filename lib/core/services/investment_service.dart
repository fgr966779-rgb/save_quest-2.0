import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value, InsertMode;
import '../../data/database.dart';
class InvestmentService {
  final AppDatabase _db;
  static const double usdToUahRate = 42.0; // Current approx rate

  InvestmentService(this._db);

  Future<double?> getPrice(String symbol, bool isSimulation) async {
    if (isSimulation) {
      return _getSimulatedPrice(symbol);
    }

    final cached = await (_db.select(_db.marketPrices)..where((t) => t.symbol.equals(symbol))).getSingleOrNull();
    if (cached != null && DateTime.now().difference(cached.updatedAt).inHours < 4) {
      return cached.price;
    }

    return await _fetchFromApi(symbol);
  }

  Future<double?> _fetchFromApi(String symbol) async {
    final apiKey = dotenv.env['TWELVE_DATA_API_KEY'];
    final url = Uri.parse('https://api.twelvedata.com/price?symbol=$symbol&apikey=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final price = double.tryParse(data['price']);
        if (price != null) {
          final priceInUah = price * usdToUahRate;
          await _db.into(_db.marketPrices).insert(
            MarketPricesCompanion.insert(symbol: symbol, price: priceInUah, currency: 'UAH', updatedAt: DateTime.now()),
            mode: InsertMode.insertOrReplace,
          );
          return priceInUah;
        }
      }
    } catch (e) {
      // Log error
    }
    return null;
  }

  double _getSimulatedPrice(String symbol) {
    final basePrices = <String, double>{
      'BTC': 2800000.0,
      'ETH': 140000.0,
      'SPY': 20000.0,
      'AAPL': 8000.0,
    };
    final base = basePrices[symbol] ?? 5000.0;
    final variance = (Random().nextDouble() - 0.5) * 0.1 * base;
    return base + variance;
  }

  Future<void> checkAndAwardXP(WidgetRef ref, bool isSimulation) async {
    if (isSimulation) return;
    
    final profile = await _db.getUserProfile();
    if (profile == null) return;
    
    final portfolio = await _db.select(_db.investmentPortfolio).get();
    final now = DateTime.now();

    // 1. Diversification Check (+10 XP)
    if (portfolio.length >= 3 && 
        (profile.lastDiversificationXPDate == null || profile.lastDiversificationXPDate!.day != now.day)) {
      
      await _db.updateUserProfile(profile.copyWith(
        xp: profile.xp + 10,
        lastDiversificationXPDate: Value(now),
      ));
      if (kDebugMode) debugPrint("XP awarded: Diversification (+10) | Date: ${now.toIso8601String()}");
      
      // Need a way to signal UI for Snackbar
    }
  }

  Future<void> checkAndAwardRebalanceXP(WidgetRef ref, List<InvestmentPortfolioData> portfolio, bool isSimulation) async {
    if (isSimulation) return;
    
    final profile = await _db.getUserProfile();
    if (profile == null) return;
    
    final now = DateTime.now();
    final totalValue = portfolio.fold(0.0, (sum, item) => sum + (item.amountOwned * item.averageBuyPrice));
    
    bool isBalanced = portfolio.every((item) => (item.amountOwned * item.averageBuyPrice) / totalValue <= 0.5);
    
    if (isBalanced && 
        (profile.lastRebalanceXPDate == null || now.difference(profile.lastRebalanceXPDate!).inHours >= 6)) {
      
      await _db.updateUserProfile(profile.copyWith(
        xp: profile.xp + 20,
        lastRebalanceXPDate: Value(now),
      ));
      if (kDebugMode) debugPrint("XP awarded: Rebalancing (+20) | Date: ${now.toIso8601String()}");
    }
  }

  Future<void> resetXPTimers() async {
    final profile = await _db.getUserProfile();
    if (profile == null) return;
    await _db.updateUserProfile(profile.copyWith(
      lastDiversificationXPDate: const Value(null),
      lastRebalanceXPDate: const Value(null),
    ));
  }
}
