import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_bbm/services/time_calculation_service.dart';

void main() {
  group('Time Calculator Dual Result Tests', () {
    test('Normal time addition under 24 hours', () {
      final result = TimeCalculationService.evaluate('10:30 + 02:15');
      expect(result, '12:45');
    });

    test('Time addition exceeding 24 hours shows dual result', () {
      final result = TimeCalculationService.evaluate('23:50 + 02:00');
      expect(result, '25:50 (01:50)');
    });

    test('Time addition exceeding 24 hours by a lot', () {
      final result = TimeCalculationService.evaluate('12:00 + 36:30');
      expect(result, '48:30 (00:30)');
    });

    test('Time multiplication exceeding 24 hours', () {
      final result = TimeCalculationService.evaluate('08:00 * 4');
      expect(result, '32:00 (08:00)');
    });

    test('Time subtraction under 24 hours', () {
      final result = TimeCalculationService.evaluate('15:30 - 02:15');
      expect(result, '13:15');
    });

    test('formatSecondsWithDayWrap method directly', () {
      // Test the new method directly
      final result1 = TimeCalculationService.formatSecondsWithDayWrap(45000); // 12:30
      expect(result1, '12:30');
      
      final result2 = TimeCalculationService.formatSecondsWithDayWrap(93000); // 25:50
      expect(result2, '25:50 (01:50)');
    });
  });
}