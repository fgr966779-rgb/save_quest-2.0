import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class Particle {
  Offset position;
  double size;
  double speed;
  double opacity;
  double angle;

  Particle({
    required this.position,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.angle,
  });

  void update(Size bounds) {
    position = Offset(
      position.dx + math.cos(angle) * speed,
      position.dy + math.sin(angle) * speed,
    );

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
    this.count = 25,
    this.child,
  }) : super(key: key);

  @override
  _ParticleBackgroundState createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        if (_lastSize != Size.zero) {
          for (final p in _particles) {
            p.update(_lastSize);
          }
          setState(() {});
        }
      })..repeat();
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
          size: _random.nextDouble() * 3.0 + 1.0,
          speed: _random.nextDouble() * 0.2 + 0.1,
          opacity: _random.nextDouble() * 0.4 + 0.1,
          angle: _random.nextDouble() * 2 * math.pi,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        // Guard: skip painting if size is not yet valid
        if (size.isEmpty || size.width <= 0 || size.height <= 0) {
          return const SizedBox.expand();
        }
        if (_lastSize != size) {
          _lastSize = size;
          _initializeParticles(size);
        }

        return Stack(
          children: [
            // Dark solid canvas underneath
            Positioned.fill(
              child: Container(color: AppColors.background),
            ),
            // CustomPaint layer
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

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = (p.opacity > 0.3)
            ? AppColors.cyanAccent.withOpacity(p.opacity)
            : AppColors.magentaAccent.withOpacity(p.opacity);
      // Note: MaskFilter.blur removed — causes validators.dart:29 assertion on Flutter Web

      if (p.position.dx.isFinite && p.position.dy.isFinite && p.size.isFinite && p.size > 0) {
        canvas.drawCircle(p.position, p.size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
