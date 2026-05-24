import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/particle_background.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/providers/l10n.dart';

class ShellScaffold extends ConsumerWidget {
  final Widget child;

  const ShellScaffold({
    Key? key,
    required this.child,
  }) : super(key: key);

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/analytics')) return 1;
    if (location.startsWith('/history')) return 2;
    if (location.startsWith('/streak')) return 3;
    if (location.startsWith('/trophies')) return 4;
    if (location.startsWith('/settings')) return 5;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/analytics');
        break;
      case 2:
        context.go('/history');
        break;
      case 3:
        context.go('/streak');
        break;
      case 4:
        context.go('/trophies');
        break;
      case 5:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _getSelectedIndex(context);
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Slow continuous neon particle floaters in background
          const ParticleBackground(),
          // Content with Glitch UI if infected
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 96.0), // Room for taller navigation dock
              child: Consumer(
                builder: (context, ref, childWidget) {
                  final profileAsync = ref.watch(userProfileProvider);
                  return profileAsync.when(
                    data: (profile) {
                      final hasVirus = profile != null && profile.penaltyBalance > 0;
                      if (hasVirus) {
                        return childWidget!.animate(onPlay: (c) => c.repeat())
                          .shake(hz: 3, duration: 1500.ms, curve: Curves.easeInOutCubic)
                          .tint(color: Colors.redAccent.withOpacity(0.1), duration: 2000.ms)
                          .then()
                          .tint(color: Colors.transparent, duration: 500.ms);
                      }
                      return childWidget!;
                    },
                    loading: () => childWidget!,
                    error: (_, __) => childWidget!,
                  );
                },
                child: child,
              ),
            ),
          ),
          // Glassmorphic navigation dock at bottom
          Positioned(
            left: 20.0,
            right: 20.0,
            bottom: 16.0,
            child: _buildNavigationDock(context, selectedIndex, t),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationDock(BuildContext context, int selectedIndex, String Function(String) t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          height: 76.0,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.cardBg.withOpacity(0.7)
                : Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.04),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
                blurRadius: 24.0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(context, 0, Icons.grid_view_rounded, selectedIndex == 0, t('nav_vault')),
              _buildNavItem(context, 1, Icons.analytics_outlined, selectedIndex == 1, t('nav_analytics')),
              _buildNavItem(context, 2, Icons.history_edu_rounded, selectedIndex == 2, t('nav_history')),
              _buildNavItem(context, 3, Icons.local_fire_department_rounded, selectedIndex == 3, t('nav_streak')),
              _buildNavItem(context, 4, Icons.emoji_events_outlined, selectedIndex == 4, t('nav_trophies')),
              _buildNavItem(context, 5, Icons.settings_suggest_outlined, selectedIndex == 5, t('nav_options')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, bool isActive, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = index % 2 == 0 ? AppColors.cyanAccent : AppColors.magentaAccent;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onItemTapped(context, index),
        child: AnimatedScale(
          scale: isActive ? 1.12 : 0.95,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated halo behind the active item
              if (isActive)
                IgnorePointer(
                  child: Container(
                    width: 56.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          activeColor.withOpacity(0.32),
                          activeColor.withOpacity(0.0),
                        ],
                      ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(0.85, 0.85),
                        end: const Offset(1.05, 1.05),
                        duration: 1600.ms,
                        curve: Curves.easeInOut,
                      )
                      .fadeIn(duration: 200.ms),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: Icon(
                      icon,
                      key: ValueKey<bool>(isActive),
                      color: isActive
                          ? activeColor
                          : (isDark ? AppColors.textMuted : AppColors.textLightMuted),
                      size: isActive ? 24.0 : 20.0,
                      shadows: isActive
                          ? [
                              Shadow(
                                color: activeColor.withOpacity(0.6),
                                blurRadius: 10.0,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isActive ? 9.5 : 8.5,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive
                          ? activeColor
                          : (isDark ? AppColors.textMuted : AppColors.textLightMuted),
                      letterSpacing: 0.2,
                    ),
                    child: Text(label, maxLines: 1),
                  ),
                  const SizedBox(height: 4.0),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    width: isActive ? 18.0 : 0.0,
                    height: 3.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          activeColor,
                          activeColor.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2.0),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: activeColor.withOpacity(0.6),
                                blurRadius: 8.0,
                                spreadRadius: 1.0,
                              ),
                            ]
                          : [],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
