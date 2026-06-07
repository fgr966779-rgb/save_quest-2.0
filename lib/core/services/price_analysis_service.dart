import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

enum DealClassification {
  bestDeal, // 🔥 < -10%
  marketPrice, // ✅ ±10%
  overpriced, // ⚠ > 10%
}

DealClassification classifyDeal(int priceKopecks, int avgPriceKopecks) {
  if (avgPriceKopecks == 0) return DealClassification.marketPrice;
  final ratio = (priceKopecks - avgPriceKopecks) / avgPriceKopecks;
  if (ratio <= -0.10) return DealClassification.bestDeal;
  if (ratio >= 0.10) return DealClassification.overpriced;
  return DealClassification.marketPrice;
}

class PriceTargetPreset {
  final String id;
  final String label;
  final String query;
  final String hint;

  const PriceTargetPreset({
    required this.id,
    required this.label,
    required this.query,
    required this.hint,
  });
}

const List<PriceTargetPreset> supportedPriceTargets = [
  PriceTargetPreset(
    id: 'ps5',
    label: 'PS5',
    query: 'PlayStation 5 console',
    hint: 'Current console market prices',
  ),
  PriceTargetPreset(
    id: 'monitor_27',
    label: 'Monitor 27"',
    query: '27 inch monitor',
    hint: 'Popular 27-inch displays',
  ),
  PriceTargetPreset(
    id: 'gaming_monitor',
    label: 'Gaming monitor',
    query: 'gaming monitor',
    hint: 'High refresh-rate gaming screens',
  ),
];

class PriceQuote {
  final String store;
  final int priceKopecks;
  final String title;
  final String? url;
  final String? thumbnail;
  final String? rating;
  final String? delivery;

  const PriceQuote({
    required this.store,
    required this.priceKopecks,
    required this.title,
    this.url,
    this.thumbnail,
    this.rating,
    this.delivery,
  });

  DealClassification getClassification(int avgPriceKopecks) {
    return classifyDeal(priceKopecks, avgPriceKopecks);
  }
}

class PriceAnalysis {
  final String query;
  final int minPriceKopecks;
  final int avgPriceKopecks;
  final int maxPriceKopecks;
  final List<PriceQuote> quotes;
  final String recommendation;
  final bool isEstimate;

  const PriceAnalysis({
    required this.query,
    required this.minPriceKopecks,
    required this.avgPriceKopecks,
    required this.maxPriceKopecks,
    required this.quotes,
    required this.recommendation,
    required this.isEstimate,
  });

  int get spreadKopecks => maxPriceKopecks - minPriceKopecks;
  double get spreadRatio =>
      avgPriceKopecks <= 0 ? 0 : spreadKopecks / avgPriceKopecks;
}

class PriceAnalysisService {
  PriceAnalysisService();

  String get _serpApiKey => dotenv.env['SERPAPI_KEY'] ?? '';
  bool get _hasLiveApiKey =>
      _serpApiKey.isNotEmpty && !_serpApiKey.startsWith('YOUR_');

  static const List<String> _uaStores = [
    'Rozetka',
    'Comfy',
    'Allo',
    'Foxtrot',
    'MOYO',
    'Citrus',
    'Epicentr',
    'KTC',
    'Telemart',
    'Brain',
    'ITbox',
    'F.ua',
    'Hotline',
    'E-Katalog',
    'TTT',
    'Y.ua',
    'Stylus',
    'Touch',
    'MTA',
  ];

  static Map<String, List<_FallbackPrice>> _generateFallbackCatalog() {
    return {
      'ps5': _generateStoresForBase(2_150_000), // ~21 500 UAH
      'playstation 5': _generateStoresForBase(2_150_000),
      'playstation': _generateStoresForBase(2_150_000),
      'монітор': _generateStoresForBase(850_000), // ~8 500 UAH
      'monitor': _generateStoresForBase(850_000),
      'gaming monitor': _generateStoresForBase(1_250_000),
      '27 inch monitor': _generateStoresForBase(950_000),
    };
  }

  static List<_FallbackPrice> _generateStoresForBase(
    int baseKopecks, {
    int seed = 0,
  }) {
    final rotation = seed.abs() % _uaStores.length;
    final stores = [
      ..._uaStores.skip(rotation),
      ..._uaStores.take(rotation),
    ];

    return stores.asMap().entries.map((entry) {
      final i = entry.key;
      final store = entry.value;
      // Deterministic spread with a small seed-based wobble so demo prices do
      // not look frozen when live data is unavailable.
      final variation = (((i * 7) + seed) % 31 - 14) / 100.0;
      final price = (baseKopecks * (1 + variation)).round();
      return _FallbackPrice(store, price);
    }).toList();
  }

  late final Map<String, List<_FallbackPrice>> _fallbackCatalog =
      _generateFallbackCatalog();

  bool _isAllowedQuery(String query) {
    // Phase 1: allow any product query for the Price Pulse feature.
    return true;
  }

  String _normalizeQuery(String query) {
    final lower = query.toLowerCase();

    if (lower.contains('ps5') || lower.contains('playstation')) {
      return 'PlayStation 5 console';
    }

    if (lower.contains('samsung odyssey')) {
      return 'Samsung Odyssey monitor';
    }
    if (lower.contains('lg ultragear')) {
      return 'LG UltraGear monitor';
    }
    if (lower.contains('asus tuf')) {
      return 'ASUS TUF Gaming monitor';
    }
    if (lower.contains('gaming monitor')) {
      return 'gaming monitor';
    }
    if (lower.contains('27') &&
        (lower.contains('monitor') || lower.contains('монітор'))) {
      return '27 inch monitor';
    }
    if (lower.contains('monitor') || lower.contains('монітор')) {
      return '27 inch monitor';
    }

    return query;
  }

  Future<PriceAnalysis> analyze(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Назва товару не може бути порожньою');
    }

    if (!_isAllowedQuery(trimmed)) {
      throw ArgumentError(
        'Недостатньо ринкових даних',
      );
    }

    final normalizedQuery = _normalizeQuery(trimmed);

    try {
      final proxyResult = await _fetchFromLocalProxy(normalizedQuery);
      if (proxyResult != null) return proxyResult;

      final apiResult = await _fetchFromSerpApi(normalizedQuery);
      if (apiResult != null) return apiResult;
    } catch (_) {
      // API error, fall back to offline mode.
    }

    return _analyzeOffline(trimmed);
  }

  Future<PriceAnalysis?> _fetchFromLocalProxy(String query) async {
    try {
      final url = Uri.http('127.0.0.1:8080', '/price-analysis', {
        'query': query,
        'engine': 'google_shopping',
        'gl': 'ua',
        'hl': 'uk',
        'num': '10',
      });

      final response = await http.get(url).timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) {
        return null;
      }

      return _parseSerpApiPayload(query, response.body);
    } catch (_) {
      return null;
    }
  }

  Future<PriceAnalysis?> _fetchFromSerpApi(String query) async {
    if (!_hasLiveApiKey) {
      return null;
    }

    final url = Uri.https('serpapi.com', '/search.json', {
      'engine': 'google_shopping',
      'q': query,
      'gl': 'ua',
      'hl': 'uk',
      'num': '10',
      'api_key': _serpApiKey,
    });
    final response = await http.get(url).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      return null;
    }

    return _parseSerpApiPayload(query, response.body);
  }

  PriceAnalysis? _parseSerpApiPayload(String query, String body) {
    final data = jsonDecode(body);
    final shoppingResults = data['shopping_results'];
    if (shoppingResults is! List || shoppingResults.isEmpty) {
      return null;
    }

    final quotes = <PriceQuote>[];
    final seen = <String>{};

    for (final item in shoppingResults) {
      if (item is! Map) continue;

      final title = item['title']?.toString().trim();
      final storeRaw = item['source']?.toString().trim() ??
          item['seller']?.toString().trim() ??
          item['merchant']?.toString().trim() ??
          item['store']?.toString().trim();
      final priceRaw =
          item['extracted_price'] ?? item['price'] ?? item['price_value'];
      if (title == null || title.isEmpty || priceRaw == null) continue;

      final priceKopecks = _toKopecks(priceRaw);
      if (priceKopecks == null) continue;

      final store = _normalizeStoreName(storeRaw ?? 'Marketplace');
      final quoteKey = '$store|$title|$priceKopecks';
      if (!seen.add(quoteKey)) continue;

      quotes.add(
        PriceQuote(
          store: store,
          priceKopecks: priceKopecks,
          title: title,
          url: item['link']?.toString(),
          thumbnail: item['thumbnail']?.toString(),
          rating: item['rating']?.toString(),
          delivery: item['delivery']?.toString(),
        ),
      );
    }

    if (quotes.isEmpty) return null;

    return _buildAnalysis(
      query: query,
      quotes: quotes,
      recommendation: 'Live market prices loaded via SerpAPI Google Shopping.',
      isEstimate: false,
    );
  }

  PriceAnalysis _analyzeOffline(String query) {
    final lower = query.toLowerCase();
    final timeSeed = DateTime.now().millisecondsSinceEpoch ~/
        const Duration(minutes: 15).inMilliseconds;
    List<_FallbackPrice>? match;
    for (final entry in _fallbackCatalog.entries) {
      if (lower.contains(entry.key)) {
        match = entry.value;
        break;
      }
    }

    final fallbackQuotes =
        (match ?? _genericFallback(query)).asMap().entries.map((entry) {
      final item = entry.value;
      final wobble = (((timeSeed + entry.key * 5) % 9) - 4) / 100.0;
      return _FallbackPrice(
        item.store,
        (item.priceKopecks * (1 + wobble)).round(),
      );
    }).toList();
    final quotes = fallbackQuotes
        .map(
          (f) => PriceQuote(
            store: f.store,
            priceKopecks: f.priceKopecks,
            title: query,
          ),
        )
        .toList();

    final recommendation = match != null
        ? 'Demo fallback only. Start remote_server and keep SERPAPI_KEY in .env for live market prices.'
        : 'Exact market price was not found offline — this is only a demo estimate.';

    return _buildAnalysis(
      query: query,
      quotes: quotes,
      recommendation: recommendation,
      isEstimate: true,
    );
  }

  List<_FallbackPrice> _genericFallback(String query) {
    final seed = query.codeUnits.fold<int>(0, (a, b) => a + b);
    final base = 500_000 + (seed % 80) * 25_000;
    return _generateStoresForBase(base, seed: seed);
  }

  PriceAnalysis _buildAnalysis({
    required String query,
    required List<PriceQuote> quotes,
    required String recommendation,
    required bool isEstimate,
  }) {
    final sorted = [...quotes]
      ..sort((a, b) => a.priceKopecks.compareTo(b.priceKopecks));
    final min = sorted.first.priceKopecks;
    final max = sorted.last.priceKopecks;
    final avg = sorted.map((q) => q.priceKopecks).reduce((a, b) => a + b) ~/
        sorted.length;

    return PriceAnalysis(
      query: query,
      minPriceKopecks: min,
      avgPriceKopecks: avg,
      maxPriceKopecks: max,
      quotes: sorted.take(12).toList(),
      recommendation: recommendation,
      isEstimate: isEstimate,
    );
  }

  int? _toKopecks(dynamic value) {
    if (value is num) return (value * 100).round();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
      if (cleaned.isEmpty) return null;
      final parsed = double.tryParse(cleaned);
      if (parsed == null) return null;
      return (parsed * 100).round();
    }
    return null;
  }

  String _normalizeStoreName(String storeRaw) {
    final lower = storeRaw.toLowerCase();
    for (final store in _uaStores) {
      if (lower.contains(store.toLowerCase())) {
        return store;
      }
    }

    final trimmed = storeRaw.trim();
    return trimmed.isEmpty ? 'Marketplace' : trimmed;
  }
}

class _FallbackPrice {
  final String store;
  final int priceKopecks;

  const _FallbackPrice(this.store, this.priceKopecks);
}

final priceAnalysisServiceProvider = Provider<PriceAnalysisService>((ref) {
  return PriceAnalysisService();
});
