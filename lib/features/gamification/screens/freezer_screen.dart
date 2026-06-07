import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/utils/money_utils.dart';
import '../providers/freezer_provider.dart';

class FreezerScreen extends ConsumerStatefulWidget {
  const FreezerScreen({super.key});

  @override
  ConsumerState<FreezerScreen> createState() => _FreezerScreenState();
}

class _FreezerScreenState extends ConsumerState<FreezerScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  int _selectedHours = 24;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String t(String key) {
    return AppLocalizations.get(ref.watch(localeProvider), key);
  }

  @override
  Widget build(BuildContext context) {
    final freezerState = ref.watch(freezerProvider);
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t('freezer_title'),
          style: AppTypography.h3(context, color: Colors.cyanAccent),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary(brightness), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!freezerState.isLocked) ...[
                _buildSetupForm(brightness)
              ] else ...[
                _buildActiveFreezer(freezerState, brightness)
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetupForm(Brightness brightness) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SurfaceCard(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3), width: 2),
                    ),
                    child: const Icon(
                      Icons.ac_unit_rounded,
                      color: Colors.cyanAccent,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceLg),
                Text(
                  t('freezer_desc'),
                  style: AppTypography.bodySmall(context, color: AppColors.textSecondary(brightness)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spaceXl),
                
                // Item Name
                Text(
                  t('freezer_item_name').toUpperCase(),
                  style: AppTypography.overline(context, color: Colors.cyanAccent),
                ),
                const SizedBox(height: AppTheme.spaceSm),
                TextFormField(
                  controller: _nameController,
                  style: AppTypography.bodySmall(context),
                  decoration: InputDecoration(
                    hintText: t('freezer_item_name_hint'),
                    hintStyle: AppTypography.bodySmall(context, color: AppColors.textSecondary(brightness).withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return t('freezer_item_name_validator');
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spaceLg),

                // Amount
                Text(
                  t('freezer_amount').toUpperCase(),
                  style: AppTypography.overline(context, color: Colors.cyanAccent),
                ),
                const SizedBox(height: AppTheme.spaceSm),
                TextFormField(
                  controller: _amountController,
                  style: AppTypography.bodySmall(context),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    hintText: t('freezer_amount_hint'),
                    hintStyle: AppTypography.bodySmall(context, color: AppColors.textSecondary(brightness).withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return t('freezer_amount_validator');
                    final d = double.tryParse(val);
                    if (d == null || d <= 0) return t('freezer_amount_validator');
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spaceLg),

                // Duration Choice
                Text(
                  t('freezer_duration').toUpperCase(),
                  style: AppTypography.overline(context, color: Colors.cyanAccent),
                ),
                const SizedBox(height: AppTheme.spaceSm),
                Row(
                  children: [
                    Expanded(
                      child: _buildDurationOption(24, t('freezer_duration_24')),
                    ),
                    const SizedBox(width: AppTheme.spaceMd),
                    Expanded(
                      child: _buildDurationOption(48, t('freezer_duration_48')),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spaceXl),
          AppButton(
            label: t('freezer_freeze_btn'),
            variant: ButtonVariant.primary,
            onPressed: _activateFreeze,
          ),
        ],
      ),
    );
  }

  Widget _buildDurationOption(int hours, String label) {
    final active = _selectedHours == hours;
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedHours = hours);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? Colors.cyan.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? Colors.cyanAccent : Colors.cyan.withValues(alpha: 0.3),
            width: active ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.bodySmall(
              context,
              color: active ? Colors.cyanAccent : AppColors.textSecondary(Theme.of(context).brightness),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFreezer(FreezerState state, Brightness brightness) {
    final isFinished = state.timeRemaining == Duration.zero;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SurfaceCard(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withValues(alpha: 0.05 + (_pulseController.value * 0.08)),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: child,
              );
            },
            child: Column(
              children: [
                // Top Ice Shield Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shield_rounded, color: Colors.cyanAccent, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        t('freezer_active_badge'),
                        style: AppTypography.overline(context, color: Colors.cyanAccent),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spaceXl),

                // Frost Glow Icon
                const Icon(
                  Icons.ac_unit_rounded,
                  color: Colors.cyanAccent,
                  size: 80,
                ),
                const SizedBox(height: AppTheme.spaceLg),

                // Item Details
                Text(
                  state.itemName.toUpperCase(),
                  style: AppTypography.h2(context, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${formatAmount(state.lockedAmount)} ₴',
                  style: AppTypography.metric(context, color: Colors.cyanAccent),
                ),
                const SizedBox(height: AppTheme.spaceXxl),

                // Countdown Timer Display
                if (!isFinished) ...[
                  Text(
                    _formatDuration(state.timeRemaining),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                      shadows: [
                        Shadow(color: Colors.cyanAccent.withValues(alpha: 0.5), blurRadius: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  Text(
                    t('freezer_locked'),
                    style: AppTypography.caption(context, color: AppColors.textSecondary(brightness)),
                  ),
                ] else ...[
                  // Resolution message
                  const Icon(Icons.lock_open_rounded, color: AppColors.success, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'КРІО-БЛОКУВАННЯ ЗАВЕРШЕНО!',
                    style: AppTypography.bodySmall(context, color: AppColors.success),
                  ),
                ],
                const SizedBox(height: AppTheme.spaceXl),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spaceXl),

        // Resolve options when countdown completes
        if (isFinished) ...[
          AppButton(
            label: t('freezer_unfreeze_save'),
            variant: ButtonVariant.primary,
            onPressed: () async {
              HapticFeedback.mediumImpact();
              await ref.read(freezerProvider.notifier).unfreezeAndSave();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t('freezer_saved_toast')),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: AppTheme.spaceMd),
          AppButton(
            label: t('freezer_unfreeze_buy'),
            variant: ButtonVariant.ghost,
            onPressed: () {
              HapticFeedback.heavyImpact();
              ref.read(freezerProvider.notifier).unfreezeAndBuy();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t('freezer_bought_toast')),
                  backgroundColor: AppColors.error,
                ),
              );
            },
          ),
        ] else ...[
          // Show debug fast forward to skip wait
          Align(
            alignment: Alignment.center,
            child: TextButton.icon(
              icon: const Icon(Icons.bolt, color: Colors.amber, size: 18),
              label: Text(
                t('freezer_debug_fast_forward'),
                style: AppTypography.caption(context, color: Colors.amber),
              ),
              onPressed: () {
                HapticFeedback.vibrate();
                ref.read(freezerProvider.notifier).debugFastForward();
              },
            ),
          ),
        ]
      ],
    );
  }

  void _activateFreeze() {
    if (_formKey.currentState?.validate() ?? false) {
      HapticFeedback.mediumImpact();
      final name = _nameController.text;
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      ref.read(freezerProvider.notifier).lockImpulse(
        amountUah: amount,
        itemName: name,
        durationHours: _selectedHours,
      );
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
