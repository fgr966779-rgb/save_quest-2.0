import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'openrouter_service.dart'; // Reusing the existing API client logic

/// Analyzes team dynamics and generates structural insights using OpenRouter.
class SquadAiService {
  final OpenRouterService _openRouter;

  SquadAiService({required OpenRouterService openRouter}) : _openRouter = openRouter;

  /// Analyzes the squad's recent activity and generates a coaching insight.
  Future<String> generateSquadInsight({
    required String squadName,
    required List<Map<String, dynamic>> memberStats,
    required Map<String, dynamic> jointGoalProgress,
  }) async {
    try {
      final prompt = _buildPrompt(squadName, memberStats, jointGoalProgress);
      final response = await _openRouter.generateText(
        prompt: '''
You are "NEXUS", an elite cyberpunk AI financial coach. Your role is to analyze a team's (Squad's) performance towards their shared financial goals.
Provide short, punchy, and highly motivating insights. Use hacker/cyberpunk slang sparingly but effectively.
Format your output in clean JSON with the following structure:
{
  "insight": "The main message or observation.",
  "action_item": "A specific, actionable recommendation for the squad.",
  "vibe": "POSITIVE, WARNING, or NEUTRAL"
}
 
Squad data:
$prompt
''',
      );

      return response;
    } catch (e) {
      debugPrint('SquadAiService Error: $e');
      return jsonEncode({
        "insight": "NEXUS is temporarily offline. Syncing network...",
        "action_item": "Keep pushing forward, squad.",
        "vibe": "NEUTRAL"
      });
    }
  }

  String _buildPrompt(String squadName, List<Map<String, dynamic>> memberStats, Map<String, dynamic> jointGoalProgress) {
    return '''
Analyze the following squad data:
Squad Name: $squadName
Joint Goal Progress: \${jointGoalProgress['current']} / \${jointGoalProgress['target']}

Member Stats:
\${memberStats.map((m) => "- \${m['name']}: Saved \${m['saved']}, Active streak: \${m['streak']} days").join('\n')}

Generate a JSON insight based on this data. Focus on teamwork, highlight top contributors without putting others down, and push them towards the joint goal.
''';
  }
}
