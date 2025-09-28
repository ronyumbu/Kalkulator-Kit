import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_bbm/services/time_calculation_service.dart';

void main() {
  group('TimeCalculationService', () {
    test('parse and format roundtrip', () {
      final secs = TimeCalculationService.parseToSeconds('02:03');
      expect(secs, 7380); // 2*3600 + 3*60 = 7380
      final back = TimeCalculationService.formatSeconds(secs);
      expect(back, '02:03');
    });

    test('addition time + time', () {
      final res = TimeCalculationService.evaluate('02:30 + 01:45');
      expect(res, '04:15');
    });

    test('subtraction time - time', () {
      final res = TimeCalculationService.evaluate('05:00 - 01:30');
      expect(res, '03:30');
    });

    test('multiplication time * number', () {
      final res = TimeCalculationService.evaluate('01:15 * 3');
      expect(res, '03:45');
    });

    test('division time / number', () {
      final res = TimeCalculationService.evaluate('04:00 / 2');
      expect(res, '02:00');
    });
  });
}
