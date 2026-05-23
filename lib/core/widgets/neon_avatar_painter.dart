import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../../features/gamification/models/badge_model.dart';

class AvatarConfig {
  final String chassis;
  final String visor;
  final String colorHex;
  final String decal;
  final double integrity; // 0.0 (Broken) to 1.0 (Pristine)
  final int xp;
  final int credits;
  final List<String> ownedItems;
  final List<String> badges;

  const AvatarConfig({
    this.chassis = 'standard',
    this.visor = 'cyclops',
    this.colorHex = '#00E5FF', // default cyan
    this.decal = 'none',
    this.integrity = 1.0,
    this.xp = 0,
    this.credits = 0,
    this.ownedItems = const [],
    this.badges = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'chassis': chassis,
      'visor': visor,
      'colorHex': colorHex,
      'decal': decal,
      'integrity': integrity,
      'xp': xp,
      'credits': credits,
      'ownedItems': ownedItems,
      'badges': badges,
    };
  }

  factory AvatarConfig.fromMap(Map<String, dynamic> map) {
    return AvatarConfig(
      chassis: map['chassis'] ?? 'standard',
      visor: map['visor'] ?? 'cyclops',
      colorHex: map['colorHex'] ?? '#00E5FF',
      decal: map['decal'] ?? 'none',
      integrity: (map['integrity'] as num?)?.toDouble() ?? 1.0,
      xp: map['xp'] ?? 0,
      credits: map['credits'] ?? 0,
      ownedItems: List<String>.from(map['ownedItems'] ?? []),
      badges: List<String>.from(map['badges'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory AvatarConfig.fromJson(String source) {
    try {
      return AvatarConfig.fromMap(json.decode(source));
    } catch (e) {
      return const AvatarConfig(); // fallback
    }
  }

  AvatarConfig copyWith({
    String? chassis,
    String? visor,
    String? colorHex,
    String? decal,
    double? integrity,
    int? xp,
    int? credits,
    List<String>? ownedItems,
    List<String>? badges,
  }) {
    return AvatarConfig(
      chassis: chassis ?? this.chassis,
      visor: visor ?? this.visor,
      colorHex: colorHex ?? this.colorHex,
      decal: decal ?? this.decal,
      integrity: integrity ?? this.integrity,
      xp: xp ?? this.xp,
      credits: credits ?? this.credits,
      ownedItems: ownedItems ?? this.ownedItems,
      badges: badges ?? this.badges,
    );
  }

  Color get primaryColor {
    try {
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.cyanAccent;
    }
  }
}

class NeonAvatarPainter extends CustomPainter {
  final AvatarConfig config;

  NeonAvatarPainter({required this.config});

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
      ..color = pColor.withOpacity(0.15 * (1.0 - dmg * 0.5))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      
    final linePaint = Paint()
      ..color = AppColors.borderNeon
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final innerBgPaint = Paint()
      ..color = AppColors.background
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
      ..color = pColor.withOpacity(0.5)
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
    
    final glowPaint = Paint()
      ..color = AppColors.goldGlow.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..imageFilter = ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2); // slight internal glow

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
      ..color = pColor.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8)
      ..style = PaintingStyle.fill;
      
    if (config.visor == 'dual') {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(w * 0.3, h * 0.4, w * 0.45, h * 0.5), const Radius.circular(4)), eyeGlow);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(w * 0.55, h * 0.4, w * 0.7, h * 0.5), const Radius.circular(4)), eyeGlow);
    } else if (config.visor == 'scope') {
      canvas.drawCircle(Offset(w * 0.4, h * 0.45), w * 0.12, eyeGlow);
      canvas.drawLine(Offset(w * 0.55, h * 0.45), Offset(w * 0.75, h * 0.45), Paint()..color = pColor.withOpacity(0.6)..strokeWidth = 3.0..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6));
    } else { // cyclops
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(w * 0.25, h * 0.4, w * 0.75, h * 0.5), const Radius.circular(6)), eyeGlow);
    }

    // Draw static/noise lines if damaged
    if (dmg > 0.1) {
      final noisePaint = Paint()
        ..color = Colors.redAccent.withOpacity(dmg * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      
      // Pseudo-random static lines based on damage
      for (int i = 0; i < (dmg * 10).toInt(); i++) {
        final dy = h * 0.2 + (i * 0.1 * h);
        canvas.drawLine(Offset(w * 0.1, dy), Offset(w * 0.9, dy), noisePaint);
      }
    }

    // Draw Badges around the Avatar
    if (config.badges.isNotEmpty) {
      final int totalBadges = config.badges.length;
      final double radius = w * 0.55; // Slightly outside the avatar
      final double centerOffset = w / 2;

      for (int i = 0; i < totalBadges; i++) {
        final String badgeId = config.badges[i];
        final badgeDef = allBadges.firstWhere(
          (b) => b.id == badgeId, 
          orElse: () => allBadges.first
        );

        final double angle = (2 * math.pi * i) / totalBadges - (math.pi / 2);
        final double bx = centerOffset + radius * math.cos(angle);
        final double by = centerOffset + radius * math.sin(angle);

        // Draw small glow behind badge
        canvas.drawCircle(
          Offset(bx, by), 
          w * 0.1, 
          Paint()..color = pColor.withOpacity(0.4)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
        );

        final TextSpan span = TextSpan(
          text: badgeDef.emoji,
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
           oldDelegate.config.badges.length != config.badges.length;
  }
}

class NeonAvatarWidget extends StatelessWidget {
  final AvatarConfig config;
  final double size;

  const NeonAvatarWidget({
    Key? key,
    required this.config,
    this.size = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: NeonAvatarPainter(config: config),
      ),
    );
  }
}
