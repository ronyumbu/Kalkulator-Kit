import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_bbm/services/time_calculation_service.dart';

void main() {
  group('TimeCalculationService', () {
    test('parse and format roundtrip', () {
      final secs = TimeCalculationService.parseToSeconds('02:03:04');
      expect(secs, 7384);
      final back = TimeCalculationService.formatSeconds(secs);
      expect(back, '02:03:04');
    });

    test('addition time + time', () {
      final res = TimeCalculationService.evaluate('02:30:00 + 01:45:30');
      expect(res, '04:15:30');
    });

    test('subtraction time - time', () {
      final res = TimeCalculationService.evaluate('05:00:00 - 01:30:00');
      expect(res, '03:30:00');
    });

    test('multiplication time * number', () {
      final res = TimeCalculationService.evaluate('01:15:00 * 3');
      expect(res, '03:45:00');
    });

    test('division time / number', () {
      final res = TimeCalculationService.evaluate('04:00:00 / 2');
      expect(res, '02:00:00');
    });
  });
}
