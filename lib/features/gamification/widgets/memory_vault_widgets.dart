import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/database.dart';

class MemoryVaultDialog extends ConsumerStatefulWidget {
  final String goalId;
  final int threshold;

  const MemoryVaultDialog({super.key, required this.goalId, required this.threshold});

  static Future<void> show(BuildContext context, {required String goalId, required int threshold}) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Force them to skip or save
      builder: (ctx) => MemoryVaultDialog(goalId: goalId, threshold: threshold),
    );
  }

  @override
  ConsumerState<MemoryVaultDialog> createState() => _MemoryVaultDialogState();
}

class _MemoryVaultDialogState extends ConsumerState<MemoryVaultDialog> {
  final _noteController = TextEditingController();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    setState(() => _isLoading = true);
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = '${const Uuid().v4()}.jpg';
        final savedImage = await File(image.path).copy('${appDir.path}/$fileName');
        
        await _saveEntry(savedImage.path);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _saveNote() async {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;
    setState(() => _isLoading = true);
    await _saveEntry('note:$text');
  }

  Future<void> _saveEntry(String content) async {
    final db = ref.read(databaseProvider);
    final entry = MemoryVaultEntry(
      id: const Uuid().v4(),
      goalId: widget.goalId,
      unlockThresholdPercent: widget.threshold,
      content: content,
      isUnlocked: true,
      createdAt: DateTime.now(),
    );
    await db.insertMemoryVaultEntry(entry);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _skip() async {
    // Save empty content with isUnlocked = false to mark that the threshold was crossed but not filled
    final db = ref.read(databaseProvider);
    final entry = MemoryVaultEntry(
      id: const Uuid().v4(),
      goalId: widget.goalId,
      unlockThresholdPercent: widget.threshold,
      content: null,
      isUnlocked: false,
      createdAt: DateTime.now(),
    );
    await db.insertMemoryVaultEntry(entry);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    String t(String key, [Map<String, String>? params]) {
      var str = AppLocalizations.get(locale, key);
      if (params != null) {
        params.forEach((k, v) {
          str = str.replaceAll('{$k}', v);
        });
      }
      return str;
    }

    return Dialog(
      backgroundColor: Colors.grey[900]!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.accent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_open, color: AppColors.accent, size: 48)
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 1.seconds, color: AppColors.goalA),
            const SizedBox(height: 16),
            Text(
              t('memory_vault_unlocked', {'pct': widget.threshold.toString()}),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Orbitron',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              t('memory_vault_unlocked_desc'),
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator(color: AppColors.accent)
            else ...[
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: Text(t('memory_vault_btn_photo')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 12),
              Text(t('memory_vault_or'), style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: t('memory_vault_note_hint'),
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _saveNote,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.accent),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(t('memory_vault_btn_note')),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _skip,
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: Text(t('memory_vault_btn_skip')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MemoryVaultWidget extends ConsumerWidget {
  final String goalId;
  final int currentPercent;

  const MemoryVaultWidget({super.key, required this.goalId, required this.currentPercent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final locale = ref.watch(localeProvider);
    String t(String key, [Map<String, String>? params]) {
      var str = AppLocalizations.get(locale, key);
      if (params != null) {
        params.forEach((k, v) {
          str = str.replaceAll('{$k}', v);
        });
      }
      return str;
    }

    return StreamBuilder<List<MemoryVaultEntry>>(
      stream: db.watchMemoryVaultEntriesForGoal(goalId),
      builder: (context, snapshot) {
        final entries = snapshot.data ?? [];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                t('memory_vault_title'),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Orbitron',
                  letterSpacing: 1.2,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                final threshold = (index + 1) * 10;
                final entry = entries.where((e) => e.unlockThresholdPercent == threshold).firstOrNull;
                
                final isReached = currentPercent >= threshold;
                final hasContent = entry != null && entry.isUnlocked && entry.content != null;
                final needsAttention = isReached && !hasContent;

                return GestureDetector(
                  onTap: () {
                    if (hasContent) {
                      _showViewer(context, entry.content!);
                    } else if (isReached) {
                      MemoryVaultDialog.show(context, goalId: goalId, threshold: threshold);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(t('memory_vault_unlocks_at', {'pct': threshold.toString()}))),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: hasContent ? Colors.grey[900]! : Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: hasContent 
                              ? AppColors.accent 
                              : (needsAttention ? AppColors.error : Colors.grey[900]!),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (hasContent && !entry.content!.startsWith('note:'))
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(entry.content!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        else if (hasContent && entry.content!.startsWith('note:'))
                          const Icon(Icons.text_snippet, color: AppColors.accent)
                        else
                          Icon(
                            isReached ? Icons.lock_open : Icons.lock,
                            color: isReached ? AppColors.error : Colors.grey,
                            size: 20,
                          ).animate(target: isReached ? 1 : 0)
                           .shimmer(duration: 2.seconds, color: AppColors.error),

                        if (needsAttention)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(end: 1.5, duration: 800.ms),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showViewer(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Cyberpunk frame
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: AppColors.accent, width: 2),
                boxShadow: [
                  BoxShadow(color: AppColors.accent.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 5),
                ],
              ),
              child: content.startsWith('note:')
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      color: Colors.grey[900]!,
                      child: Text(
                        content.substring(5),
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Image.file(File(content), fit: BoxFit.contain),
            ),
            Positioned(
              top: 40,
              right: 40,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms).scaleXY(begin: 0.8, end: 1.0, curve: Curves.easeOutBack),
      ),
    );
  }
}

class MemoryDecryptionSequence extends ConsumerStatefulWidget {
  final String goalId;
  const MemoryDecryptionSequence({super.key, required this.goalId});

  static Future<void> show(BuildContext context, {required String goalId}) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => MemoryDecryptionSequence(goalId: goalId),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  ConsumerState<MemoryDecryptionSequence> createState() => _MemoryDecryptionSequenceState();
}

class _MemoryDecryptionSequenceState extends ConsumerState<MemoryDecryptionSequence> {
  List<MemoryVaultEntry> _entries = [];
  int _currentIndex = -1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndPlay();
  }

  Future<void> _loadAndPlay() async {
    final db = ref.read(databaseProvider);
    final allEntries = await db.getMemoryVaultEntriesForGoal(widget.goalId);
    
    if (allEntries.isEmpty) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    setState(() {
      _entries = allEntries.where((e) => e.isUnlocked && e.content != null).toList();
      _isLoading = false;
    });

    if (_entries.isEmpty) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.of(context).pop();
      return;
    }

    for (int i = 0; i < _entries.length; i++) {
      if (!mounted) return;
      setState(() => _currentIndex = i);
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 1500)); // Time to view each memory
    }

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    String t(String key, [Map<String, String>? params]) {
      var str = AppLocalizations.get(locale, key);
      if (params != null) {
        params.forEach((k, v) {
          str = str.replaceAll('{$k}', v);
        });
      }
      return str;
    }

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black87,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (_entries.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Text(
            t('memory_vault_empty'),
            style: const TextStyle(color: AppColors.error, fontSize: 24, fontFamily: 'Orbitron'),
          ).animate().shimmer(duration: const Duration(seconds: 2)),
        ),
      );
    }

    final currentEntry = _currentIndex >= 0 && _currentIndex < _entries.length
        ? _entries[_currentIndex]
        : _entries.last;
    final content = currentEntry.content!;

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.95),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Cyberpunk Glitch effect background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent, width: 4),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 1.seconds, color: AppColors.goalA),
          ),
          
          // Image / Note
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Container(
              key: ValueKey<int>(_currentIndex),
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: AppColors.goalA, width: 2),
                boxShadow: [
                  BoxShadow(color: AppColors.goalA.withValues(alpha: 0.5), blurRadius: 30, spreadRadius: 10),
                ],
              ),
              child: content.startsWith('note:')
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      color: Colors.grey[900]!,
                      child: Text(
                        content.substring(5),
                        style: const TextStyle(color: Colors.white, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Image.file(File(content), fit: BoxFit.contain),
            ),
          ),

          // Decryption Overlay Text
          Positioned(
            top: 60,
            child: Text(
              t('memory_vault_decrypting', {'pct': currentEntry.unlockThresholdPercent.toString()}),
              style: const TextStyle(color: AppColors.goalA, fontSize: 20, fontFamily: 'Orbitron', fontWeight: FontWeight.bold),
            ).animate(onPlay: (c) => c.repeat()).shimmer(),
          ),

          // Skip Button
          Positioned(
            bottom: 40,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey,
                side: const BorderSide(color: Colors.grey),
              ),
              child: Text(t('memory_vault_skip_seq')),
            ),
          ),
        ],
      ),
    );
  }
}
