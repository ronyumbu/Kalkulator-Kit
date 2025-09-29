import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_bbm/services/date_calculation_service.dart';

void main() {
  group('DateCalculationService Tests', () {
    test('calculateDateDifference should return correct difference', () {
      final start = DateTime(2024, 5, 23);
      final end = DateTime(2024, 5, 25);

      final result = DateCalculationService.calculateDateDifference(start, end);

      expect(result, equals(2));
    });

    test(
      'calculateDateDifference should throw error when end is before start',
      () {
        final start = DateTime(2024, 5, 25);
        final end = DateTime(2024, 5, 23);

        expect(
          () => DateCalculationService.calculateDateDifference(start, end),
          throwsA(isA<DateCalculationError>()),
        );
      },
    );

    test('calculateDateDifference should return 0 for same dates', () {
      final date = DateTime(2024, 5, 23);

      final result = DateCalculationService.calculateDateDifference(date, date);

      expect(result, equals(0));
    });

    test('addSubtractDays should add days correctly', () {
      final baseDate = DateTime(2024, 5, 23);

      final result = DateCalculationService.addSubtractDays(baseDate, 2);

      expect(result, equals(DateTime(2024, 5, 25)));
    });

    test('addSubtractDays should subtract days correctly', () {
      final baseDate = DateTime(2024, 5, 25);

      final result = DateCalculationService.addSubtractDays(baseDate, -2);

      expect(result, equals(DateTime(2024, 5, 23)));
    });

    test('getIndonesianDay should return correct day names', () {
      // In Dart, Monday = 1, Tuesday = 2, ..., Sunday = 7
      final monday = DateTime(2024, 5, 20); // Known Monday (weekday = 1)
      final tuesday = DateTime(2024, 5, 21); // Known Tuesday (weekday = 2)
      final wednesday = DateTime(2024, 5, 22); // Known Wednesday (weekday = 3)
      final thursday = DateTime(2024, 5, 23); // Known Thursday (weekday = 4)
      final friday = DateTime(2024, 5, 24); // Known Friday (weekday = 5)
      final saturday = DateTime(2024, 5, 25); // Known Saturday (weekday = 6)
      final sunday = DateTime(2024, 5, 26); // Known Sunday (weekday = 7)

      expect(DateCalculationService.getIndonesianDay(monday), equals('Senin'));
      expect(
        DateCalculationService.getIndonesianDay(tuesday),
        equals('Selasa'),
      );
      expect(
        DateCalculationService.getIndonesianDay(wednesday),
        equals('Rabu'),
      );
      expect(
        DateCalculationService.getIndonesianDay(thursday),
        equals('Kamis'),
      );
      expect(DateCalculationService.getIndonesianDay(friday), equals('Jumat'));
      expect(
        DateCalculationService.getIndonesianDay(saturday),
        equals('Sabtu'),
      );
      expect(DateCalculationService.getIndonesianDay(sunday), equals('Minggu'));
    });

    test('getIndonesianMonth should return correct month names', () {
      final january = DateTime(2024, 1, 1);
      final february = DateTime(2024, 2, 1);
      final march = DateTime(2024, 3, 1);
      final april = DateTime(2024, 4, 1);
      final may = DateTime(2024, 5, 1);
      final june = DateTime(2024, 6, 1);
      final july = DateTime(2024, 7, 1);
      final august = DateTime(2024, 8, 1);
      final september = DateTime(2024, 9, 1);
      final october = DateTime(2024, 10, 1);
      final november = DateTime(2024, 11, 1);
      final december = DateTime(2024, 12, 1);

      expect(
        DateCalculationService.getIndonesianMonth(january),
        equals('Januari'),
      );
      expect(
        DateCalculationService.getIndonesianMonth(february),
        equals('Februari'),
      );
      expect(DateCalculationService.getIndonesianMonth(march), equals('Maret'));
      expect(DateCalculationService.getIndonesianMonth(april), equals('April'));
      expect(DateCalculationService.getIndonesianMonth(may), equals('Mei'));
      expect(DateCalculationService.getIndonesianMonth(june), equals('Juni'));
      expect(DateCalculationService.getIndonesianMonth(july), equals('Juli'));
      expect(
        DateCalculationService.getIndonesianMonth(august),
        equals('Agustus'),
      );
      expect(
        DateCalculationService.getIndonesianMonth(september),
        equals('September'),
      );
      expect(
        DateCalculationService.getIndonesianMonth(october),
        equals('Oktober'),
      );
      expect(
        DateCalculationService.getIndonesianMonth(november),
        equals('November'),
      );
      expect(
        DateCalculationService.getIndonesianMonth(december),
        equals('Desember'),
      );
    });

    test('formatIndonesianDate should format date correctly', () {
      final date = DateTime(2024, 5, 23);

      final result = DateCalculationService.formatIndonesianDate(date);

      expect(result, equals('23 Mei 2024'));
    });

    test(
      'formatDateDifferenceResult should format difference result correctly',
      () {
        final start = DateTime(2024, 5, 23); // Thursday
        final end = DateTime(2024, 5, 25); // Saturday

        final result = DateCalculationService.formatDateDifferenceResult(
          start,
          end,
          2,
        );

        expect(
          result,
          equals('MULTIPLE_DAYS|2|23 Mei 2024|Kamis|25 Mei 2024|Sabtu'),
        );
      },
    );

    test('formatDateDifferenceResult should handle same date correctly', () {
      final date = DateTime(2024, 5, 23); // Thursday

      final result = DateCalculationService.formatDateDifferenceResult(
        date,
        date,
        0,
      );

      expect(
        result,
        equals('SAME_DAY|0|23 Mei 2024|Kamis|23 Mei 2024|Kamis'),
      );
    });

    test('formatDateDifferenceResult should handle single day correctly', () {
      final start = DateTime(2024, 5, 23); // Thursday
      final end = DateTime(2024, 5, 24); // Friday

      final result = DateCalculationService.formatDateDifferenceResult(
        start,
        end,
        1,
      );

      expect(
        result,
        equals('SINGLE_DAY|1|23 Mei 2024|Kamis|24 Mei 2024|Jumat'),
      );
    });

    test('formatAddSubtractResult should format addition result correctly', () {
      final originalDate = DateTime(2024, 5, 23); // Thursday
      final resultDate = DateTime(2024, 5, 25); // Saturday

      final result = DateCalculationService.formatAddSubtractResult(
        originalDate,
        2,
        resultDate,
      );

      expect(result, equals('ADD_MULTIPLE|2|23 Mei 2024|Kamis|25 Mei 2024|Sabtu'));
    });

    test(
      'formatAddSubtractResult should format subtraction result correctly',
      () {
        final originalDate = DateTime(2024, 5, 25); // Saturday
        final resultDate = DateTime(2024, 5, 23); // Thursday

        final result = DateCalculationService.formatAddSubtractResult(
          originalDate,
          -2,
          resultDate,
        );

        expect(
          result,
          equals('SUBTRACT_MULTIPLE|2|25 Mei 2024|Sabtu|23 Mei 2024|Kamis'),
        );
      },
    );

    test('formatAddSubtractResult should handle zero days correctly', () {
      final date = DateTime(2024, 5, 23); // Thursday

      final result = DateCalculationService.formatAddSubtractResult(
        date,
        0,
        date,
      );

      expect(result, equals('SAME_DATE|0|23 Mei 2024|Kamis|23 Mei 2024|Kamis'));
    });

    test('formatAddSubtractResult should handle single day addition correctly', () {
      final originalDate = DateTime(2024, 9, 29); // Sunday (like in the image)
      final resultDate = DateTime(2024, 9, 30); // Monday

      final result = DateCalculationService.formatAddSubtractResult(
        originalDate,
        1,
        resultDate,
      );

      expect(result, equals('ADD_SINGLE|1|29 September 2024|Minggu|30 September 2024|Senin'));
    });

    test('formatAddSubtractResult should handle single day subtraction correctly', () {
      final originalDate = DateTime(2024, 9, 30); // Monday
      final resultDate = DateTime(2024, 9, 29); // Sunday

      final result = DateCalculationService.formatAddSubtractResult(
        originalDate,
        -1,
        resultDate,
      );

      expect(result, equals('SUBTRACT_SINGLE|1|30 September 2024|Senin|29 September 2024|Minggu'));
    });

    test('isValidDateRange should validate date ranges correctly', () {
      final validDate = DateTime(2024, 5, 23);
      final tooEarlyDate = DateTime(1800, 1, 1);
      final tooLateDate = DateTime(2200, 1, 1);

      expect(DateCalculationService.isValidDateRange(validDate), isTrue);
      expect(DateCalculationService.isValidDateRange(tooEarlyDate), isFalse);
      expect(DateCalculationService.isValidDateRange(tooLateDate), isFalse);
    });

    test('getFullDayInfo should return complete day information', () {
      final date = DateTime(2024, 5, 23); // Thursday

      final result = DateCalculationService.getFullDayInfo(date);

      expect(result, equals('Kamis, 23 Mei 2024'));
    });
  });
}
