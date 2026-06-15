import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class InventoryStalkerScreen extends ConsumerStatefulWidget {
  const InventoryStalkerScreen({super.key});

  @override
  ConsumerState<InventoryStalkerScreen> createState() => _InventoryStalkerScreenState();
}

class _InventoryStalkerScreenState extends ConsumerState<InventoryStalkerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ghostCtrl;

  @override
  void initState() {
    super.initState();
    _ghostCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ghostCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('STOCK GHOST', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[300],
        onPressed: () => _addGhost(context, db),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: FutureBuilder<List<InventoryStalkerItem>>(
        future: db.select(db.inventoryStalkerItems).get(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text('Слідкуйте за наявністю товарів', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              final statusColor = item.stockStatus == 'in_stock' ? Colors.green : (item.stockStatus == 'out_of_stock' ? Colors.red : Colors.orange);
              final isGhost = item.stockStatus == 'out_of_stock';
              
              return AnimatedBuilder(
                animation: _ghostCtrl,
                builder: (context, child) {
                  return Opacity(
                    opacity: isGhost ? 0.6 + (_ghostCtrl.value * 0.4) : 1.0,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F2E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                        boxShadow: isGhost ? [BoxShadow(color: Colors.white.withValues(alpha: _ghostCtrl.value * 0.1), blurRadius: 20)] : [],
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(item.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          if (isGhost) Icon(Icons.visibility_off, color: Colors.white54, size: 20)
                          else Icon(Icons.check_circle, color: Colors.green, size: 20),
                        ]),
                        const SizedBox(height: 12),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(item.storeName, style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 14)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                            child: Text(item.stockStatus.toUpperCase(), style: GoogleFonts.orbitron(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        if (item.currentPrice != null)
                          Text('Ціна: ${(item.currentPrice! / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 16))
                        else if (item.lastInStockPrice != null)
                          Text('Остання ціна: ${(item.lastInStockPrice! / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 14)),
                        
                        const SizedBox(height: 16),
                        Row(children: [
                          Icon(item.notifyWhenBack ? Icons.notifications_active : Icons.notifications_off, color: item.notifyWhenBack ? Colors.grey[300] : Colors.white24, size: 16),
                          const SizedBox(width: 8),
                          Text('Сповістити про наявність', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
                        ]),
                      ]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _addGhost(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Стежити за товаром', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Товар (напр. RTX 5090)', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
            onPressed: () async {
              await db.into(db.inventoryStalkerItems).insert(InventoryStalkerItemsCompanion.insert(
                productName: 'NVIDIA RTX 5090',
                storeName: 'Telemart',
                stockStatus: 'out_of_stock',
                lastInStockPrice: const drift.Value(9000000),
                notifyWhenBack: const drift.Value(true),
                addedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Стежити', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
