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
import '../../../core/widgets/neon_avatar_painter.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/providers/banking_provider.dart';
import '../../../core/providers/events_notifier.dart';
import '../../../core/services/openrouter_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final GlobalKey _shareKey = GlobalKey();
  bool _isExporting = false;
  String _selectedLanguage = 'UA';

  // Local state for mock settings
  bool _dailyReminder = true;
  bool _achievementNotifications = true;
  bool _privacyMode = false;
  bool _biometricEnabled = false;
  bool _cloudBackup = true;

  Future<void> _exportShareCard() async {
    setState(() => _isExporting = true);
    HapticFeedback.mediumImpact();

    try {
      // Simulate rendering check and show success snackbar
      await Future.delayed(const Duration(seconds: 1));
      final RenderRepaintBoundary? boundary =
          _shareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary != null) {
        final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
        final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        
        if (byteData != null) {
          // Success mock sharing chimes
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.cardBg,
                content: Text(
                  'КАРТКУ УСПІШНО ЕКСПОРТОВАНО У ГАЛЕРЕЮ!',
                  style: AppTextStyles.orbitronHeading(fontSize: 11.0, color: AppColors.cyanAccent),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      // Handle error elegantly
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsServiceProvider);
    final userProfileAsync = ref.watch(userProfileProvider);
    final currentLocale = ref.watch(localeProvider);

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
              style: AppTextStyles.rajdhaniMedium(
                fontSize: 12.0,
                color: AppColors.cyanAccent,
              ).copyWith(letterSpacing: 2.0),
            ),
            Text(
              t('settings_core'),
              style: AppTextStyles.orbitronHeading(
                fontSize: 20.0,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24.0),

            // Shareable Card boundary
            Text(
              t('settings_export'),
              style: AppTextStyles.orbitronHeading(
                fontSize: 12.0,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            RepaintBoundary(
              key: _shareKey,
              child: GlassCard(
                padding: const EdgeInsets.all(20.0),
                borderColor: AppColors.cyanAccent.withOpacity(0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PIGGYVAULT SAVINGS',
                          style: AppTextStyles.orbitronHeading(
                            fontSize: 10.0,
                            color: AppColors.cyanAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(Icons.qr_code_2, color: AppColors.cyanAccent, size: 24),
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
                            if (profile != null && profile.avatarConfig != null && profile.avatarConfig!.isNotEmpty) ...[
                              NeonAvatarWidget(
                                config: AvatarConfig.fromJson(profile.avatarConfig!),
                                size: 50.0,
                              ),
                              const SizedBox(width: 16.0),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text(
                                  t('settings_rank'),
                                  style: AppTextStyles.rajdhaniMedium(fontSize: 10.0, color: AppColors.textSecondary),
                                ),
                                Text(
                                  'LEVEL $level',
                                  style: AppTextStyles.orbitronHeading(fontSize: 18.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  t('settings_streak'),
                                  style: AppTextStyles.rajdhaniMedium(fontSize: 10.0, color: AppColors.textSecondary),
                                ),
                                Text(
                                  '$streak',
                                  style: AppTextStyles.orbitronHeading(fontSize: 18.0, color: AppColors.magentaAccent),
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
            NeonButton(
              text: _isExporting ? '...' : t('settings_share_btn'),
              baseColor: AppColors.cyanAccent,
              glowColor: AppColors.cyanAccent,
              onPressed: _exportShareCard,
            ),
            const SizedBox(height: 32.0),

            // Customization Section
            Text(
              t('settings_custom'),
              style: AppTextStyles.orbitronHeading(
                fontSize: 12.0,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            NeonButton(
              text: t('settings_themes'),
              baseColor: AppColors.goldGlow,
              glowColor: AppColors.goldGlow,
              icon: const Icon(Icons.palette, color: Colors.black, size: 20),
              onPressed: () => context.push('/customization'),
            ),
            const SizedBox(height: 12.0),
            NeonButton(
              text: t('settings_skills'),
              baseColor: const Color(0xFF00E5FF),
              glowColor: const Color(0xFF00E5FF),
              icon: const Icon(Icons.account_tree_rounded, color: Colors.black, size: 20),
              onPressed: () => context.push('/skill-tree'),
            ),
            const SizedBox(height: 24.0),

            // AI Personality Selection
            Text(
              'МОДУЛЬ ОСОБИСТОСТІ ШІ',
              style: AppTextStyles.orbitronHeading(
                fontSize: 10.0,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AppColors.borderNeon.withOpacity(0.3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: settings.coachPersonality,
                  isExpanded: true,
                  dropdownColor: AppColors.cardBg,
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.cyanAccent),
                  style: const TextStyle(color: Colors.white, fontSize: 14.0),
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
                      // Invalidate AI insights so it fetches a new message from the new personality
                      ref.invalidate(aiInsightsProvider);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 32.0),

            // Controls Section
            Text(
              t('settings_signals'),
              style: AppTextStyles.orbitronHeading(
                fontSize: 12.0,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),

            // Audio effects toggle
            _buildToggleItem(
              icon: Icons.volume_up,
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
            const Divider(color: AppColors.borderNeon, height: 1.0),

            // Haptic adjustment
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
            const Divider(color: AppColors.borderNeon, height: 1.0),

            const Divider(color: AppColors.borderNeon, height: 1.0),

            // Notification Daily Reminder Scheduler
            _buildToggleItem(
              icon: Icons.notifications_active,
              title: t('settings_reminder'),
              subtitle: t('settings_reminder_sub'),
              value: _dailyReminder, 
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() => _dailyReminder = val);
              },
            ),
            const Divider(color: AppColors.borderNeon, height: 1.0),

            // 1. Achievement notifications
            _buildToggleItem(
              icon: Icons.emoji_events,
              title: t('settings_achievements'),
              subtitle: t('settings_achievements_sub'),
              value: _achievementNotifications,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() => _achievementNotifications = val);
              },
            ),
            const SizedBox(height: 32.0),

            // Anti-Goals Section
            Text(
              'ANTI-GOALS (АВТО-ШТРАФИ)',
              style: AppTextStyles.orbitronHeading(
                fontSize: 12.0,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            NeonButton(
              text: 'КЕРУВАННЯ BLACKLIST',
              baseColor: Colors.redAccent.withOpacity(0.2),
              glowColor: Colors.redAccent,
              icon: const Icon(Icons.block, color: Colors.redAccent, size: 20),
              onPressed: () => context.push('/blacklist'),
            ),
            const SizedBox(height: 32.0),

            // Security & Privacy Section
            Text(
              t('settings_security'),
              style: AppTextStyles.orbitronHeading(
                fontSize: 12.0,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            
            // 2. Privacy Mode (Hide balances)
            _buildToggleItem(
              icon: Icons.visibility_off,
              title: t('settings_privacy'),
              subtitle: t('settings_privacy_sub'),
              value: settings.privacyMode,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() => settings.privacyMode = val);
              },
            ),
            const Divider(color: AppColors.borderNeon, height: 1.0),

            // 3. Biometric login
            _buildToggleItem(
              icon: Icons.fingerprint,
              title: t('settings_biometric'),
              subtitle: t('settings_biometric_sub'),
              value: _biometricEnabled,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() => _biometricEnabled = val);
              },
            ),
            const SizedBox(height: 32.0),

            // Data & Backup Section
            Text(
              t('settings_data'),
              style: AppTextStyles.orbitronHeading(
                fontSize: 12.0,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),

            // 4. Cloud Backup
            _buildToggleItem(
              icon: Icons.cloud_upload,
              title: t('settings_cloud'),
              subtitle: t('settings_cloud_sub'),
              value: _cloudBackup,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() => _cloudBackup = val);
              },
            ),
            const SizedBox(height: 12.0),

            // 5. Export CSV
            NeonButton(
              text: t('settings_export_csv'),
              baseColor: AppColors.cardBgLight,
              glowColor: Colors.transparent,
              icon: const Icon(Icons.file_download, color: Colors.white, size: 20),
              onPressed: () {
                HapticFeedback.lightImpact();
              },
            ),
            const SizedBox(height: 12.0),

            // 6. Hard Reset
            NeonButton(
              text: t('settings_hard_reset'),
              baseColor: Colors.redAccent.withOpacity(0.2),
              glowColor: Colors.redAccent,
              icon: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 20),
              onPressed: () {
                HapticFeedback.heavyImpact();
              },
            ),
            const SizedBox(height: 32.0),

            // Others Section
            Text(
              t('settings_others'),
              style: AppTextStyles.orbitronHeading(
                fontSize: 12.0,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),

            // 7. Support
            NeonButton(
              text: t('settings_support'),
              baseColor: AppColors.cardBgLight,
              glowColor: Colors.transparent,
              icon: const Icon(Icons.help_outline, color: Colors.white, size: 20),
              onPressed: () => HapticFeedback.lightImpact(),
            ),
            const SizedBox(height: 12.0),

            // 8. Rate App
            NeonButton(
              text: t('settings_rate'),
              baseColor: AppColors.cardBgLight,
              glowColor: Colors.transparent,
              icon: const Icon(Icons.star_border, color: Colors.white, size: 20),
              onPressed: () => HapticFeedback.lightImpact(),
            ),
            const SizedBox(height: 12.0),

            // 9. Privacy Policy
            NeonButton(
              text: t('settings_policy'),
              baseColor: AppColors.cardBgLight,
              glowColor: Colors.transparent,
              icon: const Icon(Icons.privacy_tip_outlined, color: Colors.white, size: 20),
              onPressed: () => HapticFeedback.lightImpact(),
            ),
            const SizedBox(height: 32.0),

            // Debug Menu for Banking Simulation
            Text(
              'DEBUG / DEV TOOLS',
              style: AppTextStyles.orbitronHeading(
                fontSize: 12.0,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            GlassCard(
              padding: const EdgeInsets.all(16.0),
              borderColor: Colors.redAccent.withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'OpenRouter API Key (DeepSeek V4)',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    initialValue: settings.openRouterApiKey,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white, fontSize: 12.0),
                    decoration: InputDecoration(
                      hintText: 'sk-or-v1-...',
                      hintStyle: TextStyle(color: AppColors.textMuted.withOpacity(0.5)),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    onChanged: (val) {
                      settings.openRouterApiKey = val;
                      ref.invalidate(aiInsightsProvider);
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Bank Simulation Engine',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  NeonButton(
                    text: 'Згенерувати транзакцію',
                    baseColor: Colors.redAccent.withOpacity(0.2),
                    glowColor: Colors.transparent,
                    icon: const Icon(Icons.monetization_on, color: Colors.redAccent, size: 16),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      ref.read(mockBankingProvider.notifier).simulateRandomTransaction();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Нова транзакція згенерована!')),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  NeonButton(
                    text: 'Очистити історію банку',
                    baseColor: Colors.redAccent.withOpacity(0.2),
                    glowColor: Colors.transparent,
                    icon: const Icon(Icons.delete, color: Colors.redAccent, size: 16),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      ref.read(mockBankingProvider.notifier).clearTransactions();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Events Engine',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  NeonButton(
                    text: 'Згенерувати Cyber-Event',
                    baseColor: AppColors.magentaAccent.withOpacity(0.2),
                    glowColor: Colors.transparent,
                    icon: const Icon(Icons.public, color: AppColors.magentaAccent, size: 16),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      ref.read(eventsProvider.notifier).forceNewEvent();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Згенеровано новий івент!')),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  NeonButton(
                    text: 'Зупинити активний Event',
                    baseColor: AppColors.magentaAccent.withOpacity(0.2),
                    glowColor: Colors.transparent,
                    icon: const Icon(Icons.close, color: AppColors.magentaAccent, size: 16),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      ref.read(eventsProvider.notifier).clearEvent();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Remote Control Portal',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  NeonButton(
                    text: 'УПРАВЛІННЯ ПК (REMOTE CONTROL)',
                    baseColor: AppColors.cyanAccent.withOpacity(0.2),
                    glowColor: AppColors.cyanAccent,
                    icon: const Icon(Icons.settings_remote, color: AppColors.cyanAccent, size: 16),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      context.push('/remote-control');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),

            // 10. Language & Currency settings
            _buildSelectorItem(
              title: t('settings_currency'),
              value: settings.currency,
              options: ['₴', '\$', '€'],
              onSelected: (val) {
                HapticFeedback.lightImpact();
                setState(() {
                  settings.currency = val;
                });
                // Trigger consumer rebuilds
                ref.invalidate(goalsProvider);
              },
            ),
            const SizedBox(height: 16.0),
            _buildSelectorItem(
              title: t('settings_language'),
              value: currentLocale,
              options: ['UA', 'EN'],
              onSelected: (val) {
                HapticFeedback.lightImpact();
                ref.read(localeProvider.notifier).setLocale(val);
              },
            ),
            const SizedBox(height: 32.0),
            
            // 11. Version Info
            Center(
              child: Text(
                'Версія протоколу: v1.0.0.42-beta\nСистема PiggyVault © 2026',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.0,
                  color: AppColors.textMuted.withOpacity(0.5),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.cyanAccent, size: 24.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTextStyles.orbitronHeading(fontSize: 11.0, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10.0, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.cyanAccent,
            activeTrackColor: AppColors.cyanAccent.withOpacity(0.3),
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.cardBg,
          ),
        ],
      ),
    );
  }

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
          style: AppTextStyles.orbitronHeading(fontSize: 10.0, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: options.map((opt) {
            final bool isSelected = value == opt;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelected(opt),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.cyanAccent.withOpacity(0.15) : AppColors.cardBg.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: isSelected ? AppColors.cyanAccent : AppColors.borderNeon.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    opt,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 12.0,
                      color: isSelected ? AppColors.cyanAccent : Colors.white,
                      fontWeight: FontWeight.bold,
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
