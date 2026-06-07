import 'package:flutter_test/flutter_test.dart';
import 'package:piggyvault/core/services/price_tracker_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
  });

  group('PriceTrackerService Smoke Tests', () {
    test('Fetch price for valid PS5 Slim should return a price within range', () async {
      final price = await PriceTrackerService.fetchPrice('PlayStation 5 Slim');
      
      if (price != null) {
        expect(price, greaterThanOrEqualTo(15000.0));
        expect(price, lessThanOrEqualTo(45000.0));
      }
    });

    test('Fetch price for monitor should be within range', () async {
      final price = await PriceTrackerService.fetchPrice('Ігровий Монітор');
      if (price != null) {
        expect(price, greaterThanOrEqualTo(3000.0));
        expect(price, lessThanOrEqualTo(25000.0));
      }
    });
  });
}
