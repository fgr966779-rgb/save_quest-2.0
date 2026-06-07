// FILE: lib/core/services/nbu_currency_service.dart
//
// Fetches the official UAH/USD exchange rate from the National Bank of Ukraine.
// ─ Free, no API key required.
// ─ NBU updates rates once per day → TTL cache of 24 hours stored in Drift.
// ─ Never blocks the UI: always returns a valid rate (cached or fallback).
//
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../data/database.dart';
import '../providers/providers.dart';

/// Fallback exchange rate (UAH per 1 USD) used when NBU is unreachable
/// and no cached value is available.
const double kNbuFallbackRate = 41.5;

/// Official NBU exchange API — free, no auth required.
const String _kNbuApiUrl =
    'https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json';

/// NBU USD currency code identifier in the response.
const String _kUsdCode = 'USD';

/// Cache duration: NBU publishes new rates once per business day.
const Duration _kCacheTtl = Duration(hours: 24);

/// Cached exchange rate entry stored in [MarketPrices] table.
/// Symbol key: 'NBU_USD_UAH'
const String _kNbuCacheKey = 'NBU_USD_UAH';

class NbuCurrencyService {
  NbuCurrencyService(this._db);

  final AppDatabase _db;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Returns the current UAH/USD rate.
  ///
  /// Resolution order:
  ///   1. Valid Drift cache (< 24 h old) → instant, no network.
  ///   2. NBU API (online) → updates cache.
  ///   3. Stale Drift cache (any age) → last known good value.
  ///   4. [kNbuFallbackRate] → hardcoded safety net.
  ///
  /// Never throws. The UI should always receive a usable value.
  Future<NbuRateResult> getUsdToUahRate() async {
    // 1. Fresh cache hit
    final cached = await _readCache();
    if (cached != null && _isFresh(cached.updatedAt)) {
      return NbuRateResult(
        rate: cached.price,
        source: NbuRateSource.cache,
        updatedAt: cached.updatedAt,
      );
    }

    // 2. Network fetch
    try {
      final rate = await _fetchFromNbu();
      if (rate != null) {
        await _writeCache(rate);
        return NbuRateResult(
          rate: rate,
          source: NbuRateSource.live,
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      debugPrint('[NbuCurrencyService] Network error: $e');
    }

    // 3. Stale cache — better than nothing
    if (cached != null) {
      return NbuRateResult(
        rate: cached.price,
        source: NbuRateSource.staleCache,
        updatedAt: cached.updatedAt,
      );
    }

    // 4. Hardcoded fallback
    return NbuRateResult(
      rate: kNbuFallbackRate,
      source: NbuRateSource.fallback,
      updatedAt: null,
    );
  }

  /// Converts [usdAmount] to UAH using the current cached or live rate.
  /// Gracefully falls back to [kNbuFallbackRate] if rate fetch fails.
  Future<double> usdToUah(double usdAmount) async {
    final result = await getUsdToUahRate();
    return usdAmount * result.rate;
  }

  /// Converts kopecks (UAH minor units) to approximate USD cents.
  Future<double> kopecksToUsd(int kopecks) async {
    final result = await getUsdToUahRate();
    return kopecks / 100 / result.rate;
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<MarketPrice?> _readCache() async {
    return (
      _db.select(_db.marketPrices)
        ..where((t) => t.symbol.equals(_kNbuCacheKey))
    ).getSingleOrNull();
  }

  bool _isFresh(DateTime updatedAt) =>
      DateTime.now().difference(updatedAt) < _kCacheTtl;

  Future<void> _writeCache(double rate) async {
    await _db.into(_db.marketPrices).insertOnConflictUpdate(
          MarketPricesCompanion.insert(
            symbol: _kNbuCacheKey,
            price: rate,
            currency: 'UAH',
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<double?> _fetchFromNbu() async {
    final response = await http
        .get(Uri.parse(_kNbuApiUrl))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) return null;

    final list = jsonDecode(response.body) as List<dynamic>;
    for (final item in list) {
      if (item is Map && item['cc'] == _kUsdCode) {
        final rate = (item['rate'] as num?)?.toDouble();
        if (rate != null && rate > 0) return rate;
      }
    }
    return null;
  }
}

// ── Result model ──────────────────────────────────────────────────────────────

enum NbuRateSource {
  /// Data served from Drift cache (<24 h).
  cache,

  /// Freshly fetched from NBU API.
  live,

  /// Drift cache exists but older than 24 h (network unavailable).
  staleCache,

  /// Hardcoded constant — no cache, no network.
  fallback,
}

class NbuRateResult {
  const NbuRateResult({
    required this.rate,
    required this.source,
    required this.updatedAt,
  });

  final double rate;
  final NbuRateSource source;

  /// When null the rate comes from the hardcoded fallback.
  final DateTime? updatedAt;

  bool get isLive => source == NbuRateSource.live;
  bool get isFallback => source == NbuRateSource.fallback;

  /// Human-readable freshness label shown in the UI (Ukrainian).
  String get freshnessLabel {
    switch (source) {
      case NbuRateSource.live:
        return '● Актуальний курс НБУ';
      case NbuRateSource.cache:
        return '● Курс НБУ (кеш)';
      case NbuRateSource.staleCache:
        final dt = updatedAt;
        if (dt == null) return '⚠ Застарілий курс';
        final h = dt.hour.toString().padLeft(2, '0');
        final m = dt.minute.toString().padLeft(2, '0');
        return '⚠ Курс актуальний на $h:$m';
      case NbuRateSource.fallback:
        return '⚠ Fallback: 41.5 грн/USD';
    }
  }
}

// ── Riverpod provider ─────────────────────────────────────────────────────────

final nbuCurrencyServiceProvider = Provider<NbuCurrencyService>((ref) {
  return NbuCurrencyService(ref.watch(databaseProvider));
});
