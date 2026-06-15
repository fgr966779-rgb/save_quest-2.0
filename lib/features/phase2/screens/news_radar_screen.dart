import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsRadarScreen extends ConsumerStatefulWidget {
  const NewsRadarScreen({super.key});

  @override
  ConsumerState<NewsRadarScreen> createState() => _NewsRadarScreenState();
}

class _NewsRadarScreenState extends ConsumerState<NewsRadarScreen> {
  static const _mockNews = [
    _MockNews('НБУ підвищив облікову ставку', 'Рішення вплине на депозитні ставки банків', 'economy', 85, true, 'Розгляньте перекладання коштів на депозит з вищою ставкою'),
    _MockNews('Долар слабшає до євро', 'EUR/USD досяг рівня 1.09 на тлі даних CPI', 'currency', 72, false, null),
    _MockNews('Bitcoin пробив \$70k', 'Криптовалюта знову у бичачому тренді', 'crypto', 60, false, null),
    _MockNews('Роздрібні продажі зросли', 'Попит на електроніку та меблі зріс на 12%', 'retail', 45, true, 'Може зрости ціна на ваш цільовий товар'),
  ];

  static const _catColors = {
    'economy': Colors.green,
    'currency': Colors.amber,
    'crypto': Colors.orange,
    'retail': Colors.cyan,
    'tech': Colors.blue,
  };

  List<bool> _read = [];

  @override
  void initState() {
    super.initState();
    _read = List.filled(_mockNews.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('INFO SCAN', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _mockNews.length,
        itemBuilder: (ctx, i) {
          final n = _mockNews[i];
          final color = _catColors[n.category] ?? Colors.cyan;
          final isRead = _read[i];
          return GestureDetector(
            onTap: () => setState(() => _read[i] = true),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isRead ? Colors.white12 : (color as Color).withValues(alpha: 0.5)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  if (!isRead)
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.cyan, shape: BoxShape.circle)),
                  if (!isRead) const SizedBox(width: 8),
                  Expanded(child: Text(n.title, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                    child: Text(n.category.toUpperCase(), style: GoogleFonts.orbitron(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ]),
                const SizedBox(height: 8),
                Text(n.summary, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 13, height: 1.4)),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: n.relevance / 100, backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('\$1%', style: GoogleFonts.orbitron(color: color, fontSize: 11)),
                ]),
                if (n.isActionable && n.aiSuggestion != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.withValues(alpha: 0.3))),
                    child: Row(children: [
                      const Icon(Icons.lightbulb, color: Colors.green, size: 14),
                      const SizedBox(width: 8),
                      Expanded(child: Text(n.aiSuggestion!, style: GoogleFonts.shareTechMono(color: Colors.green.withValues(alpha: 0.9), fontSize: 12))),
                    ]),
                  ),
                ],
              ]),
            ),
          );
        },
      ),
    );
  }
}

class _MockNews {
  final String title, summary, category;
  final int relevance;
  final bool isActionable;
  final String? aiSuggestion;
  const _MockNews(this.title, this.summary, this.category, this.relevance, this.isActionable, this.aiSuggestion);
}
