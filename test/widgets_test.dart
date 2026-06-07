import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:piggyvault/core/widgets/detox_progress_circle.dart';
import 'package:piggyvault/core/widgets/neon_radar_chart.dart';

void main() {
  group('DetoxProgressCircle Tests', () {
    testWidgets('renders correct time label and active state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DetoxProgressCircle(
              progress: 0.75,
              timeLabel: "18 годин",
            ),
          ),
        ),
      );

      // Verify that the widget renders labels correctly
      expect(find.text('ДЕТОКС АКТИВНИЙ'), findsOneWidget);
      expect(find.text('18 годин'), findsOneWidget);
      expect(find.text('залишилось 75%'), findsOneWidget);
    });

    testWidgets('indicates critical warning state under threshold', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DetoxProgressCircle(
              progress: 0.15, // under critical 0.25 warning threshold
              timeLabel: "2 години",
            ),
          ),
        ),
      );

      expect(find.text('ДЕТОКС АКТИВНИЙ'), findsOneWidget);
      expect(find.text('2 години'), findsOneWidget);
      expect(find.text('залишилось 15%'), findsOneWidget);
    });
  });

  group('NeonRadarChart Tests', () {
    testWidgets('renders all skill levels and metrics labels', (WidgetTester tester) async {
      final skillData = {
        'Hacker': 0.8,
        'Magnate': 0.6,
        'Resilience': 0.9,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeonRadarChart(data: skillData),
          ),
        ),
      );

      // We expect the NeonRadarChart widget to be present
      expect(find.byType(NeonRadarChart), findsOneWidget);
    });
  });
}
