import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvestmentMarketScreen extends ConsumerStatefulWidget {
  const InvestmentMarketScreen({super.key});

  @override
  ConsumerState<InvestmentMarketScreen> createState() =>
      _InvestmentMarketScreenState();
}

class _InvestmentMarketScreenState
    extends ConsumerState<InvestmentMarketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Киберпанк-термінал',
          style: TextStyle(fontFamily: 'monospace'),
        ),
      ),
      body: Column(
        children: [
          _buildDisclaimer(),
          Expanded(
            child: ListView(
              children: [
                _buildAssetRow('CyberCorp A', 'AAPL', '35 400.00 ₴', 10),
                _buildAssetRow('Nexus Search', 'GOOGL', '42 100.00 ₴', 5),
              ],
            ),
          ),
          _buildDebugTools(),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.red.withValues(alpha: 0.1),
      child: const Text(
        '⚠️ ВІРТУАЛЬНИЙ СИМУЛЯТОР. НЕ Є ФІНАНСОВОЮ ПОРАДОЮ. РЕАЛЬНІ ІНВЕСТИЦІЇ НЕ ЗДІЙСНЮЮТЬСЯ.',
        style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAssetRow(String name, String ticker, String price, int count) {
    return ListTile(
      title:
          Text(name, style: const TextStyle(color: Colors.white, fontFamily: 'monospace')),
      subtitle: Text(ticker,
          style: const TextStyle(color: Colors.cyanAccent, fontFamily: 'monospace')),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(price,
              style: const TextStyle(color: Colors.white, fontFamily: 'monospace')),
          Text('$count шт.',
              style: const TextStyle(color: Colors.grey, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  /// Debug panel — placeholder for future XP timer controls.
  Widget _buildDebugTools() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        'DEBUG: Simulation mode active',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 11,
          fontFamily: 'monospace',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
