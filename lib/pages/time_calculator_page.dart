import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late FocusNode _focusNode;

  final List<String> _leftDigits = [];
  final List<String> _rightDigits = [];
  String? _op;
  String _result = '00:00';
  String? _error;
  final List<String> _cachedResultDigits = [];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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

      if (RegExp(r'^\d$').hasMatch(key) || key == '00') {
        if (_op == null) {
          if (key == '00') {
            _leftDigits.addAll(['0', '0']);
          } else {
            _leftDigits.add(key);
          }
        } else {
          if (key == '00') {
            _rightDigits.addAll(['0', '0']);
          } else {
            _rightDigits.add(key);
          }
        }
        _updatePreview();
      }
    });
  }

  void _clearAll() {
    _leftDigits.clear();
    _rightDigits.clear();
    _op = null;
    _result = '00:00';
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
    if (_op != null && _rightDigits.isNotEmpty) {
      if (_tryEvaluate()) {
        _leftDigits
          ..clear()
          ..addAll(_secondsToDigits(_parseDigitsToSeconds(_cachedResultDigits)));
        _rightDigits.clear();
      }
    }
    _op = op;
  }

  int _parseDigitsToSeconds(List<String> digits) {
    if (digits.isEmpty) return 0;
    final s = digits.join();
    final len = s.length;
    int min = 0, hour = 0;
    if (len <= 2) {
      min = int.parse(s);
    } else if (len == 3) {
      hour = int.parse(s.substring(0, 1));
      min = int.parse(s.substring(1));
    } else if (len >= 4) {
      hour = int.parse(s.substring(0, len - 2));
      min = int.parse(s.substring(len - 2));
    }
    return hour * 3600 + min * 60;
  }

  String _formatSecondsForDisplay(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final rem = totalSeconds % 3600;
    final m = rem ~/ 60;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(h)}:${two(m)}';
  }

  String _formatDigitsFull(List<String> digits) {
    final secs = _parseDigitsToSeconds(digits);
    return TimeCalculationService.formatSeconds(secs);
  }

  String _getMainResult(String result) {
    final parenIndex = result.indexOf(' (');
    if (parenIndex != -1) return _formatResultForDisplay(result.substring(0, parenIndex));
    return _formatResultForDisplay(result);
  }

  String? _getWrappedResult(String result) {
    final startParen = result.indexOf('(');
    final endParen = result.lastIndexOf(')');
    if (startParen != -1 && endParen != -1 && endParen > startParen) {
      return _formatResultForDisplay(result.substring(startParen + 1, endParen));
    }
    return null;
  }

  String _formatResultForDisplay(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return hhmm;
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(h)}:${two(m)}';
  }

  bool _tryEvaluate() {
    try {
      final expr = _buildExpression(forEvaluate: true);
      if (expr == null) return false;
      final res = TimeCalculationService.evaluate(expr);
      _result = res;
      _error = null;
      _cachedResultDigits
        ..clear()
        ..addAll(_resultToDigits(res));
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  List<String> _secondsToDigits(int totalSeconds) {
    final formatted = TimeCalculationService.formatSeconds(totalSeconds);
    final parts = formatted.split(':');
    final h = parts[0];
    final m = parts[1];
    final digits = <String>[];
    if (h != '00') digits.addAll(h.replaceFirst(RegExp(r'^0'), '').split(''));
    digits.addAll(m.split(''));
    return digits;
  }

  List<String> _resultToDigits(String hhmm) {
    final parts = hhmm.split(':');
    final h = parts[0];
    final m = parts[1];
    final digits = <String>[];
    if (h != '00') digits.addAll(h.replaceFirst(RegExp(r'^0'), '').split(''));
    digits.addAll(m.split(''));
    return digits;
  }

  void _updatePreview() {
    final expr = _buildExpression(forEvaluate: true);
    if (expr == null) {
      final leftSecs = _parseDigitsToSeconds(_leftDigits);
      _result = TimeCalculationService.formatSeconds(leftSecs);
      return;
    }
    try {
      _result = TimeCalculationService.evaluate(expr);
      _error = null;
    } catch (e) {
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
        final right = _rightDigits.isEmpty ? '00:00' : _formatDigitsFull(_rightDigits);
        return '$left $_op $right';
      case '*':
      case '/':
        if (_rightDigits.isEmpty) return null;
        final rightNum = _rightDigits.join();
        return '$left $_op $rightNum';
    }
    return null;
  }

  // Keyboard handling
  void _handleRawKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey;
      final ch = event.character ?? key.keyLabel;
      if (ch.isNotEmpty) {
        final s = ch;
        if (RegExp(r'^\d$').hasMatch(s)) {
          _onKey(s);
          return;
        }
        if (s == '+') {
          _onKey('+');
          return;
        }
        if (s == '-') {
          _onKey('-');
          return;
        }
        if (s == '*') {
          _onKey('*');
          return;
        }
        if (s == '/') {
          _onKey('/');
          return;
        }
      }
      if (key == LogicalKeyboardKey.backspace) {
        _onKey('C');
      } else if (key == LogicalKeyboardKey.delete || key == LogicalKeyboardKey.escape) {
        _onKey('AC');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Kalkulator Waktu', style: TextStyle(fontWeight: FontWeight.bold)),
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
      ),
      drawer: const MainDrawer(),
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleRawKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha((0.2 * 255).toInt()),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(Icons.access_time, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Kalkulator Waktu',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Kalkulator untuk menghitung penjumlahan, pengurangan, perkalian, dan pembagian dalam format waktu.',
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
                      color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2C) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF404040) : Colors.grey[300]!),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(_getMainResult(_result), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                            if (_getWrappedResult(_result) != null) ...[
                              const SizedBox(height: 4),
                              Text('atau ${_getWrappedResult(_result)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Theme.of(context).brightness == Brightness.dark ? Colors.blue[300] : Colors.blue[700])),
                            ],
                          ],
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 8),
                          Text(_error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.right),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 720), child: TimeKeypad(onKey: _onKey))),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  const _ExpressionDisplay({required this.leftDigits, required this.rightDigits, required this.operatorSymbol, required this.formatSecondsForDisplay});

  int _parseDigitsToSeconds(List<String> digits) {
    if (digits.isEmpty) return 0;
    final s = digits.join();
    final len = s.length;
    int min = 0, hour = 0;
    if (len <= 2) {
      min = int.parse(s);
    } else if (len == 3) {
      hour = int.parse(s.substring(0, 1));
      min = int.parse(s.substring(1));
    } else if (len >= 4) {
      hour = int.parse(s.substring(0, len - 2));
      min = int.parse(s.substring(len - 2));
    }
    return hour * 3600 + min * 60;
  }

  @override
  Widget build(BuildContext context) {
    final leftSecs = _parseDigitsToSeconds(leftDigits);
    final leftText = formatSecondsForDisplay(leftSecs);
    String text = leftDigits.isEmpty ? '00:00' : leftText;
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
    return Text(text, style: TextStyle(fontSize: 20, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[300] : Colors.black87), textAlign: TextAlign.right);
  }
}
 
