import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';

/// Premium Material 3 shell scaffold with ambient background radial glows and standard [NavigationBar].
/// Replaces the flat solid background with high-end cyberpunk/glassmorphic atmosphere.
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
    final isDark = brightness == Brightness.dark;
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Beautiful Ambient Radial Background Blobs ──
          Positioned.fill(
            child: Container(
              color: AppColors.background(brightness),
            ),
          ),
          if (isDark) ...[
            // Cyber electric indigo glow top-right
            Positioned(
              top: -120,
              right: -120,
              width: 320,
              height: 320,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                ),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            // Cyber pink/magenta glow bottom-left
            Positioned(
              bottom: 80,
              left: -150,
              width: 350,
              height: 350,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEC4899).withValues(alpha: 0.05),
                ),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ] else ...[
            // Warm sky-blue glow top-right for light mode
            Positioned(
              top: -80,
              right: -80,
              width: 280,
              height: 280,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF818CF8).withValues(alpha: 0.08),
                ),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ],
          // ── Main Page Content ──
          SafeArea(
            bottom: false,
            child: _PenaltyGlitchWrapper(child: child),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
              width: 1.0,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) => _onItemTapped(context, index),
          height: 80,
          backgroundColor: isDark ? const Color(0xFF111113).withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.9),
          elevation: 0,
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
      ),
    );
  }
}

/// Wraps the child in a [ColorFiltered] and animated layout if the user has
/// active penalties (penaltyBalance > 0), causing screen shaking, scanlines, and color glitching.
class _PenaltyGlitchWrapper extends ConsumerStatefulWidget {
  final Widget child;
  const _PenaltyGlitchWrapper({required this.child});

  @override
  ConsumerState<_PenaltyGlitchWrapper> createState() => _PenaltyGlitchWrapperState();
}

class _PenaltyGlitchWrapperState extends ConsumerState<_PenaltyGlitchWrapper> {
  Timer? _timer;
  bool _isGlitching = false;
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _startGlitchTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGlitchTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      
      final profileAsync = ref.read(userProfileProvider);
      final hasPenalty = profileAsync.value != null && profileAsync.value!.penaltyBalance > 0;
      if (!hasPenalty) {
        if (_isGlitching) {
          setState(() {
            _isGlitching = false;
            _offsetX = 0.0;
            _offsetY = 0.0;
          });
        }
        return;
      }

      // Trigger a brief glitch sequence
      _triggerGlitch();
    });
  }

  Future<void> _triggerGlitch() async {
    for (int i = 0; i < 4; i++) {
      if (!mounted) return;
      setState(() {
        _isGlitching = true;
        _offsetX = (_random.nextDouble() - 0.5) * 8.0;
        _offsetY = (_random.nextDouble() - 0.5) * 8.0;
      });
      await Future.delayed(Duration(milliseconds: 50 + _random.nextInt(50)));
    }
    if (mounted) {
      setState(() {
        _isGlitching = false;
        _offsetX = 0.0;
        _offsetY = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final settings = ref.watch(settingsServiceProvider);
    final isDetox = settings.isDopamineDetoxActive;

    Widget current = profileAsync.when(
      data: (profile) {
        final hasPenalty = profile != null && profile.penaltyBalance > 0;
        if (!hasPenalty) {
          return widget.child;
        }

        Widget inner = widget.child;

        // Apply shake transform during active glitch spikes
        if (_isGlitching) {
          inner = Transform.translate(
            offset: Offset(_offsetX, _offsetY),
            child: inner,
          );
        }

        // Apply matrix color filter (grayscaled with red/cyan aberration look)
        final filter = _isGlitching ? _glitchFilter : _warningFilter;
        inner = ColorFiltered(
          colorFilter: filter,
          child: inner,
        );

        // Overlay horizontal scanline glitches
        return Stack(
          children: [
            inner,
            if (_isGlitching)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _GlitchLinePainter(_random),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => widget.child,
      error: (_, __) => widget.child,
    );

    if (isDetox) {
      current = ColorFiltered(
        colorFilter: _detoxGrayscaleFilter,
        child: current,
      );
    }

    return current;
  }

  static const ColorFilter _detoxGrayscaleFilter = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ]);

  static const ColorFilter _warningFilter = ColorFilter.matrix(<double>[
    0.6, 0.2, 0.2, 0, 30, // Red tint desaturated
    0.2, 0.4, 0.2, 0, 0,
    0.2, 0.2, 0.4, 0, 0,
    0,   0,   0,   1, 0,
  ]);

  static const ColorFilter _glitchFilter = ColorFilter.matrix(<double>[
    1.0, 0.0, 0.0, 0, 50,  // Severe color shift
    0.0, 0.2, 0.0, 0, 0,
    0.0, 0.0, 1.2, 0, 20,
    0,   0,   0,   1, 0,
  ]);
}

class _GlitchLinePainter extends CustomPainter {
  final math.Random random;
  _GlitchLinePainter(this.random);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.3)
      ..strokeWidth = 2.0;

    final paintRed = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.4)
      ..strokeWidth = 3.0;

    // Draw random horizontal lines
    final int lines = 3 + random.nextInt(3);
    for (int i = 0; i < lines; i++) {
      final y = random.nextDouble() * size.height;
      final isRed = random.nextBool();
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        isRed ? paintRed : paint,
      );
      
      // Draw a block sometimes
      if (random.nextDouble() < 0.4) {
        final blockHeight = 4.0 + random.nextInt(8);
        final blockWidth = size.width * (0.1 + random.nextDouble() * 0.3);
        final blockX = random.nextDouble() * (size.width - blockWidth);
        canvas.drawRect(
          Rect.fromLTWH(blockX, y - blockHeight / 2, blockWidth, blockHeight),
          Paint()..color = (isRed ? Colors.redAccent : Colors.cyanAccent).withValues(alpha: 0.25),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GlitchLinePainter oldDelegate) => true;
}
