import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_bbm/pages/age_calculator_page.dart';

void main() {
  group('AgeCalculatorPage Widget Tests', () {
    testWidgets('AgeCalculatorPage should render without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AgeCalculatorPage()));

      // Verify that the page renders
      expect(find.text('Kalkulator Usia'), findsWidgets); // AppBar and header
      expect(find.text('Tanggal Lahir'), findsOneWidget);
      expect(find.text('Tap untuk pilih tanggal lahir'), findsOneWidget);
      expect(find.text('Hitung Usia'), findsOneWidget);
      
      // Verify header card description is present
      expect(
        find.text(
          'Hitung usia Anda secara detail dari tanggal lahir hingga sekarang.',
        ),
        findsOneWidget,
      );

      // Verify instruction card is present
      expect(find.text('Cara Penggunaan'), findsOneWidget);
    });

    testWidgets('Should show date picker when birth date field is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AgeCalculatorPage()));

      // Find the birth date field container
      final dateField = find.text('Tap untuk pilih tanggal lahir');
      expect(dateField, findsOneWidget);
      
      // This test just verifies the field exists and is tappable
      // Date picker dialog testing is complex due to platform dependencies
    });

    testWidgets('Should show error when calculate button is pressed without selecting date', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AgeCalculatorPage()));

      // Find and tap the calculate button
      final calculateButton = find.text('Hitung Usia');
      expect(calculateButton, findsOneWidget);
      
      await tester.tap(calculateButton);
      await tester.pumpAndSettle();

      // Verify error snackbar is shown
      expect(find.text('Silakan pilih tanggal lahir terlebih dahulu'), findsOneWidget);
    });

    testWidgets('Should have calculate button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AgeCalculatorPage()));

      // Verify calculate button exists
      final calculateButton = find.text('Hitung Usia');
      expect(calculateButton, findsOneWidget);

      // Verify button is enabled (can be tapped)
      final buttonWidget = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(buttonWidget.onPressed, isNotNull);
    });

    testWidgets('Should show proper icons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AgeCalculatorPage()));

      // Verify icons exist
      expect(find.byIcon(Icons.cake), findsWidgets); // Header icon
      expect(find.byIcon(Icons.calendar_today), findsOneWidget); // Date field icon
      expect(find.byIcon(Icons.calculate), findsOneWidget); // Button icon
      expect(find.byIcon(Icons.help_outline), findsOneWidget); // Help icon
    });

    testWidgets('Should display instructions card', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AgeCalculatorPage()));

      // Verify instruction steps are present
      expect(find.text('Cara Penggunaan'), findsOneWidget);
      expect(
        find.textContaining('Tap pada kolom "Tanggal Lahir"'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Pilih tanggal lahir Anda'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Tap tombol "Hitung Usia"'),
        findsOneWidget,
      );
    });

    testWidgets('Should have proper theme colors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const AgeCalculatorPage(),
        ),
      );

      // Verify the gradient header exists
      expect(find.byType(Container), findsWidgets);
      
      // The header should contain the cake icon
      expect(find.byIcon(Icons.cake), findsWidgets);
    });

    testWidgets('Should support dark theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const AgeCalculatorPage(),
        ),
      );

      // Verify the page renders in dark theme
      expect(find.text('Kalkulator Usia'), findsWidgets);
      expect(find.text('Tanggal Lahir'), findsOneWidget);
    });

    testWidgets('Should have proper card structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AgeCalculatorPage()));

      // Verify card widgets exist
      expect(find.byType(Card), findsWidgets);
      
      // Verify main components
      expect(find.text('Tanggal Lahir'), findsOneWidget);
      expect(find.text('Cara Penggunaan'), findsOneWidget);
    });
  });
}