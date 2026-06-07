import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum ProductType { console, monitor, other }

class PriceTrackerService {
  static const List<String> consoleWhitelist = [
    'click.ua', 'jey-tech.com.ua', 'game-shop.com.ua', 'jabko.ua',
    'chillistore.com.ua', 'platforma-ukraine.com.ua', 'justbuy.com.ua',
    'storeinua.com', 'tehno-bit.com.ua', 'grokholsky.com', 'istore.ua',
    'rozetka.com.ua', 'citrus.ua', 'retromagaz.com'
  ];

  static const List<String> monitorWhitelist = [
    'rozetka.com.ua', 'comfy.ua', 'allo.ua', 'elmir.ua', 'denika.ua', 
    'tv-mir.com.ua', 'deshevle-net.com.ua', 'click.ua', 'telemart.ua', 
    'itbox.ua', 'foxtrot.com.ua', 'kvshop.com.ua', 'brain.com.ua', 
    'vodafone.ua', 'ktc.ua', 'sota.store', 'compx.ua'
  ];

  static ProductType detectType(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('ps5') || lower.contains('playstation') || lower.contains('консоль')) {
      return ProductType.console;
    }
    if (lower.contains('монитор') || lower.contains('monitor') || lower.contains('display')) {
      return ProductType.monitor;
    }
    return ProductType.other;
  }

  static String? getSkuForGoal(String name, ProductType type) {
    if (type == ProductType.console) {
        final lowerName = name.toLowerCase();
        if (lowerName.contains('ps5 slim') && lowerName.contains('1tb')) return '1000040591';
        if (lowerName.contains('ps5 digital')) return '1000040594';
    }
    return null;
  }

  static Future<double?> fetchPrice(String query, {String? sku}) async {
    final apiKey = dotenv.env['SERPAPI_KEY'];
    if (apiKey == null) throw Exception('API Key not configured');

    final type = detectType(query);
    if (type == ProductType.other) return null;

    final whitelist = type == ProductType.console ? consoleWhitelist : monitorWhitelist;
    final minValidPrice = type == ProductType.console ? 15000.0 : 3000.0;
    final maxValidPrice = type == ProductType.console ? 45000.0 : 25000.0;

    final searchQuery = sku != null ? '$query $sku' : query;
    
    final url = Uri.parse(
        'https://serpapi.com/search.json?engine=google_shopping&q=${Uri.encodeComponent(searchQuery)}&location=Ukraine&gl=ua&hl=ru&api_key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) return null;

      final data = json.decode(response.body);
      final results = data['shopping_results'] as List?;
      if (results == null) return null;

      double minPrice = double.infinity;
      bool found = false;

      for (var item in results) {
        final source = item['source']?.toString().toLowerCase() ?? '';
        final link = item['link']?.toString().toLowerCase() ?? '';
        
        bool isAllowed = whitelist.any((domain) => source.contains(domain) || link.contains(domain));
        if (!isAllowed) continue;

        final priceStr = item['price']?.toString();
        if (priceStr == null) continue;

        // 1) Ignore non-UAH prices
        if (priceStr.contains(RegExp(r'(USDT|usdt|\$|€|usd)'))) continue;

        // 2) Remove spaces to normalize UAH format
        final cleanPriceStr = priceStr.replaceAll(' ', '');

        // 3) Extract ONLY the first numeric sequence preceding the UAH currency marker
        final uahMatch = RegExp(r'(\d+(?:\.\d+)?)\s*[₴грн]', caseSensitive: false).firstMatch(cleanPriceStr);
        if (uahMatch == null) continue;

        final price = double.tryParse(uahMatch.group(1) ?? '');
        if (price == null) continue;

        // 4) Strict range check
        if (price < minValidPrice || price > maxValidPrice) continue;

        if (price < minPrice) {
          minPrice = price;
          found = true;
        }
      }
      return found ? minPrice : null;
    } catch (e) {
      return null;
    }
  }
}
