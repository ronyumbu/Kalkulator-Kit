import 'package:flutter_test/flutter_test.dart';

// Simulasi class untuk testing logic calculator
class BasicCalculatorLogic {
  String _display = '0';
  String _previousValue = '0';
  String _operation = '';
  bool _shouldResetDisplay = false;
  bool _hasDecimal = false;

  String get display => _display;
  String get previousValue => _previousValue;
  String get operation => _operation;
  bool get shouldResetDisplay => _shouldResetDisplay;

  void onNumberPressed(String number) {
    if (_shouldResetDisplay || _display.isEmpty) {
      _display = number;
      _shouldResetDisplay = false;
      _hasDecimal = false;
    } else {
      if (_display == '0' && number != '0') {
        _display = number;
      } else if (_display != '0') {
        _display += number;
      }
    }
  }

  void onDecimalPressed() {
    if (_shouldResetDisplay || _display.isEmpty) {
      _display = '0.';
      _shouldResetDisplay = false;
      _hasDecimal = true;
    } else if (!_hasDecimal) {
      _display += '.';
      _hasDecimal = true;
    }
  }

  void onOperationPressed(String op) {
    if (_operation.isNotEmpty && !_shouldResetDisplay) {
      calculateResult();
      _previousValue = _display; // Update previous value after calculation
    } else {
      _previousValue = _display;
    }
    _operation = op;
    _shouldResetDisplay = true;
    // Clear display immediately after operation is pressed
    _display = '';
    _hasDecimal = false;
  }

  void calculateResult() {
    if (_operation.isEmpty) return;

    double prev = double.tryParse(_previousValue) ?? 0;
    double current = double.tryParse(_display) ?? 0;
    double result = 0;

    switch (_operation) {
      case '+':
        result = prev + current;
        break;
      case '-':
        result = prev - current;
        break;
      case '×':
        result = prev * current;
        break;
      case '÷':
        if (current == 0) {
          throw Exception('Tidak dapat membagi dengan nol');
        }
        result = prev / current;
        break;
    }

    // Format result to remove unnecessary decimals
    if (result == result.toInt()) {
      _display = result.toInt().toString();
    } else {
      _display = result.toString();
    }
    _operation = '';
    _previousValue = '0';
    _shouldResetDisplay = true;
    _hasDecimal = _display.contains('.');
  }

  void onEqualsPressed() {
    calculateResult();
  }

  void reset() {
    _display = '0';
    _previousValue = '0';
    _operation = '';
    _shouldResetDisplay = false;
    _hasDecimal = false;
  }

  String formatDisplay(String value) {
    // Return '0' if value is empty
    if (value.isEmpty) {
      return '0';
    }
    return value;
  }
}

void main() {
  group('Basic Calculator Logic Tests', () {
    late BasicCalculatorLogic calculator;

    setUp(() {
      calculator = BasicCalculatorLogic();
    });

    test('Display should be empty after operation is pressed', () {
      // Input number 5
      calculator.onNumberPressed('5');
      expect(calculator.display, '5');

      // Press plus operation
      calculator.onOperationPressed('+');
      
      // After operation, display should be empty (will show 0 when formatted)
      expect(calculator.display, '');
      expect(calculator.formatDisplay(calculator.display), '0');
      expect(calculator.previousValue, '5');
      expect(calculator.operation, '+');
      expect(calculator.shouldResetDisplay, true);
    });

    test('Should handle number input after operation correctly', () {
      // Input number 3
      calculator.onNumberPressed('3');
      expect(calculator.display, '3');

      // Press minus operation
      calculator.onOperationPressed('-');
      expect(calculator.display, '');
      expect(calculator.previousValue, '3');
      expect(calculator.operation, '-');

      // Input number 2
      calculator.onNumberPressed('2');
      
      // Display should show only 2, not 32
      expect(calculator.display, '2');
    });

    test('Should calculate result correctly when equals is pressed', () {
      // Input 8
      calculator.onNumberPressed('8');
      
      // Press divide
      calculator.onOperationPressed('÷');
      
      // Input 2
      calculator.onNumberPressed('2');
      
      // Press equals
      calculator.onEqualsPressed();
      
      // Should show result 4
      expect(calculator.display, '4');
    });

    test('Should handle decimal input after operation', () {
      // Input 7
      calculator.onNumberPressed('7');
      
      // Press multiply
      calculator.onOperationPressed('×');
      
      // Press decimal point
      calculator.onDecimalPressed();
      
      // Should show 0. in display
      expect(calculator.display, '0.');
      expect(calculator.previousValue, '7');
      expect(calculator.operation, '×');
    });

    test('Should handle continuous operations correctly', () {
      // 5 + 3 - 2 = 6
      calculator.onNumberPressed('5');
      calculator.onOperationPressed('+');
      calculator.onNumberPressed('3');
      calculator.onOperationPressed('-'); // This should calculate 5+3=8 first
      expect(calculator.display, ''); // Display should be empty after operation
      expect(calculator.previousValue, '8'); // Previous value should be result of 5+3
      
      calculator.onNumberPressed('2');
      calculator.onEqualsPressed();
      expect(calculator.display, '6'); // 8 - 2 = 6
    });

    test('Should reset display correctly for multiple number inputs', () {
      calculator.onNumberPressed('1');
      calculator.onNumberPressed('2');
      calculator.onNumberPressed('3');
      expect(calculator.display, '123');
      
      calculator.onOperationPressed('+');
      expect(calculator.display, '');
      
      calculator.onNumberPressed('4');
      calculator.onNumberPressed('5');
      expect(calculator.display, '45');
    });
  });
}