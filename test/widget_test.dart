import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piggyvault/core/providers/providers.dart';

void main() {
  test('App Provider Scope compilation verification', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Verify default state values in providers without crash
    expect(container.read(onboardingGoalATitleProvider), 'PlayStation 5');
    expect(container.read(onboardingGoalATargetProvider), 25000.0);
    expect(container.read(onboardingGoalBTitleProvider), 'Ігровий Монітор');
    expect(container.read(onboardingGoalBTargetProvider), 15000.0);
  });
}
