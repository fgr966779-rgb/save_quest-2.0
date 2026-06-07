import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/l10n.dart';
import '../providers/chat_provider.dart';

class OracleScreen extends ConsumerStatefulWidget {
  const OracleScreen({super.key});

  @override
  ConsumerState<OracleScreen> createState() => _OracleScreenState();
}

class _OracleScreenState extends ConsumerState<OracleScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final locale = ref.watch(localeProvider);
    final brightness = Theme.of(context).brightness;

    // Scroll to bottom whenever messages change
    ref.listen(chatProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length || next.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.get(locale, 'oracle_title'),
              style: AppTypography.h3(context, color: AppColors.accent),
            ),
            Text(
              'deepseek-chat-v3-5:free',
              style: AppTypography.overline(context, color: AppColors.textTertiary(brightness)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.error),
            onPressed: () => ref.read(chatProvider.notifier).clearHistory(),
            tooltip: AppLocalizations.get(locale, 'oracle_clear_history'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Cyber-Oracle Avatar / Header
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.accent.withValues(alpha: 0.2))),
            ),
            child: Row(
              children: [
                _buildOracleAvatar(chatState.isLoading),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.get(locale, 'oracle_subtitle'),
                        style: AppTypography.bodySmall(context, color: Colors.white),
                      ),
                      Text(
                        chatState.isLoading ? 'ANALYZING PROTOCOLS...' : 'STATUS: ONLINE',
                        style: AppTypography.overline(context, color: chatState.isLoading ? AppColors.warning : AppColors.success),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Message List
          Expanded(
            child: chatState.messages.isEmpty && !chatState.isLoading
                ? _buildEmptyState(context, locale, brightness)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppTheme.spaceMd),
                    itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatState.messages.length) {
                        return _buildLoadingBubble();
                      }
                      final msg = chatState.messages[index];
                      return _MessageBubble(
                        content: msg.content,
                        isUser: msg.role == 'user',
                        timestamp: msg.createdAt,
                      );
                    },
                  ),
          ),

          if (chatState.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                chatState.error!,
                style: AppTypography.caption(context, color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ),

          // Input Area
          _buildInputArea(context, locale, brightness),
        ],
      ),
    );
  }

  Widget _buildOracleAvatar(bool isLoading) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accent, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
              )
            : const Icon(Icons.auto_awesome, color: AppColors.accent, size: 28),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String locale, Brightness brightness) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.terminal_rounded, size: 64, color: AppColors.accent.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.get(locale, 'oracle_input_hint'),
            style: AppTypography.body(context, color: AppColors.textTertiary(brightness)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
        ),
        child: const Text(
          '...',
          style: TextStyle(color: AppColors.accent, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, String locale, Brightness brightness) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: AppColors.accent.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
              decoration: InputDecoration(
                hintText: AppLocalizations.get(locale, 'oracle_input_hint'),
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  ref.read(chatProvider.notifier).sendMessage(val);
                  _controller.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                ref.read(chatProvider.notifier).sendMessage(_controller.text);
                _controller.clear();
              }
            },
            icon: const Icon(Icons.send_rounded, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  const _MessageBubble({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.accent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isUser ? const Radius.circular(12) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(12),
          ),
          border: Border.all(
            color: isUser ? AppColors.accent.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: TextStyle(
                color: isUser ? AppColors.accent : Colors.white,
                fontFamily: isUser ? null : 'monospace',
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(timestamp),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
