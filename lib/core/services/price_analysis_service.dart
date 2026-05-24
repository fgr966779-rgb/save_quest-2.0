import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'openrouter_service.dart';

class PriceQuote {
  final String store;
  final int priceKopecks;
  final String? url;

  const PriceQuote({
    required this.store,
    required this.priceKopecks,
    this.url,
  });
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
  final OpenRouterService openRouter;

  PriceAnalysisService(this.openRouter);

  static const Map<String, List<_FallbackPrice>> _fallbackCatalog = {
    'ps5': [
      _FallbackPrice('Rozetka', 2199900),
      _FallbackPrice('Comfy', 2249900),
      _FallbackPrice('Allo', 2189900),
      _FallbackPrice('Foxtrot', 2299900),
      _FallbackPrice('Hotline (avg)', 2150000),
    ],
    'playstation 5': [
      _FallbackPrice('Rozetka', 2199900),
      _FallbackPrice('Comfy', 2249900),
      _FallbackPrice('Allo', 2189900),
      _FallbackPrice('Foxtrot', 2299900),
    ],
    'playstation': [
      _FallbackPrice('Rozetka', 2199900),
      _FallbackPrice('Comfy', 2249900),
      _FallbackPrice('Allo', 2189900),
    ],
    'xbox': [
      _FallbackPrice('Rozetka', 1799900),
      _FallbackPrice('Comfy', 1849900),
      _FallbackPrice('Allo', 1779900),
    ],
    'монітор': [
      _FallbackPrice('Rozetka', 899900),
      _FallbackPrice('Comfy', 949900),
      _FallbackPrice('Allo', 879900),
      _FallbackPrice('Foxtrot', 929900),
    ],
    'monitor': [
      _FallbackPrice('Rozetka', 899900),
      _FallbackPrice('Comfy', 949900),
      _FallbackPrice('Allo', 879900),
      _FallbackPrice('Foxtrot', 929900),
    ],
    'ноутбук': [
      _FallbackPrice('Rozetka', 2999900),
      _FallbackPrice('Comfy', 3149900),
      _FallbackPrice('Allo', 2899900),
    ],
    'iphone': [
      _FallbackPrice('Rozetka', 4599900),
      _FallbackPrice('Comfy', 4699900),
      _FallbackPrice('Allo', 4549900),
    ],
    'macbook': [
      _FallbackPrice('Rozetka', 5999900),
      _FallbackPrice('Comfy', 6149900),
      _FallbackPrice('Allo', 5899900),
    ],
  };

  Future<PriceAnalysis> analyze(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Назва товару не може бути порожньою');
    }

    if (openRouter.isAvailable) {
      try {
        final aiResult = await _analyzeWithAi(trimmed);
        if (aiResult != null) return aiResult;
      } catch (_) {
        // fall through to offline catalog
      }
    }

    return _analyzeOffline(trimmed);
  }

  Future<PriceAnalysis?> _analyzeWithAi(String query) async {
    final prompt = '''
Ти — аналітик цін українського ринку електроніки.
Поверни JSON з оцінкою поточних цін на товар "$query" у магазинах України (Rozetka, Comfy, Allo, Foxtrot, Hotline).
Формат відповіді — ТІЛЬКИ валідний JSON без додаткового тексту:
{
  "quotes": [
    {"store": "Rozetka", "price_uah": 21999},
    {"store": "Comfy", "price_uah": 22499}
  ],
  "recommendation": "коротка порада українською (1 речення)"
}
Усі ціни — цілі числа гривень без копійок. Мінімум 3 магазини.
''';

    final raw = await openRouter.generateText(prompt: prompt);
    final jsonText = _extractJson(raw);
    if (jsonText == null) return null;

    final decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, dynamic>) return null;

    final rawQuotes = decoded['quotes'];
    if (rawQuotes is! List || rawQuotes.isEmpty) return null;

    final quotes = <PriceQuote>[];
    for (final entry in rawQuotes) {
      if (entry is! Map) continue;
      final store = entry['store']?.toString();
      final priceUah = entry['price_uah'];
      if (store == null || store.isEmpty) continue;
      final priceKopecks = _toKopecks(priceUah);
      if (priceKopecks == null) continue;
      quotes.add(PriceQuote(store: store, priceKopecks: priceKopecks));
    }
    if (quotes.isEmpty) return null;

    final recommendation = decoded['recommendation']?.toString().trim() ??
        'Перевірте кілька магазинів перед покупкою.';

    return _buildAnalysis(
      query: query,
      quotes: quotes,
      recommendation: recommendation,
      isEstimate: false,
    );
  }

  PriceAnalysis _analyzeOffline(String query) {
    final lower = query.toLowerCase();
    List<_FallbackPrice>? match;
    for (final entry in _fallbackCatalog.entries) {
      if (lower.contains(entry.key)) {
        match = entry.value;
        break;
      }
    }

    final quotes = (match ?? _genericFallback(query))
        .map((f) => PriceQuote(store: f.store, priceKopecks: f.priceKopecks))
        .toList();

    final recommendation = match != null
        ? 'Орієнтуйтесь на найнижчу ціну, але звіряйте наявність та умови гарантії.'
        : 'Точна ціна для цього товару не знайдена офлайн — введіть API-ключ OpenRouter у налаштуваннях для ШІ-аналізу.';

    return _buildAnalysis(
      query: query,
      quotes: quotes,
      recommendation: recommendation,
      isEstimate: true,
    );
  }

  List<_FallbackPrice> _genericFallback(String query) {
    final seed = query.codeUnits.fold<int>(0, (a, b) => a + b);
    final base = 500000 + (seed % 80) * 25000; // 5 000 — 25 000 грн
    return [
      _FallbackPrice('Rozetka', base),
      _FallbackPrice('Comfy', (base * 1.04).round()),
      _FallbackPrice('Allo', (base * 0.97).round()),
      _FallbackPrice('Foxtrot', (base * 1.06).round()),
    ];
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
    final avg =
        sorted.map((q) => q.priceKopecks).reduce((a, b) => a + b) ~/ sorted.length;

    return PriceAnalysis(
      query: query,
      minPriceKopecks: min,
      avgPriceKopecks: avg,
      maxPriceKopecks: max,
      quotes: sorted,
      recommendation: recommendation,
      isEstimate: isEstimate,
    );
  }

  String? _extractJson(String raw) {
    final start = raw.indexOf('{');
    final end = raw.lastIndexOf('}');
    if (start < 0 || end <= start) return null;
    return raw.substring(start, end + 1);
  }

  int? _toKopecks(dynamic value) {
    if (value is num) return (value * 100).round();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
      final parsed = double.tryParse(cleaned);
      if (parsed == null) return null;
      return (parsed * 100).round();
    }
    return null;
  }
}

class _FallbackPrice {
  final String store;
  final int priceKopecks;
  const _FallbackPrice(this.store, this.priceKopecks);
}

final priceAnalysisServiceProvider = Provider<PriceAnalysisService>((ref) {
  final openRouter = ref.watch(openRouterProvider);
  return PriceAnalysisService(openRouter);
});
