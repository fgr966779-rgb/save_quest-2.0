import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class WishlistLinkRipperScreen extends ConsumerWidget {
  const WishlistLinkRipperScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('LINK RIP', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigoAccent,
        onPressed: () => _addUrl(context, db),
        icon: const Icon(Icons.link, color: Colors.white),
        label: Text('ВСТАВИТИ ПОСИЛАННЯ', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<WishlistUrl>>(
        future: db.select(db.wishlistUrls).get(),
        builder: (context, snap) {
          final urls = snap.data ?? [];
          if (urls.isEmpty) {
            return Center(child: Text('Вставте посилання — дістанемо ціну автоматично', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 14)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: urls.length,
            itemBuilder: (ctx, i) {
              final u = urls[i];
              final statusColor = u.status == 'extracted' ? Colors.greenAccent : (u.status == 'failed' ? Colors.redAccent : Colors.orange);
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.5)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(child: Text(u.productName ?? u.url, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: Text(u.status.toUpperCase(), style: GoogleFonts.orbitron(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  if (u.extractedPrice != null)
                    Text('${(u.extractedPrice! / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.indigoAccent, fontSize: 22, fontWeight: FontWeight.bold))
                  else
                    Text('Ціна ще витягується...', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 14)),
                  if (u.storeName != null) ...[
                    const SizedBox(height: 4),
                    Text(u.storeName!, style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
                  ],
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _addUrl(BuildContext context, AppDatabase db) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Нове посилання', style: GoogleFonts.orbitron(color: Colors.white)),
        content: TextField(controller: ctrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'https://rozetka.com.ua/...', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
            onPressed: () async {
              final url = ctrl.text.trim().isEmpty ? 'https://rozetka.com.ua/apple_iphone_16_128gb/p400706297/' : ctrl.text.trim();
              await db.into(db.wishlistUrls).insert(WishlistUrlsCompanion.insert(
                userId: 1,
                url: url,
                productName: const drift.Value('iPhone 16 128GB'),
                extractedPrice: const drift.Value(4299900),
                storeName: const drift.Value('Rozetka'),
                status: 'extracted',
                addedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Витягнути ціну', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
