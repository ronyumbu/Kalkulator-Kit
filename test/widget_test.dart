// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_bbm/main.dart';
import 'package:kalkulator_bbm/services/calculation_service.dart';
import 'package:kalkulator_bbm/utils/currency_formatter.dart';

void main() {
  group('Fuel Calculator Tests', () {
    testWidgets('App loads correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that our main elements are present
  expect(find.text('Kalkulator BBM'), findsWidgets);
      expect(find.text('Hitung'), findsOneWidget);
      expect(find.text('Input Data Perjalanan'), findsOneWidget);
    });

    group('CalculationService Tests', () {
      test('calculateFuelCost works correctly', () {
        // Test: 100km distance, 10km/L efficiency, Rp15000/L price
        // Expected: (100/10) * 15000 = 150000
        final result = CalculationService.calculateFuelCost(100, 10, 15000);
        expect(result, equals(150000.0));
      });

      test('calculateTotalCost works correctly', () {
        final result = CalculationService.calculateTotalCost(
          150000,
          50000,
          20000,
        );
        expect(result, equals(220000.0));
      });

      test('calculateCostPerKm works correctly', () {
        final result = CalculationService.calculateCostPerKm(220000, 100);
        expect(result, equals(2200.0));
      });

      test('validateInputs catches empty fields', () {
        final errors = CalculationService.validateInputs(
          distance: '',
          efficiency: '10',
          price: '15000',
          tollCost: '',
          parkingCost: '',
        );
        expect(errors['distance'], isNotNull);
      });

      test('validateInputs catches invalid numbers', () {
        final errors = CalculationService.validateInputs(
          distance: '100',
          efficiency: '0', // Invalid: should be > 0
          price: '15000',
          tollCost: '',
          parkingCost: '',
        );
        expect(errors['efficiency'], isNotNull);
      });
    });

    group('CurrencyFormatter Tests', () {
      test('formatCurrency works correctly', () {
        final result = CurrencyFormatter.formatCurrency(150000.50);
        expect(result, contains('Rp'));
        expect(result, contains('150'));
      });

      test('formatCurrencyNoDecimal works correctly', () {
        final result = CurrencyFormatter.formatCurrencyNoDecimal(150000.50);
        expect(result, contains('Rp'));
        expect(result, contains('150'));
      });
    });
  });
}
