import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../data/database.dart';
import '../providers/price_hunter_provider.dart';
import 'price_pulse_screen.dart';

class PricePulseCard extends ConsumerWidget {
  final Goal goal;

  const PricePulseCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<PriceHistoryEntry?>(
      // Use the database provider to fetch the latest entry
      future: ref.read(databaseProvider).getLatestPriceEntry(goal.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingCard();
        }

        final entry = snapshot.data;
        if (entry == null || DateTime.now().difference(entry.cachedAt).inDays > 7) {
          return _EmptyStateCard(goal: goal);
        }

        return _DataCard(goal: goal, entry: entry);
      },
    );
  }
}

class _DataCard extends ConsumerWidget {
  final Goal goal;
  final PriceHistoryEntry entry;

  const _DataCard({required this.goal, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine color based on target price or previous price.
    // For simplicity in the card, if current price < target price, it's green.
    final current = entry.priceKopecks / 100;
    final target = (goal.targetPrice ?? goal.currentPrice ?? entry.priceKopecks) / 100;
    
    final diff = current - target;
    final isDiscount = diff < 0;
    final isExpensive = diff > 0;
    
    final color = isDiscount
        ? const Color(0xFF00FF9D) // Neon green
        : isExpensive
            ? const Color(0xFFFF3B30) // Neon red
            : Colors.grey;

    final hoursOld = DateTime.now().difference(entry.cachedAt).inHours;
    final isStale = hoursOld > 6;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PricePulseScreen(goal: goal),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Market Pulse',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              if (isStale)
                const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16)
            ],
          ),
          const SizedBox(height: 8),
          Text(
            goal.productUrl ?? goal.name, // Using productUrl as query/name for now
            style: const TextStyle(color: Colors.white, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${current.toStringAsFixed(0)} грн',
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              if (diff != 0)
                Text(
                  '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(0)} грн ${diff > 0 ? '↑' : '↓'}',
                  style: TextStyle(color: color, fontSize: 14),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Джерело: ${entry.source}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                isStale 
                  ? 'Оновлено: ${entry.cachedAt.hour.toString().padLeft(2, '0')}:${entry.cachedAt.minute.toString().padLeft(2, '0')}'
                  : 'Live data',
                style: TextStyle(color: isStale ? Colors.orange : Colors.grey, fontSize: 12),
              ),
            ],
          )
        ],
      ),
    ),
    );
  }
}

class _EmptyStateCard extends ConsumerWidget {
  final Goal goal;

  const _EmptyStateCard({required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PricePulseScreen(goal: goal),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.show_chart, color: Colors.grey, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Немає даних про ціну', style: TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                Text('Почніть відстежувати ціну для ${goal.name}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(priceHunterProvider.notifier).updatePrice(goal.id, forceManual: true);
            },
            child: const Text('Відстежити', style: TextStyle(color: Colors.cyanAccent)),
          )
        ],
      ),
    ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
    );
  }
}
