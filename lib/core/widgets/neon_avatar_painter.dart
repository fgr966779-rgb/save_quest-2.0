import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/avatar_config.dart';
import '../../features/gamification/models/reward_model.dart';

/// CustomPainter for the user avatar with chassis, visor, decals, damage, and badge orbit.
/// Uses only current AppColors tokens — no legacy neon colors.
class NeonAvatarPainter extends CustomPainter {
  final AvatarConfig config;
  final Brightness brightness;

  NeonAvatarPainter({required this.config, this.brightness = Brightness.dark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);
    final double radius = w * 0.45;
    Color pColor = config.primaryColor;

    // Apply Damage/Integrity effects
    final double dmg = 1.0 - config.integrity.clamp(0.0, 1.0);
    if (dmg > 0) {
      pColor = Color.lerp(pColor, Colors.redAccent, dmg * 0.8) ?? pColor;
    }

    final bgPaint = Paint()
      ..color = pColor.withValues(alpha: 0.15 * (1.0 - dmg * 0.5))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    final linePaint = Paint()
      ..color = AppColors.border(brightness)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final innerBgPaint = Paint()
      ..color = AppColors.surface(brightness)
      ..style = PaintingStyle.fill;

    // Draw base ring
    canvas.drawCircle(center, radius, bgPaint);

    // Draw Chassis
    Path chassisPath = Path();
    if (config.chassis == 'heavy') {
      chassisPath.moveTo(w * 0.2, h * 0.2);
      chassisPath.lineTo(w * 0.8, h * 0.2);
      chassisPath.lineTo(w * 0.85, h * 0.8);
      chassisPath.lineTo(w * 0.5, h * 0.95);
      chassisPath.lineTo(w * 0.15, h * 0.8);
      chassisPath.close();
    } else if (config.chassis == 'sleek') {
      chassisPath.moveTo(w * 0.3, h * 0.1);
      chassisPath.lineTo(w * 0.7, h * 0.1);
      chassisPath.lineTo(w * 0.85, h * 0.4);
      chassisPath.lineTo(w * 0.5, h * 0.9);
      chassisPath.lineTo(w * 0.15, h * 0.4);
      chassisPath.close();
    } else { // standard
      chassisPath.moveTo(w * 0.25, h * 0.15);
      chassisPath.lineTo(w * 0.75, h * 0.15);
      chassisPath.lineTo(w * 0.8, h * 0.6);
      chassisPath.lineTo(w * 0.6, h * 0.85);
      chassisPath.lineTo(w * 0.4, h * 0.85);
      chassisPath.lineTo(w * 0.2, h * 0.6);
      chassisPath.close();
    }

    canvas.drawPath(chassisPath, innerBgPaint);
    canvas.drawPath(chassisPath, linePaint);

    // Draw Decals
    final decalPaint = Paint()
      ..color = pColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (config.decal == 'striped') {
      canvas.drawLine(Offset(w * 0.3, h * 0.2), Offset(w * 0.3, h * 0.8), decalPaint);
      canvas.drawLine(Offset(w * 0.7, h * 0.2), Offset(w * 0.7, h * 0.8), decalPaint);
    } else if (config.decal == 'scar') {
      canvas.drawLine(Offset(w * 0.6, h * 0.25), Offset(w * 0.8, h * 0.45), decalPaint);
      canvas.drawLine(Offset(w * 0.75, h * 0.35), Offset(w * 0.85, h * 0.3), decalPaint);
    }

    // Draw Visor / Eyes
    final visorPaint = Paint()
      ..color = pColor
      ..style = PaintingStyle.fill;

    if (config.visor == 'dual') {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(w * 0.3, h * 0.4, w * 0.45, h * 0.5), const Radius.circular(4)), visorPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(w * 0.55, h * 0.4, w * 0.7, h * 0.5), const Radius.circular(4)), visorPaint);
    } else if (config.visor == 'scope') {
      canvas.drawCircle(Offset(w * 0.4, h * 0.45), w * 0.12, visorPaint);
      canvas.drawLine(Offset(w * 0.55, h * 0.45), Offset(w * 0.75, h * 0.45), Paint()..color = pColor..strokeWidth = 3.0);
    } else { // cyclops
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(w * 0.25, h * 0.4, w * 0.75, h * 0.5), const Radius.circular(6)), visorPaint);
    }

    // Outer glow for visor
    final eyeGlow = Paint()
      ..color = pColor.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8)
      ..style = PaintingStyle.fill;

    if (config.visor == 'dual') {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(w * 0.3, h * 0.4, w * 0.45, h * 0.5), const Radius.circular(4)), eyeGlow);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(w * 0.55, h * 0.4, w * 0.7, h * 0.5), const Radius.circular(4)), eyeGlow);
    } else if (config.visor == 'scope') {
      canvas.drawCircle(Offset(w * 0.4, h * 0.45), w * 0.12, eyeGlow);
      canvas.drawLine(Offset(w * 0.55, h * 0.45), Offset(w * 0.75, h * 0.45), Paint()..color = pColor.withValues(alpha: 0.6)..strokeWidth = 3.0..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6));
    } else { // cyclops
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(w * 0.25, h * 0.4, w * 0.75, h * 0.5), const Radius.circular(6)), eyeGlow);
    }

    // Draw static/noise lines if damaged (Visual Rot / Glitch)
    if (dmg > 0.1) {
      final rng = math.Random(config.xp); // Deterministic noise based on XP
      final noisePaint = Paint()
        ..color = Colors.redAccent.withValues(alpha: dmg * 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      // Horizontal scanning glitches
      for (int i = 0; i < (dmg * 15).toInt(); i++) {
        final dy = h * rng.nextDouble();
        final startX = w * rng.nextDouble() * 0.3;
        final endX = w * (0.7 + rng.nextDouble() * 0.3);

        canvas.drawLine(Offset(startX, dy), Offset(endX, dy), noisePaint);

        // Occasionally draw a solid block
        if (rng.nextDouble() < 0.3 * dmg) {
          canvas.drawRect(
            Rect.fromLTWH(startX, dy, w * 0.1, 2),
            Paint()..color = Colors.redAccent.withValues(alpha: dmg * 0.8)
          );
        }
      }

      // Digital "Rust" / Corrosion points
      if (dmg > 0.5) {
        final rustPaint = Paint()
          ..color = const Color(0xFF4A2C2C).withValues(alpha: dmg * 0.7)
          ..style = PaintingStyle.fill;
        for (int i = 0; i < (dmg * 20).toInt(); i++) {
          canvas.drawCircle(
            Offset(w * rng.nextDouble(), h * rng.nextDouble()),
            1.5 + rng.nextDouble() * 2,
            rustPaint
          );
        }
      }
    }

    // Draw Badges around the Avatar
    if (config.badges.isNotEmpty) {
      final int totalBadges = config.badges.length;
      final double badgeRadius = w * 0.55; // Slightly outside the avatar
      final double centerOffset = w / 2;

      for (int i = 0; i < totalBadges; i++) {
        final String badgeId = config.badges[i];
        final badgeDef = allRewards.firstWhere((b) => b.id == badgeId,
            orElse: () => allRewards.first);

        final double angle = (2 * math.pi * i) / totalBadges - (math.pi / 2);
        final double bx = centerOffset + badgeRadius * math.cos(angle);
        final double by = centerOffset + badgeRadius * math.sin(angle);

        // Draw small glow behind badge
        canvas.drawCircle(
          Offset(bx, by),
          w * 0.1,
          Paint()..color = pColor.withValues(alpha: 0.4)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
        );

        final TextSpan span = TextSpan(
          text: badgeDef.icon,
          style: TextStyle(fontSize: w * 0.15),
        );
        final TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, Offset(bx - tp.width / 2, by - tp.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant NeonAvatarPainter oldDelegate) {
    return oldDelegate.config.chassis != config.chassis ||
           oldDelegate.config.visor != config.visor ||
           oldDelegate.config.colorHex != config.colorHex ||
           oldDelegate.config.decal != config.decal ||
           oldDelegate.config.integrity != config.integrity ||
           oldDelegate.config.xp != config.xp ||
           oldDelegate.config.badges.length != config.badges.length ||
           oldDelegate.brightness != brightness;
  }
}

/// Convenience widget wrapping NeonAvatarPainter with brightness awareness.
class NeonAvatarWidget extends StatelessWidget {
  final AvatarConfig config;
  final double size;
  final Brightness brightness;

  const NeonAvatarWidget({
    super.key,
    required this.config,
    this.size = 100.0,
    this.brightness = Brightness.dark,
  });

  @override
  Widget build(BuildContext context) {
    // If brightness was not explicitly provided, infer from theme.
    final effectiveBrightness = brightness;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: NeonAvatarPainter(config: config, brightness: effectiveBrightness),
      ),
    );
  }
}
