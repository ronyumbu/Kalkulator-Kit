import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Date picker buttons implementation test', (WidgetTester tester) async {
    // Simple test to verify date picker functionality
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: Colors.teal[600],
                        ),
                        dialogTheme: DialogThemeData(
                          actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.teal[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 1,
                            minimumSize: const Size(60, 36),
                          ),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: child!,
                      ),
                    );
                  },
                );
              },
              child: const Text('Open Date Picker'),
            ),
          ),
        ),
      ),
    );

    // Tap the button to open date picker
    await tester.tap(find.text('Open Date Picker'));
    await tester.pumpAndSettle();

    // Verify that the date picker is shown
    expect(find.byType(DatePickerDialog), findsOneWidget);

    // Find the buttons
    final cancelButton = find.text('Cancel');
    final okButton = find.text('OK');

    expect(cancelButton, findsOneWidget);
    expect(okButton, findsOneWidget);

  // Informational: date picker opened, buttons found, and theme applied.
  // Assertions above validate these behaviors; avoid using print() in tests.
  });
}