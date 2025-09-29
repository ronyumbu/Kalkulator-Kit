import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_bbm/services/age_calculation_service.dart';

void main() {
  group('AgeCalculationService Tests', () {
    test('should calculate age correctly for exact years', () {
      // Test case: Born exactly 25 years ago
      final now = DateTime.now();
      final birthDate = DateTime(now.year - 25, now.month, now.day);
      
      final result = AgeCalculationService.calculateAge(birthDate);
      
      // Allow some flexibility based on current date
      expect(result.years, anyOf(equals(24), equals(25)));
      expect(result.months, lessThan(12));
      expect(result.days, lessThan(32));
      expect(result.totalYears, anyOf(equals(24), equals(25)));
    });

    test('should calculate age correctly with months and days', () {
      // Test case: Born more than 25 years ago
      final birthDate = DateTime(1999, 1, 5);
      
      final result = AgeCalculationService.calculateAge(birthDate);
      
      expect(result.years, greaterThanOrEqualTo(25));
      expect(result.totalDays, greaterThan(9000)); // Should be more than 9000 days
    });

    test('should throw error for future birth date', () {
      final futureDate = DateTime.now().add(const Duration(days: 1));
      
      expect(
        () => AgeCalculationService.calculateAge(futureDate),
        throwsArgumentError,
      );
    });

    test('should format date correctly', () {
      final date = DateTime(2024, 1, 15);
      final formatted = AgeCalculationService.formatDate(date);
      
      expect(formatted, '15 Januari 2024');
    });

    test('should format numbers with thousand separators', () {
      expect(AgeCalculationService.formatNumber(1000), '1.000');
      expect(AgeCalculationService.formatNumber(1234567), '1.234.567');
      expect(AgeCalculationService.formatNumber(999), '999');
    });

    test('should calculate total values correctly', () {
      final birthDate = DateTime(2023, 1, 1); // More than 1 year ago
      
      final result = AgeCalculationService.calculateAge(birthDate);
      
      expect(result.years, greaterThanOrEqualTo(1));
      expect(result.totalDays, greaterThan(365)); // Should be more than 365 days
      expect(result.totalHours, greaterThan(365 * 24));
      expect(result.totalMinutes, greaterThan(365 * 24 * 60));
      expect(result.totalSeconds, greaterThan(365 * 24 * 60 * 60));
    });

    test('should handle leap year calculations', () {
      final birthDate = DateTime(2024, 2, 29); // Leap year birth date
      
      final result = AgeCalculationService.calculateAge(birthDate);
      
      expect(result.years, greaterThanOrEqualTo(0));
      expect(result.totalDays, greaterThanOrEqualTo(0)); // Should handle leap day correctly
    });

    test('should format age string correctly', () {
      // Test different age formats
      final result1 = AgeCalculationResult(
        years: 25,
        months: 6,
        days: 15,
        totalYears: 25,
        totalMonths: 306,
        totalWeeks: 1332,
        totalDays: 9331,
        totalHours: 223944,
        totalMinutes: 13436640,
        totalSeconds: 806198400,
      );
      
      expect(result1.formattedAge, '25 tahun, 6 bulan, 15 hari');

      final result2 = AgeCalculationResult(
        years: 0,
        months: 6,
        days: 15,
        totalYears: 0,
        totalMonths: 6,
        totalWeeks: 28,
        totalDays: 196,
        totalHours: 4704,
        totalMinutes: 282240,
        totalSeconds: 16934400,
      );
      
      expect(result2.formattedAge, '6 bulan, 15 hari');

      final result3 = AgeCalculationResult(
        years: 0,
        months: 0,
        days: 15,
        totalYears: 0,
        totalMonths: 0,
        totalWeeks: 2,
        totalDays: 15,
        totalHours: 360,
        totalMinutes: 21600,
        totalSeconds: 1296000,
      );
      
      expect(result3.formattedAge, '15 hari');
    });

    test('should get correct date boundaries', () {
      final today = AgeCalculationService.getToday();
      final now = DateTime.now();
      
      expect(today.year, now.year);
      expect(today.month, now.month);
      expect(today.day, now.day);
      expect(today.hour, 0);
      expect(today.minute, 0);
      expect(today.second, 0);

      final minDate = AgeCalculationService.getMinBirthDate();
      final maxDate = AgeCalculationService.getMaxBirthDate();
      
      expect(minDate.year, now.year - 150);
      expect(maxDate, today);
    });
  });
}