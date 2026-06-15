import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

/// AI Coach personality modes available to the user.
enum CoachPersonality {
  hacker,
  analyst,
  enthusiast,
}

extension CoachPersonalityExt on CoachPersonality {
  String get key {
    switch (this) {
      case CoachPersonality.hacker:     return 'hacker';
      case CoachPersonality.analyst:    return 'analyst';
      case CoachPersonality.enthusiast: return 'enthusiast';
    }
  }

  String get displayName {
    switch (this) {
      case CoachPersonality.hacker:     return '🏴‍☠️ Цинічний Хакер';
      case CoachPersonality.analyst:    return '👔 Корпоративний Аналітик';
      case CoachPersonality.enthusiast: return '🌈 ШІ-Ентузіаст';
    }
  }

  static CoachPersonality fromKey(String key) {
    switch (key) {
      case 'analyst':    return CoachPersonality.analyst;
      case 'enthusiast': return CoachPersonality.enthusiast;
      default:           return CoachPersonality.hacker;
    }
  }

  String get systemPrompt {
    switch (this) {
      case CoachPersonality.hacker:
        return '''
Ти — ШІ-асистент кіберпанк-скарбнички "Piggy Vault".
Твоє ім'я — VAULT-17. Твій тон — іронічний, футуристичний, по-дружньому агресивний.
Ти говориш як вуличний хакер з 2077 року. Мова — українська, із сленгом.
Аналізуєш фінансові транзакції і даєш поради щодо заощаджень.
Відповідай КОРОТКО — максимум 2 речення. Без зайвих пояснень.
Використовуй терміни: "кредити", "Сховище", "чумба", "прошивка", "апгрейд балансу".
Завжди пропонуй конкретну дію — відкласти певну суму.
''';
      case CoachPersonality.analyst:
        return '''
Ти — ШІ-фінансовий аналітик системи "Piggy Vault". 
Твоє ім'я — UNIT-A. Тон: холодний, стриманий, орієнтований на дані.
Звертайся до користувача на "Ви". Мова — українська, офіційна.
Аналізуєш транзакції крізь призму ROI, ліквідності та фінансової дисципліни.
Відповідай КОРОТКО — максимум 2 речення. Оперуй числами та відсотками.
Уникай емоцій. Завжди пропонуй конкретний відсоток або суму до відкладення.
''';
      case CoachPersonality.enthusiast:
        return '''
Ти — надпозитивний ШІ-помічник "Piggy Vault" на ім'я SPARK! 🌟
Твій тон — захоплений, мотивуючий, із великою кількістю смайлів та кіберемодзі.
Мова — українська, дружня, зменшувально-пестливе звернення "шкіряний мішку 😊".
Аналізуєш транзакції і бачиш у кожній витраті МОЖЛИВІСТЬ для зростання! 🚀
Відповідай КОРОТКО — максимум 2 речення. Використовуй 🔥💰✨🤖 в кожному реченні.
Завжди пропонуй конкретну суму — і роби це максимально радісно!
''';
    }
  }
}

/// Service to communicate with OpenRouter API (DeepSeek V4 Flash model).
/// Falls back gracefully if API key is missing or request fails.
class OpenRouterService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String _model = 'deepseek/deepseek-chat-v3-5:free';

  final String apiKey;
  final CoachPersonality personality;

  OpenRouterService({required this.apiKey, this.personality = CoachPersonality.hacker});

  bool get isAvailable => apiKey.trim().isNotEmpty;

  /// Generates a cyber-coach comment for a given transaction.
  /// Returns null if unavailable or request fails.
  Future<String?> generateInsight({
    required String transactionTitle,
    required String transactionCategory,
    required double transactionAmount,
  }) async {
    if (!isAvailable) return null;

    final coachName = personality == CoachPersonality.analyst ? 'UNIT-A' 
        : personality == CoachPersonality.enthusiast ? 'SPARK' 
        : 'VAULT-17';

    final userMessage =
        'Транзакція: "$transactionTitle" (категорія: $transactionCategory). '
        'Сума: ${transactionAmount.toStringAsFixed(2)} грн. '
        'Дай мені пораду про заощадження у стилі $coachName.';

    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
              'HTTP-Referer': 'https://piggyvault.app',
              'X-Title': 'PiggyVault Savings',
            },
            body: jsonEncode({
              'model': _model,
              'messages': [
                {'role': 'system', 'content': personality.systemPrompt},
                {'role': 'user', 'content': userMessage},
              ],
              'max_tokens': 120,
              'temperature': 0.9,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices']?[0]?['message']?['content'] as String?;
        return content?.trim();
      } else {
        // ignore: avoid_print
        print('[OpenRouter] Error $1: $1');
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print('[OpenRouter] Request failed: $e');
      return null;
    }
  }

  Future<String> generateText({required String prompt}) async {
    if (!isAvailable) throw Exception('OpenRouter API Key not set');

    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
            'HTTP-Referer': 'https://piggyvault.app',
            'X-Title': 'PiggyVault Savings',
          },
          body: jsonEncode({
            'model': _model,
            'messages': [
              {'role': 'user', 'content': prompt},
            ],
            'max_tokens': 200,
            'temperature': 0.8,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices']?[0]?['message']?['content'] as String?;
      return content?.trim() ?? '';
    } else {
      throw Exception('OpenRouter Error $1: $1');
    }
  }

  /// Chat completion for multi-turn conversation (Oracle / AI Chat).
  /// Tries [_model] first; if that fails (non-200), retries with fallback model.
  static const String _fallbackModel = 'google/gemma-4-31b-it:free';

  Future<String> getChatCompletion(List<Map<String, String>> messages) async {
    if (!isAvailable) throw Exception('OpenRouter API Key not set');
    try {
      return await _chatRequest(messages, _model);
    } catch (_) {
      return await _chatRequest(messages, _fallbackModel);
    }
  }

  Future<String> _chatRequest(
      List<Map<String, String>> messages, String model) async {
    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
            'HTTP-Referer': 'https://piggyvault.app',
            'X-Title': 'PiggyVault Oracle',
          },
          body: jsonEncode({
            'model': model,
            'messages': messages,
          }),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception(
          'OpenRouter Error $1: $1');
    }
  }
}

final openRouterProvider = Provider<OpenRouterService>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  return OpenRouterService(
    apiKey: settings.openRouterApiKey,
    personality: CoachPersonalityExt.fromKey(settings.coachPersonality),
  );
});
