import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../../core/services/yearly_report_service.dart';

class AnnualReportScreen extends ConsumerStatefulWidget {
  const AnnualReportScreen({super.key});

  @override
  ConsumerState<AnnualReportScreen> createState() => _AnnualReportScreenState();
}

class _AnnualReportScreenState extends ConsumerState<AnnualReportScreen> {
  final GlobalKey _globalKey = GlobalKey();
  int _debugYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final reportService = ref.watch(yearlyReportServiceProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder<AnnualReportData>(
            future: reportService.generateReport(_debugYear),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

              final data = snapshot.data!;
              if (data.totalDeposits == 0 && data.goalsCompleted == 0) {
                return _buildEmptyState();
              }

              return PageView(
                scrollDirection: Axis.vertical,
                children: [
                  _buildAnimatedSlide(_buildSlide('Ваш $_debugYear', 'Кибер-путешествие', Icons.rocket_launch, Colors.cyanAccent)),
                  _buildAnimatedSlide(_buildMetricSlide('Накоплено', '${(data.totalDeposits / 100).toStringAsFixed(0)} ₴', Colors.greenAccent)),
                  _buildAnimatedSlide(_buildMetricSlide('Боссов побеждено', '${data.goalsCompleted}', Colors.redAccent)),
                  _buildAnimatedSlide(_buildMetricSlide('Макс. Стрик', '${data.maxStreak} дней', Colors.purpleAccent)),
                  _buildAnimatedSlide(_buildFinalSlide(data)),
                ],
              );
            },
          ),
          Positioned(top: 40, right: 20, child: IconButton(icon: const Icon(Icons.bug_report, color: Colors.white), onPressed: () => setState(() => _debugYear--))),
          Positioned(top: 80, right: 20, child: IconButton(icon: const Icon(Icons.bug_report, color: Colors.white), onPressed: () => setState(() => _debugYear++))),
        ],
      ),
    );
  }

  Widget _buildAnimatedSlide(Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, val, _) => Opacity(opacity: val, child: Transform.translate(offset: Offset(0, 50 * (1 - val)), child: child)),
    );
  }

  Widget _buildSlide(String title, String subtitle, IconData icon, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 64),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          Text(subtitle, style: TextStyle(color: color, fontSize: 18, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _buildMetricSlide(String title, String value, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 20, fontFamily: 'monospace')),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: int.parse(value.replaceAll(RegExp(r'[^0-9]'), ''))),
            duration: const Duration(seconds: 2),
            builder: (context, val, child) => Text(
              '$val ${value.contains(' ') ? value.split(' ')[1] : ''}',
              style: TextStyle(color: color, fontSize: 48, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, color: Colors.amber, size: 64),
            const SizedBox(height: 20),
            const Text('Твой путь только начинается', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            const SizedBox(height: 10),
            Text('Оракул говорит: великие свершения ждут тебя впереди.', style: TextStyle(color: Colors.grey[400], fontSize: 16, fontFamily: 'monospace'), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalSlide(AnnualReportData data) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ваш Титул Года', style: TextStyle(color: Colors.grey, fontSize: 20, fontFamily: 'monospace')),
              Text(data.title, style: const TextStyle(color: Colors.amberAccent, fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _shareReport,
                icon: const Icon(Icons.share),
                label: const Text('Поделиться'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareReport() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/annual_report.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Мой киберпанк-отчет за год!');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
