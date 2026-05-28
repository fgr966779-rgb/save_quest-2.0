import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/services/weekly_challenge_service.dart';
import '../../../core/utils/money_utils.dart';

/// Screen showing active and completed weekly challenges.
class WeeklyChallengesScreen extends ConsumerStatefulWidget {
  const WeeklyChallengesScreen({super.key});

  @override
  ConsumerState<WeeklyChallengesScreen> createState() =>
      _WeeklyChallengesScreenState();
}

class _WeeklyChallengesScreenState
    extends ConsumerState<WeeklyChallengesScreen> {
  final WeeklyChallengeService _service = WeeklyChallengeService();
  List<WeeklyChallenge> _challenges = [];

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  void _loadChallenges() {
    setState(() {
      _challenges = _service.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.read(localeProvider);
    String t(String key) => AppLocalizations.get(locale, key);
    final currency = ref.read(settingsServiceProvider).currency;

    final active = _challenges.where((c) => !c.isCompleted && !c.isExpired).toList();
    final completed = _challenges.where((c) => c.isCompleted).toList();
    final expired = _challenges.where((c) => c.isExpired).toList();

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          t('challenge_title'),
          style: AppTypography.h2(context),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showCreateSheet(context, currency),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadChallenges();
        },
        child: _challenges.isEmpty
            ? EmptyState(
                icon: const Icon(Icons.emoji_events_rounded),
                title: t('challenge_empty'),
                description: '',
              )
            : ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                children: [
                  // Stats bar
                  if (completed.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SurfaceCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              label: t('challenge_active'),
                              value: '${active.length}',
                              color: AppColors.accent,
                            ),
                            _StatItem(
                              label: t('challenge_done'),
                              value: '${completed.length}',
                              color: AppColors.success,
                            ),
                            _StatItem(
                              label: t('challenge_expired'),
                              value: '${expired.length}',
                              color: AppColors.warning,
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Active challenges
                  if (active.isNotEmpty) ...[
                    Text(
                      t('challenge_active'),
                      style: AppTypography.h3(context),
                    ),
                    const SizedBox(height: 8.0),
                    ...active.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _ChallengeCard(
                            challenge: c,
                            currency: currency,
                            onTap: () => _showEditSheet(context, currency, c),
                            onDelete: () => _deleteChallenge(c),
                          ),
                        )),
                    const SizedBox(height: 16.0),
                  ],

                  // Completed challenges
                  if (completed.isNotEmpty) ...[
                    Text(
                      t('challenge_done'),
                      style: AppTypography.h3(context),
                    ),
                    const SizedBox(height: 8.0),
                    ...completed.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _ChallengeCard(
                            challenge: c,
                            currency: currency,
                            isCompleted: true,
                            onDelete: () => _deleteChallenge(c),
                          ),
                        )),
                    const SizedBox(height: 16.0),
                  ],

                  // Expired challenges
                  if (expired.isNotEmpty) ...[
                    Text(
                      t('challenge_expired'),
                      style: AppTypography.h3(context),
                    ),
                    const SizedBox(height: 8.0),
                    ...expired.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _ChallengeCard(
                            challenge: c,
                            currency: currency,
                            isExpired: true,
                            onDelete: () => _deleteChallenge(c),
                          ),
                        )),
                  ],

                  const SizedBox(height: 40.0),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSheet(context, currency),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ── CRUD Actions ──────────────────────────────────────────────────────

  Future<void> _showCreateSheet(BuildContext context, String currency) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CreateChallengeSheet(
        currency: currency,
        onSave: (title, target, deadline) async {
          await _service.create(WeeklyChallenge(
            id: const Uuid().v4(),
            title: title,
            description: title,
            targetAmount: target,
            deadline: deadline,
          ));
          HapticFeedback.lightImpact();
          _loadChallenges();
        },
      ),
    );
  }

  Future<void> _showEditSheet(
      BuildContext context, String currency, WeeklyChallenge challenge) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CreateChallengeSheet(
        currency: currency,
        initialTitle: challenge.title,
        initialTarget: challenge.targetAmount,
        initialDeadline: challenge.deadline,
        isEditing: true,
        onSave: (title, target, deadline) async {
          await _service.update(challenge.copyWith(
            title: title,
            targetAmount: target,
            deadline: deadline,
          ));
          HapticFeedback.lightImpact();
          _loadChallenges();
        },
      ),
    );
  }

  Future<void> _deleteChallenge(WeeklyChallenge challenge) async {
    await _service.delete(challenge.id);
    _loadChallenges();
  }
}

/// Bottom sheet for creating / editing a challenge.
class _CreateChallengeSheet extends ConsumerStatefulWidget {
  final String currency;
  final String? initialTitle;
  final int? initialTarget;
  final DateTime? initialDeadline;
  final bool isEditing;
  final Future<void> Function(
      String title, int targetKopecks, DateTime deadline) onSave;

  const _CreateChallengeSheet({
    required this.currency,
    this.initialTitle,
    this.initialTarget,
    this.initialDeadline,
    this.isEditing = false,
    required this.onSave,
  });

  @override
  ConsumerState<_CreateChallengeSheet> createState() => _CreateChallengeSheetState();
}

class _CreateChallengeSheetState extends ConsumerState<_CreateChallengeSheet> {
  late TextEditingController _titleCtrl;
  late TextEditingController _targetCtrl;
  late DateTime _deadline;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialTitle ?? '');
    _targetCtrl = TextEditingController(
        text: widget.initialTarget != null
            ? centsToDisplay(widget.initialTarget!).toStringAsFixed(0)
            : '');
    _deadline = widget.initialDeadline ??
        DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    final targetHryvnias =
        double.tryParse(_targetCtrl.text.replaceAll(',', '.')) ?? 0;
    if (targetHryvnias <= 0) return;

    final targetKopecks = (targetHryvnias * 100).round();
    widget.onSave(title, targetKopecks, _deadline);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.read(localeProvider);
    String t(String key) => AppLocalizations.get(locale, key);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.isEditing
                ? t('challenge_edit')
                : t('challenge_new'),
            style: AppTypography.h2(context),
          ),
          const SizedBox(height: 20.0),

          // Title
          TextField(
            controller: _titleCtrl,
            style: AppTypography.body(context),
            decoration: InputDecoration(
              labelText: t('challenge_name'),
              hintText: t('challenge_name_hint'),
              filled: true,
              fillColor: AppColors.surface(brightness),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: BorderSide(color: AppColors.border(brightness)),
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // Target amount
          TextField(
            controller: _targetCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
            ],
            style: AppTypography.body(context),
            decoration: InputDecoration(
              labelText: t('challenge_target'),
              suffixText: widget.currency,
              filled: true,
              fillColor: AppColors.surface(brightness),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: BorderSide(color: AppColors.border(brightness)),
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // Deadline picker
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface(brightness),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppColors.border(brightness)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t('challenge_deadline'),
                    style: AppTypography.body(context),
                  ),
                  Text(
                    '${_deadline.day}.${_deadline.month}.${_deadline.year}',
                    style: AppTypography.body(context, color: AppColors.accent),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24.0),

          AppButton(
            label: widget.isEditing ? t('common_save') : t('challenge_create'),
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

/// Card widget for a single challenge.
class _ChallengeCard extends StatelessWidget {
  final WeeklyChallenge challenge;
  final String currency;
  final bool isCompleted;
  final bool isExpired;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const _ChallengeCard({
    required this.challenge,
    required this.currency,
    this.isCompleted = false,
    this.isExpired = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final progress = challenge.progressPercent;
    final progressColor = isCompleted
        ? AppColors.success
        : isExpired
            ? AppColors.textDisabled(brightness)
            : AppColors.accent;

    return SurfaceCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Expanded(
                child: Text(
                  challenge.title,
                  style: AppTypography.body(
                    context,
                    color: isCompleted || isExpired
                        ? AppColors.textTertiary(brightness)
                        : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isCompleted)
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.success, size: 20)
              else if (isExpired)
                const Icon(Icons.schedule_rounded,
                    color: AppColors.warning, size: 20)
              else
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  color: AppColors.textTertiary(brightness),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
            ],
          ),
          if (challenge.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              challenge.description,
              style: AppTypography.caption(context),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Progress
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.border(brightness),
              valueColor: AlwaysStoppedAnimation(progressColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),

          // Info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${centsToDisplay(challenge.currentAmount).toStringAsFixed(0)} / ${centsToDisplay(challenge.targetAmount).toStringAsFixed(0)} $currency',
                style: AppTypography.caption(context),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: AppTypography.caption(
                  context,
                  color: progressColor,
                ),
              ),
            ],
          ),

          // Deadline
          const SizedBox(height: 2),
          Text(
            '${challenge.deadline.day}.${challenge.deadline.month}.${challenge.deadline.year}',
            style: AppTypography.overline(context),
          ),
        ],
      ),
    );
  }
}

/// Small stat display widget.
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTypography.metric(context, color: color)),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption(context),
        ),
      ],
    );
  }
}
