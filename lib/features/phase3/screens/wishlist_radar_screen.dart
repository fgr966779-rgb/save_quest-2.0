import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;
import 'dart:math' as math;

class WishlistRadarScreen extends ConsumerStatefulWidget {
  const WishlistRadarScreen({super.key});

  @override
  ConsumerState<WishlistRadarScreen> createState() => _WishlistRadarScreenState();
}

class _WishlistRadarScreenState extends ConsumerState<WishlistRadarScreen> with SingleTickerProviderStateMixin {
  late AnimationController _radarCtrl;

  @override
  void initState() {
    super.initState();
    _radarCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() {
    _radarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('WISH RADAR', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () => _addWish(context, db),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: FutureBuilder<List<RadarWishItem>>(
        future: db.select(db.radarWishItems).get(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          return Column(
            children: [
              const SizedBox(height: 20),
              // Radar Animation
              SizedBox(
                width: 200, height: 200,
                child: CustomPaint(
                  painter: _RadarPainter(animation: _radarCtrl, color: Colors.greenAccent),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: items.isEmpty ? Center(child: Text('Радар порожній. Додайте ціль.', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16))) : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: items.length,
                  itemBuilder: (ctx, i) {
                    final w = items[i];
                    final targetHit = w.currentBestPrice != null && w.currentBestPrice! <= w.targetPrice;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F2E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: targetHit ? Colors.greenAccent : Colors.white12),
                        boxShadow: targetHit ? [BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.2), blurRadius: 12)] : [],
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(child: Text(w.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                          if (targetHit)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.greenAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                              child: Text('TARGET HIT', style: GoogleFonts.orbitron(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                        ]),
                        const SizedBox(height: 12),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('ЦІЛЬОВА ЦІНА', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                            Text('${(w.targetPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 16)),
                          ]),
                          if (w.currentBestPrice != null)
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              Text('ЗНАЙДЕНО ($1)', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                              Text('${(w.currentBestPrice! / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: targetHit ? Colors.greenAccent : Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
                            ]),
                        ]),
                        const SizedBox(height: 16),
                        Row(children: [
                          Icon(w.alertEnabled ? Icons.notifications_active : Icons.notifications_off, color: w.alertEnabled ? Colors.greenAccent : Colors.white24, size: 16),
                          const SizedBox(width: 8),
                          Text('Алерт: ${w.alertEnabled ? 'Увімкнено' : 'Вимкнено'}', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
                          const Spacer(),
                          Text(w.lastCheckedAt != null ? 'Оновлено: ${w.lastCheckedAt!.hour}:${w.lastCheckedAt!.minute.toString().padLeft(2, '0')}' : 'Сканування...', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10)),
                        ]),
                      ]),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addWish(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Нова ціль для радару', style: GoogleFonts.orbitron(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: const [
          TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Товар', hintStyle: TextStyle(color: Colors.white38))),
          SizedBox(height: 12),
          TextField(style: TextStyle(color: Colors.white), keyboardType: TextInputType.number, decoration: InputDecoration(hintText: 'Цільова ціна', hintStyle: TextStyle(color: Colors.white38))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
            onPressed: () async {
              await db.into(db.radarWishItems).insert(RadarWishItemsCompanion.insert(
                userId: 1,
                productName: 'Samsung Galaxy S24 Ultra',
                searchQuery: 'S24 Ultra 256',
                targetPrice: 4500000,
                currentBestPrice: const drift.Value(4800000),
                bestStore: const drift.Value('Citrus'),
                alertEnabled: const drift.Value(true),
                lastCheckedAt: drift.Value(DateTime.now()),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Почати пошук', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  _RadarPainter({required this.animation, required this.color}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final bgPaint = Paint()..color = color.withValues(alpha: 0.05)..style = PaintingStyle.fill;
    final borderPaint = Paint()..color = color.withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 2;
    
    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawCircle(center, radius, borderPaint);
    canvas.drawCircle(center, radius * 0.66, borderPaint);
    canvas.drawCircle(center, radius * 0.33, borderPaint);
    
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), borderPaint);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), borderPaint);

    final sweepPaint = Paint()
      ..shader = SweepGradient(
        colors: [Colors.transparent, color.withValues(alpha: 0.5)],
        stops: const [0.0, 1.0],
        transform: GradientRotation(animation.value * 2 * math.pi),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
      
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), animation.value * 2 * math.pi, math.pi / 2, true, sweepPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
