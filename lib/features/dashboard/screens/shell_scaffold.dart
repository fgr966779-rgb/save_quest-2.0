import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';

/// Clean Material 3 shell scaffold with standard [NavigationBar].
/// Replaces the old glassmorphic floating dock + particle background.
class ShellScaffold extends ConsumerWidget {
  final Widget child;

  const ShellScaffold({
    super.key,
    required this.child,
  });

  // --- Route → tab index mapping ---

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/analytics')) return 1;
    if (location.startsWith('/history')) return 2;
    if (location.startsWith('/streak')) return 3;
    if (location.startsWith('/settings')) return 4;
    // /trophies now maps to streak tab (index 3) — or keep its own slot.
    // The new nav has 5 items: Home, Analytics, History, Streak, Settings.
    // Trophies is accessible from Streak page or Settings.
    if (location.startsWith('/trophies')) return 3;
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
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _getSelectedIndex(context);
    final currentLocale = ref.watch(localeProvider);
    final brightness = Theme.of(context).brightness;
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      body: SafeArea(
        bottom: false,
        child: _PenaltyGrayscaleWrapper(child: child),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        height: 80,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: t('nav_home'),
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: t('nav_analytics'),
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: t('nav_history'),
          ),
          NavigationDestination(
            icon: Icon(Icons.local_fire_department_outlined),
            selectedIcon: Icon(Icons.local_fire_department_rounded),
            label: t('nav_streak'),
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: t('nav_options'),
          ),
        ],
      ),
    );
  }
}

/// Wraps the child in a [ColorFiltered] grayscale matrix when the user has
/// active penalties (penaltyBalance > 0). No shake animation.
class _PenaltyGrayscaleWrapper extends ConsumerWidget {
  final Widget child;
  const _PenaltyGrayscaleWrapper({required this.child});

  static const ColorFilter _grayscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ]);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        final hasPenalty = profile != null && profile.penaltyBalance > 0;
        if (hasPenalty) {
          return ColorFiltered(colorFilter: _grayscale, child: child);
        }
        return child;
      },
      loading: () => child,
      error: (_, __) => child,
    );
  }
}
