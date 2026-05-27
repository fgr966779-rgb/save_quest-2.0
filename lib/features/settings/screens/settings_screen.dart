import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/neon_avatar_painter.dart';
import '../../../core/models/avatar_config.dart';
import '../../../core/providers/banking_provider.dart';
import '../../../core/services/openrouter_service.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/services/milestone_service.dart';
import '../../../core/services/weekly_challenge_service.dart';
import '../../../core/services/goal_dependency_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/backup_service.dart';
import '../../../main.dart' show themeModeProvider;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final GlobalKey _shareKey = GlobalKey();
  bool _isExporting = false;
  bool _isBackupBusy = false;

  // Local state for mock settings
  bool _dailyReminder = true;
  bool _achievementNotifications = true;
  bool _biometricEnabled = false;
  bool _biometricAvailable = true;

  @override
  void initState() {
    super.initState();
    // Read persisted settings
    _dailyReminder = ref.read(settingsServiceProvider).isDailyReminderEnabled;
    _achievementNotifications = ref.read(settingsServiceProvider).isAchievementNotifsEnabled;
    _biometricEnabled = ref.read(settingsServiceProvider).isBiometricEnabled;
    // Check device biometric capability
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final bio = BiometricService();
    final available = await bio.canEnable();
    if (mounted) {
      setState(() => _biometricAvailable = available);
    }
  }

  Future<void> _exportShareCard() async {
    setState(() => _isExporting = true);
    HapticFeedback.mediumImpact();

    try {
      await Future.delayed(const Duration(seconds: 1));
      final RenderRepaintBoundary? boundary =
          _shareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary != null) {
        final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
        final ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.get(ref.read(localeProvider), 'settings_export_success'),
                style: AppTypography.bodySmall(
                  context,
                  color: AppColors.success,
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Handle error silently
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsServiceProvider);
    final userProfileAsync = ref.watch(userProfileProvider);
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final brightness = Theme.of(context).brightness;

    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              t('settings_title'),
              style: AppTypography.h1(context),
            ),
            const SizedBox(height: 24.0),

            // ── Export Card Section ──
            Text(
              t('settings_export'),
              style: AppTypography.h3(context),
            ),
            const SizedBox(height: 12.0),
            RepaintBoundary(
              key: _shareKey,
              child: SurfaceCard(
                borderColor: AppColors.accent.withValues(alpha: 0.3),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PiggyVault',
                          style: AppTypography.overline(
                            context,
                            color: AppColors.accent,
                          ),
                        ),
                        Icon(
                          Icons.qr_code_2,
                          color: AppColors.accent,
                          size: 22,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    userProfileAsync.when(
                      loading: () => const SizedBox(height: 40),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (profile) {
                        final streak = profile?.streakCount ?? 0;
                        final level = profile?.level ?? 1;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (profile != null &&
                                profile.avatarConfig != null &&
                                profile.avatarConfig!.isNotEmpty) ...[
                              NeonAvatarWidget(
                                config:
                                    AvatarConfig.fromJson(profile.avatarConfig!),
                                size: 50.0,
                                brightness: brightness,
                              ),
                              const SizedBox(width: 16.0),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t('settings_rank'),
                                    style: AppTypography.caption(context),
                                  ),
                                  Text(
                                    '${AppLocalizations.get(ref.read(localeProvider), 'settings_rank_level')}$level',
                                    style: AppTypography.h3(context),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  t('settings_streak'),
                                  style: AppTypography.caption(context),
                                ),
                                Text(
                                  '$streak',
                                  style: AppTypography.metric(context,
                                      color: AppColors.success),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            AppButton(
              label: _isExporting ? '...' : t('settings_share_btn'),
              onPressed: _isExporting ? null : _exportShareCard,
              variant: ButtonVariant.primary,
              icon: const Icon(Icons.share, size: 18),
            ),
            const SizedBox(height: 32.0),

            // ── Customization Section ──
            Text(
              t('settings_custom'),
              style: AppTypography.h3(context),
            ),
            const SizedBox(height: 12.0),
            AppButton(
              label: t('settings_themes'),
              onPressed: () => context.push('/customization'),
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.palette, size: 18),
            ),
            const SizedBox(height: 10.0),
            AppButton(
              label: t('settings_skills'),
              onPressed: () => context.push('/skill-tree'),
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.account_tree_rounded, size: 18),
            ),
            const SizedBox(height: 24.0),

            // ── AI Personality Selection ──
            Text(
              t('settings_ai_personality'),
              style: AppTypography.h3(context),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              initialValue: settings.coachPersonality,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: t('settings_ai_hint'),
              ),
              style: AppTypography.body(context),
              dropdownColor: AppColors.surface(brightness),
              items: CoachPersonality.values.map((CoachPersonality p) {
                return DropdownMenuItem<String>(
                  value: p.key,
                  child: Text(p.displayName),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    settings.coachPersonality = newValue;
                  });
                  ref.invalidate(aiInsightsProvider);
                }
              },
            ),
            const SizedBox(height: 32.0),

            // ── Theme Mode Toggle ──
            Text(
              t('settings_theme_section'),
              style: AppTypography.h3(context),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: _buildThemeSegment(
                    label: t('settings_theme_light'),
                    isSelected: currentThemeMode == ThemeMode.light,
                    onTap: () =>
                        ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _buildThemeSegment(
                    label: t('settings_theme_dark'),
                    isSelected: currentThemeMode == ThemeMode.dark,
                    onTap: () =>
                        ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _buildThemeSegment(
                    label: t('settings_theme_system'),
                    isSelected: currentThemeMode == ThemeMode.system,
                    onTap: () =>
                        ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),

            // ── Notifications & Signals ──
            Text(
              t('settings_signals'),
              style: AppTypography.h3(context),
            ),
            const SizedBox(height: 8.0),

            _buildToggleItem(
              icon: Icons.volume_up_outlined,
              title: t('settings_sound'),
              subtitle: t('settings_sound_sub'),
              value: settings.isSoundEnabled,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() {
                  settings.isSoundEnabled = val;
                });
              },
            ),
            Divider(color: AppColors.border(brightness), height: 1),

            _buildToggleItem(
              icon: Icons.vibration,
              title: t('settings_haptic'),
              subtitle: t('settings_haptic_sub'),
              value: settings.isHapticEnabled,
              onChanged: (val) {
                HapticFeedback.heavyImpact();
                setState(() {
                  settings.isHapticEnabled = val;
                });
              },
            ),
            Divider(color: AppColors.border(brightness), height: 1),

            _buildToggleItem(
              icon: Icons.notifications_active_outlined,
              title: t('settings_reminder'),
              subtitle: t('settings_reminder_sub'),
              value: _dailyReminder,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() => _dailyReminder = val);
                ref.read(settingsServiceProvider).isDailyReminderEnabled = val;
                _onReminderChanged(val);
              },
            ),
            Divider(color: AppColors.border(brightness), height: 1),

            _buildToggleItem(
              icon: Icons.emoji_events_outlined,
              title: t('settings_achievements'),
              subtitle: t('settings_achievements_sub'),
              value: _achievementNotifications,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() => _achievementNotifications = val);
                ref.read(settingsServiceProvider).isAchievementNotifsEnabled = val;
              },
            ),
            const SizedBox(height: 32.0),

            // ── Anti-Goals Section ──
            Text(
              t('settings_antigoals_section'),
              style: AppTypography.h3(context),
            ),
            const SizedBox(height: 8.0),
            AppButton(
              label: t('settings_antigoals_btn'),
              onPressed: () => context.push('/blacklist'),
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.block, size: 18),
              fullWidth: true,
            ),
            const SizedBox(height: 32.0),

            // ── Security & Privacy ──
            Text(
              t('settings_security'),
              style: AppTypography.h3(context),
            ),
            const SizedBox(height: 8.0),

            _buildToggleItem(
              icon: Icons.visibility_off_outlined,
              title: t('settings_privacy'),
              subtitle: t('settings_privacy_sub'),
              value: settings.privacyMode,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() => settings.privacyMode = val);
              },
            ),
            Divider(color: AppColors.border(brightness), height: 1),

            _buildToggleItem(
              icon: Icons.fingerprint,
              title: t('settings_biometric'),
              subtitle: _biometricAvailable
                  ? t('settings_biometric_sub')
                  : t('biometric_unavailable'),
              value: _biometricEnabled,
              onChanged: (val) {
                if (_biometricAvailable) {
                  _handleBiometricToggle(val);
                }
              },
            ),
            const SizedBox(height: 32.0),

            // ── Data & Backup ──
            Text(
              t('settings_data'),
              style: AppTypography.h3(context),
            ),
            const SizedBox(height: 8.0),

            _buildToggleItem(
              icon: Icons.cloud_upload_outlined,
              title: t('settings_cloud'),
              subtitle: settings.isCloudBackupEnabled
                  ? t('settings_cloud_sub')
                  : t('settings_cloud_sub_off'),
              value: settings.isCloudBackupEnabled,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() {
                  settings.isCloudBackupEnabled = val;
                });
              },
            ),
            const SizedBox(height: 12.0),

            AppButton(
              label: _isBackupBusy
                  ? t('backup_exporting')
                  : t('settings_export_backup'),
              onPressed: _isBackupBusy ? null : _handleExportBackup,
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.cloud_download, size: 18),
              fullWidth: true,
            ),
            const SizedBox(height: 10.0),

            AppButton(
              label: _isBackupBusy
                  ? t('backup_importing')
                  : t('settings_import_backup'),
              onPressed: _isBackupBusy ? null : _handleImportBackup,
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.cloud_upload, size: 18),
              fullWidth: true,
            ),
            const SizedBox(height: 10.0),

            AppButton(
              label: _isBackupBusy
                  ? t('csv_exporting')
                  : t('settings_export_csv'),
              onPressed: _isBackupBusy ? null : _handleExportCsv,
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.file_download, size: 18),
              fullWidth: true,
            ),
            const SizedBox(height: 10.0),

            AppButton(
              label: t('csv_import'),
              onPressed: _isBackupBusy ? null : _handleImportCsv,
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.file_upload, size: 18),
              fullWidth: true,
            ),
            const SizedBox(height: 10.0),

            AppButton(
              label: t('settings_hard_reset'),
              onPressed: () => _showHardResetDialog(context, ref),
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.delete_forever, size: 18),
              fullWidth: true,
            ),
            const SizedBox(height: 32.0),

            // ── Additional ──
            Text(
              t('settings_others'),
              style: AppTypography.h3(context),
            ),
            const SizedBox(height: 8.0),

            AppButton(
              label: t('settings_support'),
              onPressed: () => HapticFeedback.lightImpact(),
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.help_outline, size: 18),
            ),
            const SizedBox(height: 10.0),

            AppButton(
              label: t('settings_rate'),
              onPressed: () => HapticFeedback.lightImpact(),
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.star_border, size: 18),
            ),
            const SizedBox(height: 10.0),

            AppButton(
              label: t('settings_policy'),
              onPressed: () => HapticFeedback.lightImpact(),
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.privacy_tip_outlined, size: 18),
            ),
            const SizedBox(height: 12.0),

            // ── Language & Currency ──
            _buildSelectorItem(
              title: t('settings_currency'),
              value: settings.currency,
              options: const ['₴', '\$', '€'],
              onSelected: (val) {
                HapticFeedback.lightImpact();
                setState(() {
                  settings.currency = val;
                });
                ref.invalidate(goalsProvider);
              },
            ),
            const SizedBox(height: 16.0),
            _buildSelectorItem(
              title: t('settings_language'),
              value: currentLocale,
              options: const ['UA', 'EN'],
              onSelected: (val) {
                HapticFeedback.lightImpact();
                ref.read(localeProvider.notifier).setLocale(val);
              },
            ),
            const SizedBox(height: 32.0),

            // ── Debug Section ──
            Text(
              t('settings_debug_section'),
              style: AppTypography.h3(context, color: AppColors.error),
            ),
            const SizedBox(height: 8.0),
            SurfaceCard(
              padding: const EdgeInsets.all(16.0),
              borderColor: AppColors.error.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'OpenRouter API Key',
                    style: AppTypography.bodySmall(context),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    initialValue: settings.openRouterApiKey,
                    obscureText: true,
                    style: AppTypography.bodySmall(context),
                    decoration: const InputDecoration(
                      hintText: 'sk-or-v1-...',
                    ),
                    onChanged: (val) {
                      settings.openRouterApiKey = val;
                      ref.invalidate(aiInsightsProvider);
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Divider(color: AppColors.border(brightness), height: 1),
                  const SizedBox(height: 16.0),
                  Text(
                    t('settings_debug_bank'),
                    style: AppTypography.bodySmall(context),
                  ),
                  const SizedBox(height: 8.0),
                  AppButton(
                    label: t('settings_debug_gen_tx'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      ref
                          .read(mockBankingProvider.notifier)
                          .simulateRandomTransaction();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(t('settings_debug_gen_tx_success'))),
                      );
                    },
                    variant: ButtonVariant.ghost,
                    icon: const Icon(Icons.monetization_on, size: 16),
                    fullWidth: true,
                  ),
                  const SizedBox(height: 8.0),
                  AppButton(
                    label: t('settings_debug_clear_bank'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      ref.read(mockBankingProvider.notifier).clearTransactions();
                    },
                    variant: ButtonVariant.ghost,
                    icon: const Icon(Icons.delete, size: 16),
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16.0),
                  Divider(color: AppColors.border(brightness), height: 1),
                  const SizedBox(height: 16.0),
                  Text(
                    t('settings_debug_events'),
                    style: AppTypography.bodySmall(context),
                  ),
                  const SizedBox(height: 8.0),
                  AppButton(
                    label: t('settings_debug_gen_event'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      ref.read(eventsProvider.notifier).forceNewEvent();
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t('settings_debug_gen_event_success'))),
                      );
                    },
                    variant: ButtonVariant.ghost,
                    icon: const Icon(Icons.public, size: 16),
                    fullWidth: true,
                  ),
                  const SizedBox(height: 8.0),
                  AppButton(
                    label: t('settings_debug_stop_event'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      ref.read(eventsProvider.notifier).clearEvent();
                    },
                    variant: ButtonVariant.ghost,
                    icon: const Icon(Icons.close, size: 16),
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16.0),
                  Divider(color: AppColors.border(brightness), height: 1),
                  const SizedBox(height: 16.0),
                  Text(
                    t('settings_debug_remote'),
                    style: AppTypography.bodySmall(context),
                  ),
                  const SizedBox(height: 8.0),
                  AppButton(
                    label: t('settings_debug_remote_btn'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      context.push('/remote-control');
                    },
                    variant: ButtonVariant.ghost,
                    icon: const Icon(Icons.settings_remote, size: 16),
                    fullWidth: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),

            // ── Version Info ──
            Center(
              child: Text(
                'PiggyVault v1.0.0\n© 2026',
                textAlign: TextAlign.center,
                style: AppTypography.caption(context),
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  /// Export full backup — serialize all data to JSON and share.
  Future<void> _handleExportBackup() async {
    HapticFeedback.lightImpact();
    setState(() => _isBackupBusy = true);

    try {
      final db = ref.read(databaseProvider);
      final settings = ref.read(settingsServiceProvider);
      final backupService = BackupService(db, settings);

      await backupService.exportAndShare();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.get(ref.read(localeProvider), 'backup_success'),
              style: AppTypography.bodySmall(
                context,
                color: AppColors.success,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.get(ref.read(localeProvider), 'backup_error')}$e',
              style: AppTypography.bodySmall(
                context,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isBackupBusy = false);
    }
  }

  /// Import backup — pick JSON file, confirm, then restore.
  Future<void> _handleImportBackup() async {
    HapticFeedback.lightImpact();

    try {
      final db = ref.read(databaseProvider);
      final settings = ref.read(settingsServiceProvider);
      final backupService = BackupService(db, settings);

      // Pick file
      final backup = await backupService.pickBackupFile();
      if (backup == null) return; // User cancelled picker

      // Show confirmation dialog
      final locale = ref.read(localeProvider);
      final brightness = Theme.of(context).brightness;

      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: AppColors.surface(brightness),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.warning),
            ),
            title: Text(
              AppLocalizations.get(locale, 'backup_import_confirm_title'),
              style: AppTypography.h3(context),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.get(locale, 'backup_import_confirm_desc'),
                  style: AppTypography.body(context),
                ),
                const SizedBox(height: 12),
                Text(
                  '${backup.appVersion} | ${backup.createdAt.toIso8601String()}',
                  style: AppTypography.caption(context),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  AppLocalizations.get(locale, 'backup_import_confirm_no'),
                  style: TextStyle(color: AppColors.textSecondary(brightness)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  AppLocalizations.get(locale, 'backup_import_confirm_yes'),
                  style: TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (confirmed != true || !mounted) return;

      // Restore
      setState(() => _isBackupBusy = true);

      await backupService.restoreBackup(backup);

      // Invalidate all providers to refresh UI
      ref.invalidate(goalsProvider);
      ref.invalidate(depositsProvider);
      ref.invalidate(userProfileProvider);
      ref.invalidate(unlockedAchievementsProvider);
      ref.invalidate(unlockedSkillsProvider);
      ref.invalidate(localeProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.get(ref.read(localeProvider), 'backup_import_success'),
              style: AppTypography.bodySmall(
                context,
                color: AppColors.success,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final locale = ref.read(localeProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.get(locale, 'backup_import_error')}$e',
              style: AppTypography.bodySmall(
                context,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isBackupBusy = false);
    }
  }

  /// Export deposits as CSV file via share sheet.
  Future<void> _handleExportCsv() async {
    HapticFeedback.lightImpact();
    setState(() => _isBackupBusy = true);

    try {
      final db = ref.read(databaseProvider);
      final settings = ref.read(settingsServiceProvider);
      final backupService = BackupService(db, settings);

      await backupService.exportCsv();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.get(ref.read(localeProvider), 'csv_success'),
              style: AppTypography.bodySmall(
                context,
                color: AppColors.success,
              ),
            ),
          ),
        );
      }
    } on StateError {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.get(ref.read(localeProvider), 'csv_empty'),
              style: AppTypography.bodySmall(context),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.get(ref.read(localeProvider), 'csv_error')}$e',
              style: AppTypography.bodySmall(
                context,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isBackupBusy = false);
    }
  }

  /// Handle CSV Import — pick file, parse, preview, insert.
  Future<void> _handleImportCsv() async {
    final locale = ref.read(localeProvider);

    setState(() => _isBackupBusy = true);
    try {
      final db = ref.read(databaseProvider);
      final backupService = BackupService(db);
      final count = await backupService.importCsv();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.format(
                locale, 'csv_import_success', {'count': '$count'})),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } on FormatException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.get(locale, 'csv_import_error')}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.get(locale, 'csv_import_error')}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isBackupBusy = false);
    }
  }

  /// Hard Reset — confirmation dialog requiring "ВИДАЛИТИ" text input.
  Future<void> _showHardResetDialog(BuildContext context, WidgetRef ref) async {
    HapticFeedback.heavyImpact();
    final confirmController = TextEditingController();
    final brightness = Theme.of(context).brightness;
    final locale = ref.read(localeProvider);
    final resetWord = AppLocalizations.get(locale, 'settings_reset_word');

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final text = confirmController.text;
            final isMatch = text == resetWord;

            return AlertDialog(
              backgroundColor: AppColors.surface(brightness),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.error),
              ),
              title: Text(
                AppLocalizations.get(locale, 'settings_reset_dialog_title'),
                style: AppTypography.h3(context, color: AppColors.error),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.get(locale, 'settings_reset_dialog_desc'),
                  style: AppTypography.body(context),
                ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.get(locale, 'settings_reset_dialog_instruction'),
                    style: AppTypography.bodySmall(context,
                        color: AppColors.textSecondary(brightness)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmController,
                    style: TextStyle(
                      color: isMatch ? AppColors.error : AppColors.textPrimary(brightness),
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: resetWord,
                      hintStyle: TextStyle(
                        color: AppColors.textTertiary(brightness),
                        fontWeight: FontWeight.w400,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.border(brightness)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: isMatch ? AppColors.error : AppColors.accent),
                      ),
                      counterText: isMatch ? '✓' : '',
                      counterStyle: TextStyle(
                        color: isMatch ? AppColors.error : AppColors.textTertiary(brightness),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onChanged: (val) => setDialogState(() {}),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(
                    AppLocalizations.get(locale, 'common_cancel'),
                    style: TextStyle(color: AppColors.textSecondary(brightness)),
                  ),
                ),
                TextButton(
                  onPressed: isMatch ? () => Navigator.pop(ctx, true) : null,
                  child: Text(
                    resetWord,
                    style: TextStyle(
                      color: isMatch ? AppColors.error : AppColors.textDisabled(brightness),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    confirmController.dispose();

    if (confirmed != true || !context.mounted) return;

    // Execute hard reset
    try {
      final db = ref.read(databaseProvider);
      final settings = ref.read(settingsServiceProvider);

      // 1. Delete all data from every Drift table via raw SQL
      await db.transaction(() async {
        await db.customStatement('DELETE FROM goals');
        await db.customStatement('DELETE FROM deposits');
        await db.customStatement('DELETE FROM user_profiles');
        await db.customStatement('DELETE FROM unlocked_achievements');
        await db.customStatement('DELETE FROM unlocked_skills');
        await db.customStatement('DELETE FROM lootboxes');
        await db.customStatement('DELETE FROM pets');
        await db.customStatement('DELETE FROM squads');
        await db.customStatement('DELETE FROM side_quests');
        await db.customStatement('DELETE FROM transaction_tags');
        await db.customStatement('DELETE FROM voice_logs');
        await db.customStatement('DELETE FROM penalty_habits');
        await db.customStatement('DELETE FROM joint_goals');
        await db.customStatement('DELETE FROM joint_goal_members');
        await db.customStatement('DELETE FROM avoided_purchases');
      });

      // 2. Clear Hive settings
      settings.hasCompletedOnboarding = false;
      settings.currency = '₴';
      settings.locale = 'uk';
      settings.themeMode = 'system';
      settings.privacyMode = false;
      settings.isSoundEnabled = true;
      settings.isHapticEnabled = true;
      settings.openRouterApiKey = '';
      settings.coachPersonality = 'hacker';
      settings.blacklistedCategories = [];
      settings.activeBounty = null;
      settings.dailyQuests = null;
      settings.dailyQuestsDate = '';
      settings.lastSpinDate = null;
      settings.isBiometricEnabled = false;

      // 3. Clear milestone tracking
      await MilestoneService().clearAll();
      await WeeklyChallengeService().clearAll();
      await GoalDependencyService().clearAll();

      // 4. Navigate to onboarding
      if (!context.mounted) return;
      HapticFeedback.heavyImpact();
      context.go('/welcome');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.get(ref.read(localeProvider), 'settings_reset_error')}$e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Handle daily reminder toggle — schedule/cancel push notification.
  Future<void> _onReminderChanged(bool enabled) async {
    if (enabled) {
      final settingsLocal = ref.read(settingsServiceProvider);
      final notifService = NotificationService();
      await notifService.requestPermissions();
      await notifService.scheduleDailyReminder(
        hour: settingsLocal.reminderHour,
        minute: settingsLocal.reminderMinute,
      );
    } else {
      await NotificationService().cancelAll();
    }
  }

  /// Handle biometric toggle — authenticate before enabling.
  Future<void> _handleBiometricToggle(bool val) async {
    HapticFeedback.lightImpact();
    final settings = ref.read(settingsServiceProvider);
    final locale = ref.read(localeProvider);
    final brightness = Theme.of(context).brightness;
    final bio = BiometricService();

    if (val) {
      // Enabling — require successful authentication first
      final reason = AppLocalizations.get(locale, 'biometric_auth_reason');
      final success = await bio.authenticate(reason: reason);

      if (!mounted) return;

      if (success) {
        setState(() => _biometricEnabled = true);
        settings.isBiometricEnabled = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.get(locale, 'biometric_success'),
              style: AppTypography.bodySmall(context, color: AppColors.success),
            ),
          ),
        );
      } else {
        // Auth failed — keep toggle OFF
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.get(locale, 'biometric_failed'),
              style: AppTypography.bodySmall(context, color: Colors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } else {
      // Disabling — just turn off, no auth needed
      setState(() => _biometricEnabled = false);
      settings.isBiometricEnabled = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.get(locale, 'biometric_disabled'),
            style: AppTypography.bodySmall(context),
          ),
        ),
      );
    }
  }

  /// Toggle row: icon + title + subtitle + Switch.
  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 22.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body(context),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: AppTypography.caption(context),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  /// Theme mode segment button.
  Widget _buildThemeSegment({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final brightness = Theme.of(context).brightness;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border(brightness),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall(
            context,
            color: isSelected ? AppColors.accent : null,
          ),
        ),
      ),
    );
  }

  /// Selector row: title + option chips.
  Widget _buildSelectorItem({
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.bodySmall(context),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: options.map((opt) {
            final bool isSelected = value == opt;
            final brightness = Theme.of(context).brightness;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelected(opt),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.border(brightness),
                    ),
                  ),
                  child: Text(
                    opt,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall(
                      context,
                      color: isSelected ? AppColors.accent : null,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
