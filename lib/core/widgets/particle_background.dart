import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class Particle {
  Offset position;
  double size;
  double speed;
  double opacity;
  double angle;
  double phase;
  double pulseSpeed;
  int colorPick;

  Particle({
    required this.position,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.angle,
    required this.phase,
    required this.pulseSpeed,
    required this.colorPick,
  });

  void update(Size bounds, double dt) {
    position = Offset(
      position.dx + math.cos(angle) * speed,
      position.dy + math.sin(angle) * speed,
    );

    phase += pulseSpeed * dt;

    // Screen wrapping with padding
    if (position.dx < -20) position = Offset(bounds.width + 10, position.dy);
    if (position.dx > bounds.width + 20) position = Offset(-10, position.dy);
    if (position.dy < -20) position = Offset(position.dx, bounds.height + 10);
    if (position.dy > bounds.height + 20) position = Offset(position.dx, -10);
  }
}

class ParticleBackground extends StatefulWidget {
  final int count;
  final Widget? child;

  const ParticleBackground({
    Key? key,
    this.count = 32,
    this.child,
  }) : super(key: key);

  @override
  _ParticleBackgroundState createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _auroraController;
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();
  Size _lastSize = Size.zero;
  Duration _lastTick = Duration.zero;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(_onParticleTick)..repeat();

    // Aurora moves much slower than particles
    _auroraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  void _onParticleTick() {
    final now = _particleController.lastElapsedDuration ?? Duration.zero;
    final dt = (now - _lastTick).inMilliseconds / 16.0;
    _lastTick = now;
    if (_lastSize != Size.zero) {
      for (final p in _particles) {
        p.update(_lastSize, dt.clamp(0.5, 2.0));
      }
      if (mounted) setState(() {});
    }
  }

  void _initializeParticles(Size size) {
    _particles.clear();
    for (int i = 0; i < widget.count; i++) {
      _particles.add(
        Particle(
          position: Offset(
            _random.nextDouble() * size.width,
            _random.nextDouble() * size.height,
          ),
          size: _random.nextDouble() * 2.4 + 0.8,
          speed: _random.nextDouble() * 0.25 + 0.08,
          opacity: _random.nextDouble() * 0.5 + 0.15,
          angle: _random.nextDouble() * 2 * math.pi,
          phase: _random.nextDouble() * math.pi * 2,
          pulseSpeed: _random.nextDouble() * 0.04 + 0.015,
          colorPick: _random.nextInt(3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _auroraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (size.isEmpty || size.width <= 0 || size.height <= 0) {
          return const SizedBox.expand();
        }
        if (_lastSize != size) {
          _lastSize = size;
          _initializeParticles(size);
        }

        return Stack(
          children: [
            // Base midnight canvas
            Positioned.fill(
              child: Container(color: AppColors.background),
            ),
            // Animated aurora gradient mesh
            Positioned.fill(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _auroraController,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _AuroraPainter(_auroraController.value),
                    );
                  },
                ),
              ),
            ),
            // Soft vignette to anchor the eye
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withOpacity(0.55),
                      ],
                      stops: const [0.55, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            // Glowing particles
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _ParticlePainter(_particles),
                ),
              ),
            ),
            if (widget.child != null) widget.child!,
          ],
        );
      },
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final double t; // 0..1, repeating

  _AuroraPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Three drifting radial blobs with subtle parallax.
    final blobs = <_Blob>[
      _Blob(
        center: Offset(
          w * (0.25 + 0.18 * math.sin(t * 2 * math.pi)),
          h * (0.28 + 0.12 * math.cos(t * 2 * math.pi)),
        ),
        radius: math.max(w, h) * 0.62,
        color: AppColors.cyanAccent.withOpacity(0.22),
      ),
      _Blob(
        center: Offset(
          w * (0.78 + 0.15 * math.cos((t + 0.33) * 2 * math.pi)),
          h * (0.30 + 0.18 * math.sin((t + 0.33) * 2 * math.pi)),
        ),
        radius: math.max(w, h) * 0.58,
        color: AppColors.magentaAccent.withOpacity(0.18),
      ),
      _Blob(
        center: Offset(
          w * (0.50 + 0.22 * math.sin((t + 0.66) * 2 * math.pi)),
          h * (0.78 + 0.10 * math.cos((t + 0.66) * 2 * math.pi)),
        ),
        radius: math.max(w, h) * 0.70,
        color: AppColors.purpleGlow.withOpacity(0.20),
      ),
    ];

    for (final b in blobs) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [b.color, b.color.withOpacity(0.0)],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromCircle(center: b.center, radius: b.radius))
        ..blendMode = BlendMode.plus;
      canvas.drawCircle(b.center, b.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) => oldDelegate.t != t;
}

class _Blob {
  final Offset center;
  final double radius;
  final Color color;

  _Blob({required this.center, required this.radius, required this.color});
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      if (!(p.position.dx.isFinite && p.position.dy.isFinite && p.size.isFinite && p.size > 0)) {
        continue;
      }
      final pulse = 0.5 + 0.5 * math.sin(p.phase);
      final effectiveOpacity = (p.opacity * (0.55 + 0.45 * pulse)).clamp(0.0, 1.0);
      final color = switch (p.colorPick) {
        0 => AppColors.cyanAccent,
        1 => AppColors.magentaAccent,
        _ => AppColors.goldAccent,
      };

      // Soft halo via radial gradient (Flutter Web-safe)
      final haloRadius = p.size * 5.0;
      final haloPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(effectiveOpacity * 0.35),
            color.withOpacity(0.0),
          ],
        ).createShader(Rect.fromCircle(center: p.position, radius: haloRadius));
      canvas.drawCircle(p.position, haloRadius, haloPaint);

      // Bright core
      final core = Paint()..color = color.withOpacity(effectiveOpacity);
      canvas.drawCircle(p.position, p.size, core);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
