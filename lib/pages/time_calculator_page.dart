import 'package:flutter/material.dart';
import '../services/time_calculation_service.dart';
import '../widgets/main_drawer.dart';
import '../widgets/time_keypad.dart';

class TimeCalculatorPage extends StatefulWidget {
  const TimeCalculatorPage({super.key});

  @override
  State<TimeCalculatorPage> createState() => _TimeCalculatorPageState();
}

class _TimeCalculatorPageState extends State<TimeCalculatorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Rolling input state
  final List<String> _leftDigits = [];
  final List<String> _rightDigits = [];
  String? _op; // '+', '-', '*', '/'
  String _result = '00:00:00';
  String? _error;

  void _onKey(String key) {
    setState(() {
      _error = null;
      switch (key) {
        case 'AC':
          _clearAll();
          return;
        case 'C':
          _backspace();
          _updatePreview();
          return;
        case '+':
        case '-':
        case '*':
        case '/':
          _selectOperator(key);
          _updatePreview();
          return;
      }

      // Accept digits (single) or '00' for quick double zero
      if (RegExp(r'^\d$').hasMatch(key) || key == '00') {
        if (_op == null) {
          if (key == '00') {
            _leftDigits.addAll(['0','0']);
          } else {
            _leftDigits.add(key);
          }
        } else {
          if (key == '00') {
            _rightDigits.addAll(['0','0']);
          } else {
            _rightDigits.add(key);
          }
        }
        _updatePreview();
      }
      // Ignore other keys like ':' in rolling mode
    });
  }

  void _clearAll() {
    _leftDigits.clear();
    _rightDigits.clear();
    _op = null;
    _result = '00:00:00';
    _error = null;
  }

  void _backspace() {
    if (_op != null && _rightDigits.isNotEmpty) {
      _rightDigits.removeLast();
      return;
    }
    if (_op != null && _rightDigits.isEmpty) {
      _op = null;
      return;
    }
    if (_op == null && _leftDigits.isNotEmpty) {
      _leftDigits.removeLast();
    }
  }

  void _selectOperator(String op) {
    // If we already have an operator and right operand, perform chaining
    if (_op != null && _rightDigits.isNotEmpty) {
      if (_tryEvaluate()) {
        // Move result to left and continue with new operator
        _leftDigits
          ..clear()
          ..addAll(_secondsToDigits(_parseDigitsToSeconds(_cachedResultDigits)));
        _rightDigits.clear();
        _result = _formatSecondsForDisplay(_parseDigitsToSeconds(_leftDigits));
      }
    }
    _op = op;
  }

  // Convert digit buffer to total seconds (normalize beyond 59 as needed)
  int _parseDigitsToSeconds(List<String> digits) {
    if (digits.isEmpty) return 0;
    final s = digits.join();
    final len = s.length;
    int sec = 0, min = 0, hour = 0;
    if (len <= 2) {
      sec = int.parse(s);
    } else if (len <= 4) {
      sec = int.parse(s.substring(len - 2));
      min = int.parse(s.substring(0, len - 2));
    } else {
      sec = int.parse(s.substring(len - 2));
      min = int.parse(s.substring(len - 4, len - 2));
      hour = int.parse(s.substring(0, len - 4));
    }
    return hour * 3600 + min * 60 + sec;
  }

  // Untuk tampilan input: tampilkan mm:ss jika jam == 0, jika ada jam tampilkan HH:MM:SS
  String _formatSecondsForDisplay(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final rem = totalSeconds % 3600;
    final m = rem ~/ 60;
    final s = rem % 60;
    String two(int v) => v.toString().padLeft(2, '0');
    if (h == 0) {
      // Show m:ss (no leading zero for minutes) when hour == 0
      final mText = m.toString();
      return '$mText:${two(s)}';
    }
    return '${h.toString().padLeft(2, '0')}:${two(m)}:${two(s)}';
  }

  // Catatan: Service evaluate mengembalikan HH:MM:SS (internal),
  // namun UI menampilkan mm:ss ketika jam == 0.
  String _formatDigitsFull(List<String> digits) {
    final secs = _parseDigitsToSeconds(digits);
    return TimeCalculationService.formatSeconds(secs);
  }

  // Untuk tampilan hasil: tampilkan mm:ss ketika jam == 0, jika ada jam tampilkan HH:MM:SS
  String _formatSecondsForResult(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final rem = totalSeconds % 3600;
    final m = rem ~/ 60;
    final s = rem % 60;
    String two(int v) => v.toString().padLeft(2, '0');
    if (h == 0) {
      return '${two(m)}:${two(s)}';
    }
    return '${h.toString().padLeft(2, '0')}:${two(m)}:${two(s)}';
  }

  // Helper to attempt evaluation for chaining
  bool _tryEvaluate() {
    try {
      final expr = _buildExpression(forEvaluate: true);
      if (expr == null) return false;
      final res = TimeCalculationService.evaluate(expr);
      _result = res;
      _error = null;
      // Cache result into left as digits for chaining
      _cachedResultDigits
        ..clear()
        ..addAll(_resultToDigits(res));
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Keep a cache for chaining result digits
  final List<String> _cachedResultDigits = [];

  List<String> _secondsToDigits(int totalSeconds) {
    // Konversi ke HH:MM:SS (internal), lalu ke digit rolling (H... + MM + SS)
    final formatted = TimeCalculationService.formatSeconds(totalSeconds);
    final parts = formatted.split(':');
    final h = parts[0];
    final m = parts[1];
    final s = parts[2];
    final digits = <String>[];
    if (h != '00') {
      digits.addAll(h.replaceFirst(RegExp(r'^0'), '').split(''));
    }
    digits.addAll(m.split(''));
    digits.addAll(s.split(''));
    return digits;
  }

  List<String> _resultToDigits(String hhmmss) {
    final parts = hhmmss.split(':');
    final h = parts[0];
    final m = parts[1];
    final s = parts[2];
    final digits = <String>[];
    if (h != '00') {
      digits.addAll(h.replaceFirst(RegExp(r'^0'), '').split(''));
    }
    digits.addAll(m.split(''));
    digits.addAll(s.split(''));
    return digits;
  }

  void _updatePreview() {
    // Live preview if we have enough info
    final expr = _buildExpression(forEvaluate: true);
    if (expr == null) {
      // No operator: just show left formatted
      final leftSecs = _parseDigitsToSeconds(_leftDigits);
      _result = TimeCalculationService.formatSeconds(leftSecs);
      return;
    }
    try {
      _result = TimeCalculationService.evaluate(expr);
      _error = null;
    } catch (e) {
      // keep last valid result but show error
      _error = e.toString();
    }
  }

  String? _buildExpression({required bool forEvaluate}) {
    if (_op == null) return null;
    if (_leftDigits.isEmpty) return null;
    final left = _formatDigitsFull(_leftDigits);
    switch (_op) {
      case '+':
      case '-':
        final right = _rightDigits.isEmpty
            ? '00:00:00'
            : _formatDigitsFull(_rightDigits);
        return '$left $_op $right';
      case '*':
      case '/':
        if (_rightDigits.isEmpty) return null; // avoid early evaluate
        final rightNum = _rightDigits.join();
        return '$left $_op $rightNum';
    }
    return null;
  }

  // _evaluate removed (no '=' key). Chaining handles evaluations when selecting a new operator.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Kalkulator Waktu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              try {
                Scaffold.of(context).openDrawer();
              } catch (_) {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
        ),
        actions: const [],
      ),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with app description (icon left, text right)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[600]!, Colors.purple[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.access_time, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Kalkulator Waktu',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hitung penjumlahan, pengurangan, perkalian, dan pembagian untuk format waktu.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF2C2C2C)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF404040)
                      : Colors.grey[300]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ExpressionDisplay(
                    leftDigits: _leftDigits,
                    rightDigits: _rightDigits,
                    operatorSymbol: _op,
                    formatSecondsForDisplay: _formatSecondsForDisplay,
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Text(
                    _formatSecondsForResult(
                      TimeCalculationService.parseToSeconds(_result),
                    ),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TimeKeypad(onKey: _onKey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpressionDisplay extends StatelessWidget {
  final List<String> leftDigits;
  final List<String> rightDigits;
  final String? operatorSymbol;
  final String Function(int) formatSecondsForDisplay;

  const _ExpressionDisplay({
    required this.leftDigits,
    required this.rightDigits,
    required this.operatorSymbol,
    required this.formatSecondsForDisplay,
  });

  int _parseDigitsToSeconds(List<String> digits) {
    if (digits.isEmpty) return 0;
    final s = digits.join();
    final len = s.length;
    int sec = 0, min = 0, hour = 0;
    if (len <= 2) {
      sec = int.parse(s);
    } else if (len <= 4) {
      sec = int.parse(s.substring(len - 2));
      min = int.parse(s.substring(0, len - 2));
    } else {
      sec = int.parse(s.substring(len - 2));
      min = int.parse(s.substring(len - 4, len - 2));
      hour = int.parse(s.substring(0, len - 4));
    }
    return hour * 3600 + min * 60 + sec;
  }

  @override
  Widget build(BuildContext context) {
    final leftSecs = _parseDigitsToSeconds(leftDigits);
    final leftText = formatSecondsForDisplay(leftSecs);
    String text = leftText.isEmpty ? '00:00' : leftText;
    if (operatorSymbol != null) {
      text += ' $operatorSymbol';
      if (operatorSymbol == '*' || operatorSymbol == '/') {
        final rightText = rightDigits.isEmpty ? '' : rightDigits.join();
        if (rightText.isNotEmpty) text += ' $rightText';
      } else {
        final rightSecs = _parseDigitsToSeconds(rightDigits);
        final rightText = rightDigits.isEmpty ? '00:00' : formatSecondsForDisplay(rightSecs);
        text += ' $rightText';
      }
    }
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[300]
            : Colors.black87,
      ),
      textAlign: TextAlign.right,
    );
  }
}
