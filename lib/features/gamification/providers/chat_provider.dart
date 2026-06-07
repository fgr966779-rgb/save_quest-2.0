import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import '../../../core/services/openrouter_service.dart';
import '../../../core/providers/l10n.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    required this.messages,
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final AppDatabase _db;
  final OpenRouterService _aiService;
  final Ref _ref;

  ChatNotifier(this._db, this._aiService, this._ref)
      : super(ChatState(messages: [])) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    state = state.copyWith(isLoading: true);
    try {
      final messages = await (_db.select(_db.chatMessages)
            ..orderBy([(t) => drift.OrderingTerm.asc(t.createdAt)]))
          .get();
      state = state.copyWith(messages: messages, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final userMsg = ChatMessagesCompanion.insert(
      role: 'user',
      content: content,
    );

    try {
      await _db.into(_db.chatMessages).insert(userMsg);
      await _loadMessages();

      state = state.copyWith(isLoading: true, error: null);

      final locale = _ref.read(localeProvider);
      final systemPrompt = AppLocalizations.get(locale, 'oracle_system_prompt');

      final apiMessages = [
        {'role': 'system', 'content': systemPrompt},
        ...state.messages.map((m) => {'role': m.role, 'content': m.content}),
      ];

      final aiResponse = await _aiService.getChatCompletion(apiMessages);

      final assistantMsg = ChatMessagesCompanion.insert(
        role: 'assistant',
        content: aiResponse,
      );

      await _db.into(_db.chatMessages).insert(assistantMsg);
      await _loadMessages();
    } catch (e) {
      state = state.copyWith(
        error: AppLocalizations.get(
            _ref.read(localeProvider), 'oracle_error_unavailable'),
        isLoading: false,
      );
    }
  }

  Future<void> clearHistory() async {
    await _db.delete(_db.chatMessages).go();
    await _loadMessages();
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final db = ref.watch(databaseProvider);
  final aiService = ref.watch(openRouterProvider);
  return ChatNotifier(db, aiService, ref);
});
