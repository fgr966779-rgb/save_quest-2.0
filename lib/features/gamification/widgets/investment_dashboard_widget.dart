import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';

class InvestmentDashboardWidget extends ConsumerWidget {
  const InvestmentDashboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Simplified mock data for the widget
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/investment-market'),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Виртуальный Портфель', style: AppTypography.overline(context)),
                const Icon(Icons.show_chart_rounded, color: Colors.cyanAccent, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text('124 500.00 ₴', style: AppTypography.h2(context).copyWith(fontFamily: 'monospace')),
            Row(
              children: [
                Text('+2.45%', style: AppTypography.caption(context, color: Colors.greenAccent)),
                const SizedBox(width: 8),
                Text('Обновлено: 14:00', style: AppTypography.overline(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
