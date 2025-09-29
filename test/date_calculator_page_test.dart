import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator_bbm/pages/date_calculator_page.dart';

void main() {
  group('DateCalculatorPage Widget Tests', () {
    testWidgets('DateCalculatorPage should render without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: DateCalculatorPage()));

      // Verify that the page renders
      expect(
        find.text('Kalkulator Tanggal'),
        findsWidgets,
      ); // Appears in AppBar and header card
      expect(find.text('Mode Perhitungan'), findsOneWidget);
      expect(find.text('Selisih antara Dua Tanggal'), findsOneWidget);
      expect(find.text('Tambah/Kurang Hari'), findsOneWidget);

      // Verify header card description is present
      expect(
        find.text(
          'Kalkulator untuk menghitung selisih tanggal, penambahan atau pengurangan hari dari tanggal tertentu.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Should switch between calculation modes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: DateCalculatorPage()));

      // Initially difference mode should be selected
      expect(find.text('Pilih Tanggal'), findsOneWidget);

      // Tap on add/subtract mode
      await tester.tap(find.text('Tambah/Kurang Hari'));
      await tester.pumpAndSettle();

      // Should now show add/subtract inputs
      expect(find.text('Tanggal dan Hari'), findsOneWidget);
      // Check for stepper buttons
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });

    testWidgets('Should show calculate button and reset in AppBar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: DateCalculatorPage()));

      expect(find.text('Hitung'), findsOneWidget);
      expect(
        find.byIcon(Icons.refresh),
        findsOneWidget,
      ); // Reset button in AppBar
    });

    testWidgets('Should show help dialog when info button is tapped', (
      WidgetTester tester,
    ) async {
      // Set larger screen size for testing
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const MaterialApp(home: DateCalculatorPage()));

      // Tap the info button
      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();

      // Should show help dialog
      expect(find.text('Bantuan'), findsOneWidget);
      expect(
        find.textContaining('Kalkulator Tanggal membantu:'),
        findsOneWidget,
      );
    });

    testWidgets(
      'Should show result popup when calculate button is tapped with valid input',
      (WidgetTester tester) async {
        // Set larger screen size for testing
        tester.view.physicalSize = const Size(1200, 1600);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(const MaterialApp(home: DateCalculatorPage()));

        // Scroll to make sure button is visible
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();

        // Tap calculate button (should show popup with default dates)
        await tester.tap(find.text('Hitung'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Should show result dialog
        expect(find.text('Hasil Perhitungan Tanggal'), findsOneWidget);
        expect(find.text('Tutup'), findsOneWidget);

        // Reset view
        addTearDown(() {
          tester.view.resetPhysicalSize();
        });
      },
    );
  });
}
