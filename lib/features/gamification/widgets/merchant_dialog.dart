import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/merchant_provider.dart';

class MerchantDialog extends ConsumerWidget {
  const MerchantDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(merchantProvider);

    if (!state.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) {
           Navigator.of(context).pop();
        }
      });
      return const SizedBox.shrink();
    }

    final hours = state.timeRemaining.inHours.toString().padLeft(2, '0');
    final mins = (state.timeRemaining.inMinutes % 60).toString().padLeft(2, '0');
    final secs = (state.timeRemaining.inSeconds % 60).toString().padLeft(2, '0');
    final timeStr = '$hours:$mins:$secs';
    
    final targetStr = (state.targetAmount / 100).toStringAsFixed(0);
    final rewardStr = state.reward == 'x2_xp' ? 'Подвійний Досвід (x2 XP)' : 'Унікальний Лутбокс';

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.purpleAccent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.radar, color: Colors.purpleAccent, size: 48),
            const SizedBox(height: 16),
            const Text(
              'SIGNAL DETECTED',
              style: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Маю для тебе рідкісний код. Відклади цільову суму, поки сигнал не зникне, і я надам тобі бонус.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ціль:', style: TextStyle(color: Colors.white54)),
                  Text('$targetStr ₴', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Винагорода:', style: TextStyle(color: Colors.white54)),
                  Text(rewardStr, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              timeStr,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                fontFamily: 'Courier',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent.withValues(alpha: 0.2),
                foregroundColor: Colors.purpleAccent,
                side: const BorderSide(color: Colors.purpleAccent),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('ПРИЙНЯТИ (ЗАКРИТИ)'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.read(merchantProvider.notifier).dismissContract();
                Navigator.of(context).pop();
              },
              child: const Text('Відхилити сигнал', style: TextStyle(color: Colors.white38)),
            ),
          ],
        ),
      ),
    );
  }
}
